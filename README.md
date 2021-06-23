# Airlock Minikube Example

This repository contains deployment examples for [Airlock] on [Minikube]. It shows how to protect a backend application with Airlock Microgateway and how to identify users using Airlock IAM. The
source code is available under the [MIT license].

## Overview

![Overview](/.github/images/overview.svg)


The different components in the example are described below:
* The Ingress controller is accepting the external traffic and forwards it to the designated Microgateway service.
* A specific Airlock Microgateway protects each of the following services:
  * Airlock IAM, which is accessible for unauthenticated users. Filters, OpenAPI specifications and other security features protects IAM against attacks.
  * Echo Server, which is only accessible for authenticated users and restrictive deny rules are enabled.
  * Grafana, which is only accessible for authenticated users.
  * Kibana, which is only accessible for authenticated users.
* Airlock IAM authenticates users for services with authentication enforcement configured in the Microgateway. 
  * For the Echo Server, the authenticated user is federated through a JWT token in a cookie.
  * For Grafana, the IAM and Grafana Microgateway share the same Redis instance and therefore hold the same session data.
  * For Kibana, the IAM and Kibana Microgateway share the same Redis instance and therefore hold the same session data.

## About Ergon

*Airlock* is a registered trademark of [Ergon]. Ergon is a Swiss leader in leveraging digitalisation to create unique and effective client benefits, from conception to market, the result of which is
the international distribution of globally revered products.

## Disclaimer

