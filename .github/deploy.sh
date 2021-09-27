#!/bin/bash
set -euox pipefail

echo "installing ingress"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

echo "creating folder secrets..."
mkdir -p secrets/

echo "creating the microgateway secret..."
echo "${MICROGATEWAY_LIC}" > secrets/microgateway.lic
kubectl create secret generic microgateway-license \
  --from-file=license=secrets/microgateway.lic \
  --dry-run=client \
  -o yaml > secrets/microgateway-license.yaml

echo "creating the iam secret..."
echo "${IAM_LIC}" > secrets/iam.lic
kubectl create secret generic iam-license \
  --from-file=license.txt=secrets/iam.lic \
  --dry-run=client \
  -o yaml > secrets/iam-license.yaml

echo "creating docker secret..."
kubectl create secret docker-registry dockerregcred \
  --docker-server='https://index.docker.io/v1/' \
  --docker-username="${DOCKER_USER}" \
  --docker-password="${DOCKER_TOKEN}" \
  --docker-email="${DOCKER_EMAIL}" \
  --dry-run=client \
  -o yaml > secrets/dockerhub-secret.yaml

echo "creating the secrets..."
kubectl apply -f secrets/

echo "creating the namespace argocd with the secret dockerregcred..."
kubectl create ns argocd --dry-run=client -o yaml > /tmp/argocd-ns.yaml
kubectl apply -f /tmp/argocd-ns.yaml
kubectl apply -n argocd -f secrets/dockerhub-secret.yaml

echo "installing ArgoCD"
kubectl apply -k apps/argo-cd/

echo "wait until ArgoCD is ready"
kubectl -n argocd wait --for=condition=ready --timeout=600s pod -l app=argo

echo "deploying the example..."
kubectl apply -f example/premium-with-iam.yaml
sleep 30

echo "wait and display status of resources"
# Argocd creates new deployments. To ensure that all 
# deployments are up and running, more than one check 
# with 'kubectl wait' is required.
retry=0
maxRetries=10
success=0
deployedOnSuccess=2
until [ ${retry} -ge ${maxRetries} ]
do
  set +e pipefail
  kubectl wait --for=condition=ready --timeout=30s --all pod
  rc=$?
  set -e pipefail

  if [ ${rc} -eq 0 ]
  then
    success=$((success+1))
  fi

  if [ ${success} -ge ${deployedOnSuccess} ]
  then
    break
  fi

  sleep 30
  retry=$((retry+1))
done
