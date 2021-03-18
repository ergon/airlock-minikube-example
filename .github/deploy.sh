#!/bin/bash
set -euox pipefail

echo "installing ingress"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "creating microgateway secrets..."
openssl rand -base64 102 | tr -d '\n' > init/microgateway.passphrase
echo ${MICROGATEWAY_LIC} > init/microgateway.lic
kubectl create secret generic microgateway-secret \
  --from-file=license=init/microgateway.lic \
  --from-file=passphrase=init/microgateway.passphrase

echo "creating iam secrets..."
echo ${IAM_LIC} > init/iam.lic
kubectl create secret generic iam-secret \
  --from-file=license.txt=init/iam.lic

echo "creating secrets for JWT"
openssl rand -base64 32 | tr -d '\n' > init/jwt.encryption.passphrase
openssl rand -base64 64 | tr -d '\n' > init/jwt.signature.passphrase
kubectl create secret generic jwt-secret \
   --from-file=JWT_ENCRYPTION_PASSPHRASE=init/jwt.encryption.passphrase \
   --from-file=JWT_SIGNATURE_PASSPHRASE=init/jwt.signature.passphrase \
   --from-literal=COOKIE_NAME=iam_auth \
   --from-literal=JWT_ROLE=customer

echo "creating mariadb secrets..."
kubectl create secret generic mariadb-secret \
  --from-literal=MYSQL_DATABASE=iamdb \
  --from-literal=MYSQL_ROOT_PASSWORD=$(openssl rand -base64 36) \
  --from-literal=MYSQL_USER=airlock \
  --from-literal=MYSQL_PASSWORD=$(openssl rand -base64 36)

echo "creating docker secret..."
kubectl create secret docker-registry dockerregcred \
  --docker-server='https://index.docker.io/v1/' \
  --docker-username=${DOCKER_USER} \
  --docker-password=${DOCKER_TOKEN} \
  --docker-email=${DOCKER_EMAIL}

kubectl describe secret dockerregcred

echo "initializing config data..."
cp ./.github/kind/kust-base.yaml init/kustomization.yaml
kubectl apply -k ./.github/kind
sleep 60
echo "showing data-pod status..."
kubectl get pods
kubectl describe pod/data-pod
kubectl logs data-pod -c iam-init
kubectl logs data-pod

echo "preparing data-pod..."
kubectl wait --for=condition=ready --timeout=300s pod/data-pod
kubectl cp data/ data-pod:/
kubectl exec data-pod -- sh -c "chown -R 1000:0 /data/iam/"
kubectl exec data-pod -- sh -c "chown -R 999:999 /data/mariadb/"

echo "deploying example..."
kubectl apply -f example/

echo "wait and display status of resources"
sleep 60
kubectl get all
kubectl rollout status deployment redis --timeout 60s
kubectl rollout status deployment echoserver --timeout 60s
sleep 90
kubectl get all
kubectl rollout status deployment microgateway-echoserver --timeout 120s
kubectl rollout status deployment microgateway-iam --timeout 30s
kubectl rollout status deployment microgateway-kibana --timeout 30s
kubectl rollout status deployment kibana --timeout 100s
kubectl rollout status deployment elasticsearch --timeout 100s
kubectl rollout status deployment iam --timeout 200s
kubectl get all
