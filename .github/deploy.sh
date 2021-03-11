#!/bin/bash
set -euox pipefail

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

echo "initializing config data..."
kubectl apply -f init/
sleep 30
echo "showing data-pod status..."
kubectl get pods
kubectl logs data-pod
kubectl logs data-pod -c iam-init

echo "preparing data-pod..."
kubectl wait --for=condition=ready --timeout=300s pod/data-pod
kubectl cp data/ data-pod:/
kubectl exec data-pod -- sh -c "chown -R 1000:0 /data/iam/"
kubectl exec data-pod -- sh -c "chown -R 999:999 /data/mariadb/"

echo "deploying example..."
kubectl apply -f example/

echo "wait and display status of resources"
sleep 300
kubectl get all
