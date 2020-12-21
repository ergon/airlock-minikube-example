# airlock-minikube-examples
This repository contains a example deployments for [Airlock](https://www.airlock.com/en/) and allows to demonstrate easily its functionalities.

The `airlock-minikube-examples` examples are used internally and we make them available publicly under the [MIT license](https://github.com/ergon/airlock-minikube-examples/blob/main/LICENSE).

## About Ergon
*Airlock* is a registered trademark of [Ergon](https://www.ergon.ch). Ergon is a Swiss leader in leveraging digitalisation to create unique and effective client benefits, from conception to market, the result of which is the international distribution of globally revered products.

## Table of contents
* [Introduction](#introduction)
* [Prerequisites](#prerequisites)
* [Start Minikube](#start-minikube)
* [Prepare for the deployment](#prepare-for-the-deployment)
* [Start the deployment](#start-the-deployment)
* [Use the demo](#use-the-demo)
* [Cleanup](#cleanup)

## Introduction
This setup spins up an Airlock Microgateway, Airlock IAM and additional containers in order to make the use cases working and having the possibility to monitor what is happening.

## Prerequisites
* Install `Minikube`
* Install `kubectl`
* A Docker Hub account granted to access the private repositories:
  * hub.docker.com/r/ergon/airlock-microgateway
  * hub.docker.com/r/ergon/airlock-iam<br>
  :exclamation: To get the permissions to access these private Docker Hub repositories, please contact order@airlock.com.
* Airlock licenses
  * A valid license for Airlock Microgateway<br>
  :exclamation: The Airlock products do not work without a valid license. To order one, please contact order@airlock.com.

## Start Minikube
Start Minikube and configure ingress by running the following commands:
```console
minikube start --vm=true --cpus=2 --memory=10240 --disk-size='40gb' --addons=ingress
kubectl apply -f ingress/
```

## Prepare for the deployment
Several Kubernetes secrets are created within this chapter.<br>
They are used later on in the deployment process. Without them, the deployment will fail.

### Create a secret for the Microgateway license and passphrase
After proceeding the steps below, a secret with the name `microgateway-secrets` is created containing the Microgateway `license` and a `passphrase` to encrypt/decrypt URLs.<br>
Follow the instructions below:
* Save the Microgateway license file in `params/microgateway.lic`
* Generate a passphrase in `params/microgateway.passphrase`:
```console
openssl rand -base64 102 | tr -d '\n' > params/microgateway.passphrase
```
* Create the secret `microgateway-secrets`:
```console
kubectl create secret generic microgateway-secrets \
  --from-file=license=params/microgateway.lic \
  --from-file=passphrase=params/microgateway.passphrase \
  --dry-run=client \
  -o yaml > params/microgateway-secret.yaml
kubectl apply -f params/microgateway-secret.yaml
```
### Create a secret for the MariaDB database which is used by Airlock IAM
After proceeding the steps below, a secret with the name `mariadb-secrets` is created.<br>
Follow the instructions below:
* Create the secret `mariadb-secrets`:
```console
kubectl create secret generic mariadb-secrets \
  --from-literal=MYSQL_DATABASE=iam \
  --from-literal=MYSQL_ROOT_PASSWORD=$(openssl rand -base64 36) \
  --from-literal=MYSQL_USER=iam \
  --from-literal=MYSQL_PASSWORD=$(openssl rand -base64 36) \
  --dry-run=client \
  -o yaml > params/mariadb-secret.yaml
kubectl apply -f params/mariadb-secret.yaml
```

### Create a secret for the IAM license
After proceeding the steps below, a secret with the name `iam-secrets` is created containing the IAM `license.txt`.<br>
Follow the instructions below:
* Save the IAM license file in `params/iam.lic`
* Create the secret `iam-secrets`:
```console
kubectl create secret generic iam-secrets \
  --from-file=license.txt=params/iam.lic \
  --dry-run=client \
  -o yaml > params/iam-secret.yaml
kubectl apply -f params/iam-secret.yaml
```

### Create a DockerHub secret to pull the Airlock images
The Airlock Docker images are in a private DockerHub repository. To download them, create a pull secret and replace the values in `<...>`. The DockerHub user must be granted to download the images.
```console
kubectl create secret docker-registry dockerregcred \
  --docker-server='https://index.docker.io/v1/' \
  --docker-username=<DOCKER_USER> \
  --docker-password=<DOCKER_PASSWORD> \
  --docker-email=<DOCKER_EMAIL> \
  --dry-run=client \
  -o yaml > params/dockerhub-secret.yaml
kubectl apply -f params/dockerhub-secret.yaml
```

## Start the deployment
To deploy the demo setup, run the following commands:
```console
kubectl apply -f efk/
kubectl apply -f redis/
kubectl apply -f echoserver/
kubectl apply -f iam/
```

## Use the demo
Figure out the IP address of Minikube:
```console
minikube ip
```
Open a browser to navigate the different web applications:
* Kibana URL: `https://$(minikube ip)/kibana`
* Echoserver URL: `https://$(minikube ip)/echo`<br>
* IAM Admin App URL: `https://$(minikube ip)/auth-admin`<br>
* Adminer URL:  `https://$(minikube ip)/adminer`<br>

## Cleanup
The following chapter describes the possibilities to cleanup the deployment/installation. This could be handy in order to restart from stratch or just to clean the environment.

### Delete the deployment
To delete the Kuberenetes deployment, run the following commands:
```console
kubectl delete -f efk/
kubectl delete -f redis/
kubectl delete -f echoserver/
kubectl delete -f iam/
```

### Delete Minikube
If Minikube is not needed anymore or to redeploy everything again, do the following:
```console
minikube delete
```