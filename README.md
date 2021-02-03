# Airlock Minikube Example

This repository contains a deployment example for [Airlock] on [Minikube]. It shows how to protect a backend application with Airlock Microgateway and how to identify users using Airlock IAM. The
source code is available under the [MIT license].

## About Ergon

*Airlock* is a registered trademark of [Ergon]. Ergon is a Swiss leader in leveraging digitalisation to create unique and effective client benefits, from conception to market, the result of which is
the international distribution of globally revered products.

## Prerequisites

* Install [Minikube].
* Install [kubectl].
* A Docker Hub account with access to the private repositories:
    * `hub.docker.com/r/ergon/airlock-microgateway`
    * `hub.docker.com/r/ergon/airlock-iam`  
      :exclamation: Please contact `order@airlock.com` to get access to the private repositories.
* Airlock license files:
    * A valid license for Airlock Microgateway
    * A valid license for Airlock IAM  
      :exclamation: Airlock Microgateway and Airlock IAM do not work without a valid license. Please contact `order@airlock.com` to get temporary Airlock license files.

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
kubectl apply -f data/
kubectl wait --for=condition=ready --timeout=300s pod/data-pod
kubectl cp data/ data-pod:/
kubectl exec data-pod -- sh -c "chown -R 1000:0 /data/iam/"
kubectl delete -f data/
```

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

Open a browser to navigate to the different web applications. Use `2fa` as the username and `password` as the password to authenticate.

* Kibana URL: `https://<MINIKUBE_IP>/kibana`
* Echoserver URL: `https://<MINIKUBE_IP>/echo`
* Adminer URL:  `https://<MINIKUBE_IP>/adminer`

Use the Airlock IAM Adminapp to administer users and their login factors.

* Airlock IAM Adminapp URL: `https://<MINIKUBE_IP>/auth-admin`
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

[MIT license]: https://github.com/ergon/airlock-minikube-examples/blob/main/LICENSE

[Airlock]: https://www.airlock.com/

[Ergon]: https://www.ergon.ch/

[Minikube]: https://minikube.sigs.k8s.io/

[kubectl]: https://kubernetes.io/docs/reference/kubectl/overview/
