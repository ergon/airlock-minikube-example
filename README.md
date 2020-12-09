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

## Start Minikube
Start Minikube by running the following command:
```console
minikube start --vm=true --cpus=2 --memory=10240 --disk-size='40gb' --addons=ingress
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
  --from-file=passphrase=params/microgateway.passphrase
```

### Create a DockerHub secret to pull the Airlock images
The Airlock Docker images are in a private DockerHub repository. To download them, create a pull secret and replace the values in `<...>`. The DockerHub user must be granted to download the images.
```console
kubectl create secret docker-registry dockerregcred \
  --docker-server='https://index.docker.io/v1/' \
  --docker-username=<DOCKER_USER> \
  --docker-password=<DOCKER_PASSWORD> \
  --docker-email=<DOCKER_EMAIL>
```

## Start the deployment
To deploy the demo setup, run the following commands:
```console
kubectl apply -f efk/
```

## Use the demo
Figure out the IP address of Minikube:
```console
minikube ip
```
Open a browser to navigate the different web applications:
* Kibana URL: `http://$(minikube ip)/kibana`

## Cleanup
The following chapter describes the possibilities to cleanup the deployment/installation. This could be handy in order to restart from stratch or just to clean the environment.

### Delete the deployment
To delete the Kuberenetes deployment, run the following commands:
```console
kubectl delete -f efk/
```

### Delete Minikube
If Minikube is not needed anymore or to redeploy everything again, do the following:
```console
minikube delete
```