Airlock Microgateway is available as community and premium edition. The differences between these two editions are documented [here](https://docs.airlock.com/microgateway/latest/?topic=MGW-00000056).
The Airlock Minikube Example has been designed for the premium edition and requires Airlock IAM. Nevertheless, the example might be also useful for the community edition but 
definitely does not unleash the whole power of the Airlock suite. Because it is designed for the premium edition, all instructions are laied-out for this edition.

## Prerequisites

* Install [Minikube].<br>
  The Airlock Minikube Example has been tested with the following versions:

  | Airlock Minikube Example | Minikube | Kubernetes | Comments                                                 |
  |:-------------------------|:---------|:-----------|:---------------------------------------------------------|
  | v2.0.0                   | v1.19.0  | v1.20.2    | [Known bug](#creating-ingress-causes-a-validation-error) |

  :warning: Using different versions may cause problems.
* Install [kubectl].
* Access to the public repositories:
    * `hub.docker.com/r/ergon/airlock-microgateway-configbuilder`
    * `hub.docker.com/r/ergon/airlock-microgateway`
    :exclamation: The Microgateway repositories are public, but Docker has [rate limits](https://www.docker.com/increase-rate-limits) for anonymous users in place. Therefore, it is recommended to use a Docker Hub account to pull the image.
* A Docker Hub account with access to the private repository:
    * `hub.docker.com/r/ergon/airlock-iam`  
      :exclamation: Please contact `order@airlock.com` to get access to the private repositories.
* Airlock license files:
    * A valid license for Airlock Microgateway
      :exclamation: Without a valide license, Airlock Microgateway works as community edition with [limited functionality](https://docs.airlock.com/microgateway/latest/?topic=MGW-00000056). The example is designed for the premium edition.
    * A valid license for Airlock IAM  
      :exclamation: Airlock IAM does not work without a valid license. Please contact `order@airlock.com` to get temporary Airlock license files.

## Start Minikube

Start Minikube and configure ingress by running the following command:

```console
minikube start --vm=true --memory=8g --addons=ingress
```

This deployment example requires `--vm=true` so we can use `--addons=ingress`.

## Copy licenses and create secrets

### Airlock Microgateway

* Copy the Airlock Microgateway license file to `init/microgateway.lic`.
* Generate a passphrase and save it to `init/microgateway.passphrase`:

```console
openssl rand -base64 102 | tr -d '\n' > init/microgateway.passphrase
```

* Create the secret `microgateway-secret`:

```console
kubectl create secret generic microgateway-secret \
  --from-file=license=init/microgateway.lic \
  --from-file=passphrase=init/microgateway.passphrase \
  --dry-run=client \
  -o yaml > init/microgateway-secret.yaml
```

### Airlock IAM

* Copy the Airlock IAM license file to `init/iam.lic`.
* Create the secret `iam-secret`:

```console
kubectl create secret generic iam-secret \
  --from-file=license.txt=init/iam.lic \
  --dry-run=client \
  -o yaml > init/iam-secret.yaml
```

### JSON Web Token

* Generate the two secrets for the JSON Web Token.
    * `init/jwt.encryption.passphrase`
    * `init/jwt.signature.passphrase`

```console
openssl rand -base64 32 | tr -d '\n' > init/jwt.encryption.passphrase
openssl rand -base64 64 | tr -d '\n' > init/jwt.signature.passphrase
```

* Create the secret `jwt-secret`:

```console
kubectl create secret generic jwt-secret \
  --from-file=JWT_ENCRYPTION_PASSPHRASE=init/jwt.encryption.passphrase \
  --from-file=JWT_SIGNATURE_PASSPHRASE=init/jwt.signature.passphrase \
  --from-literal=COOKIE_NAME=iam_auth \
  --dry-run=client \
  -o yaml > init/jwt-secret.yaml
```

### MariaDB

Airlock IAM uses MariaDB as storage backend.

* Create the secret `mariadb-secret`:

```console
kubectl create secret generic mariadb-secret \
  --from-literal=MYSQL_DATABASE=iamdb \
  --from-literal=MYSQL_ROOT_PASSWORD=$(openssl rand -base64 36) \
  --from-literal=MYSQL_USER=airlock \
  --from-literal=MYSQL_PASSWORD=$(openssl rand -base64 36) \
  --dry-run=client \
  -o yaml > init/mariadb-secret.yaml
```

### Docker Hub

A Docker Hub account with access to the private repositories is needed in order to pull Airlock docker images.

```console
kubectl create secret docker-registry dockerregcred \
  --docker-server='https://index.docker.io/v1/' \
  --docker-username=<DOCKER_USER> \
  --docker-password=<DOCKER_PASSWORD> \
  --docker-email=<DOCKER_EMAIL> \
  --dry-run=client \
  -o yaml > init/dockerhub-secret.yaml
```

## Create Kubernetes objects and initialize volumes

Run the following command to create Kubernetes objects and initialize volumes:

```console
kubectl apply -f init/
```

Run the following commands to copy data and configuration files to the data volume:

```console
kubectl wait --for=condition=ready --timeout=300s pod/data-pod
kubectl cp data/ data-pod:/
kubectl exec data-pod -- sh -c "chown -R 1000:0 /data/iam/"
kubectl exec data-pod -- sh -c "chown -R 999:999 /data/mariadb/"
kubectl exec data-pod -- sh -c "chown -R 1000:0 /data/kibana/"
```
:exclamation: Run the commands line by line because `kubectl wait` is non-blocking.

## Start deployment

To deploy the example, run the following command:

```console
kubectl apply -f example/
```

## Use the example

Get the Minikube IP address:

```console
minikube ip
```

Open a browser to navigate to the different web applications. Use `user` as the username and `password` as the password to authenticate.

* Echoserver URL: `https://<MINIKUBE_IP>/echo/`
* Grafana URL: `https://<MINIKUBE_IP>/grafana/`
* Kibana URL: `https://<MINIKUBE_IP>/kibana/`

Use the Airlock IAM Adminapp to administer users and their login factors.

* Airlock IAM Adminapp URL: `https://<MINIKUBE_IP>/auth-admin/`
    * Username: `admin`
    * Password: `password`

## Cleanup

To delete the deployment example, run the following command:

```console
kubectl delete -f example/
```

If Minikube is not needed anymore or to restart from scratch, run this command:

```console
minikube delete
```

## Troubleshooting

### Creating ingress causes a validation error

Running the command `kubectl apply -f example/` prints the following error message:
```
W0413 16:20:57.488050 1 dispatcher.go:134] Failed calling webhook, failing closed validate.nginx.ingress.kubernetes.io: failed calling webhook "validate.nginx.ingress.kubernetes.io": an error on the server ("") has prevented the request from succeeding
```
The reason is a bug in Minikube v1.19.0 [issue 11121](https://github.com/kubernetes/minikube/issues/11121).

As a workaround, run the following command:
```console
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```



[MIT license]: https://github.com/ergon/airlock-minikube-examples/blob/main/LICENSE

[Airlock]: https://www.airlock.com/

[Ergon]: https://www.ergon.ch/

[Minikube]: https://minikube.sigs.k8s.io/

[kubectl]: https://kubernetes.io/docs/reference/kubectl/overview/
