# Airlock Minikube Example

This repository contains deployment examples for [Airlock] on [Minikube]. It shows how to protect a backend application with Airlock Microgateway and how to authenticate users using Airlock IAM. The
source code is available under the [MIT license].

## About Ergon

*Airlock* is a registered trademark of [Ergon]. Ergon is a Swiss leader in leveraging digitalisation to create unique and effective client benefits, from conception to market, the result of which is
the international distribution of globally revered products.

## Overview

![Overview](/.github/images/overview.svg)

The different components in the example are described below:
* The Ingress controller is accepting the external traffic and forwards it to the designated Microgateway service.
* A specific Airlock Microgateway protects each of the following services:
  * Airlock IAM, which is accessible for unauthenticated users. Filters, OpenAPI specifications and other security features protects IAM against attacks.
  * Echoserver, which is only accessible for authenticated users and restrictive deny rules are enabled.
  * Grafana, which is only accessible for authenticated users.
  * Kibana, which is only accessible for authenticated users.
* Airlock IAM authenticates users for services with authentication enforcement configured in the Microgateway. 
  * For the Echoserver, the authenticated user is federated through a JWT token in a cookie.
  * For Grafana, the IAM and Grafana Microgateway share the same Redis instance and therefore hold the same session data.
  * For Kibana, the IAM and Kibana Microgateway share the same Redis instance and therefore hold the same session data.
* [ArgoCD] is the GitOps tool to deploy and bootstrap the desired scenario.

## Table of contents
- [Airlock Minikube Example](#airlock-minikube-example)
  - [Disclaimer](#disclaimer)
  - [General prerequisites](#general-prerequisites)
  - [Start Minikube](#start-minikube)
  - [Deploy ArgoCD](#deploy-argocd)
  - [Deploy a scenario](#deploy-a-scenario)
    - [Deploy the scenario "Community Edition"](#deploy-the-scenario-community-edition)
    - [Deploy the scenario "Premium Edition"](#deploy-the-scenario-premium-edition)
    - [Deploy the scenario "Premium Edition with IAM"](#deploy-the-scenario-premium-edition-with-iam)
  - [Use the example](#use-the-example)
  - [Cleanup](#cleanup)
  - [FAQ](#faq)
    - [How to generate traffic](#how-to-generate-traffic)
    - [How to customize the example](#how-to-customize-the-example)
    - [How to access the ArgoCD Web UI](#how-to-access-the-argocd-web-ui)
  - [Additional information](#additional-information)

## Disclaimer

Airlock Microgateway is available as community and premium edition. The differences between these two editions are documented [here](https://docs.airlock.com/microgateway/latest/?topic=MGW-00000056).

The Airlock Minikube Example can be deployed in the following scenarios:
* [Community Edition](#deploy-the-scenario-community-edition): Airlock Microgateway is deployed without a license and without Airlock IAM.
* [Premium Edition](#deploy-the-scenario-premium-edition): Airlock Microgateway is deployed with a valid license but without Airlock IAM.
* [Premium Edition with IAM](#deploy-the-scenario-premium-edition-with-iam): Airlock Microgateway is deployed with Airlock IAM. Both products have a valid license.

Starting the example as community edition might be useful to get familiar with the product and understand the benefit of Airlock Microgateway. Nevertheless, for best security a licensed Airlock Microgateway with Airlock IAM is recommended.

## General prerequisites

* Install [Minikube].<br>
  The Airlock Minikube Example has been tested with the following versions:

  | Airlock Minikube Example | Minikube | Kubernetes | Comments |
  | :----------------------- | :------- | :--------- | :------- |
  | v3.0.0                   | v1.22.0  | v1.20.2    |          |

  :warning: Using different versions may cause problems.
* Install [kubectl].
* Access to the Docker Hub repositories:
    * For Airlock Microgateway (public repository):
        * `hub.docker.com/r/ergon/airlock-microgateway-configbuilder`
        * `hub.docker.com/r/ergon/airlock-microgateway`
    * For Airlock IAM (private repository):
        * `hub.docker.com/r/ergon/airlock-iam`
* :exclamation: Since Docker has [rate limits](https://www.docker.com/increase-rate-limits) in place for anonymous users, it is recommended to use an account to have higher rate limits.

## Start Minikube

Start Minikube and configure ingress by running the following command:

```console
minikube start --vm=true --memory=10g --kubernetes-version=v1.20.2 --addons=ingress
```

This deployment example requires:
  * at least 10GB memory (`--memory=10g`).
  * `--vm=true` in order to use `--addons=ingress`.

## Deploy ArgoCD

To deploy the Airlock Minikube Example in a certain scenario, the GitOps tool [ArgoCD] is being used. Therefore, before proceeding with the deployment, [ArgoCD] must be deployed first:

```console
# Install ArgoCD
kubectl apply -k apps/argo-cd/

# Wait until all pods are ready
kubectl -n argocd wait --for=condition=ready --timeout=600s pod -l app=argo
```

## Deploy a scenario

The Airlock Minikube Example has been made available in different scenarios. The difference is whether you have a license and access to the private Docker Hub repository of Airlock IAM or not. Choose the scenario which suits best for you and which prerequisites you fulfill.

### Deploy the scenario "Community Edition"

To deploy the example in the scenario, run the following command:

```console
kubectl apply -f example/community.yaml
```

Wait until all pods have been deployed and are ready. This takes usually 5-15 minutes but could vary, depending on your internet connectivity to pull the images and your computer to start the pods.

### Deploy the scenario "Premium Edition"

This scenario requires the following in addition to the [general prerequisites](#general-prerequisites):
* Valid license for Airlock Microgateway

:exclamation: Please contact `order@airlock.com` to get a temporary license.

Before deploying the scenario, do the following:
* Copy the Airlock Microgateway license file to `secrets/microgateway.lic`.
* Create the secret `microgateway-license`:

The instructions below explain the steps to fulfill the prerequisites:

```console
# Create the Kubernetes manifest file for the secret microgateway-license
kubectl create secret generic microgateway-license \
  --from-file=license=secrets/microgateway.lic \
  --dry-run=client \
  -o yaml > secrets/microgateway-license.yaml

# Create the secret
kubectl apply -f secrets/
```

To deploy the example in the scenario, run the following command:

```console
kubectl apply -f example/premium.yaml
```

Wait until all pods have been deployed and are ready. This takes usually 5-15 minutes but could vary, depending on your internet connectivity to pull the images and your computer to start the pods.

### Deploy the scenario "Premium Edition with IAM"

This scenario requires the following in addition to the [general prerequisites](#general-prerequisites):
* Valid license for Airlock Microgateway
* Valid license for Airlock IAM
* A Docker Hub account with access to the private Docker Hub repository of Airlock IAM

:exclamation: Please contact `order@airlock.com` to get a temporary licenses or grant your Docker Hub account for the Airlock IAM repository.

Before deploying the scenario, do the following:
* Copy the Airlock Microgateway license file to `secrets/microgateway.lic`.
* Copy the Airlock IAM license file to `secrets/iam.lic`.
* Create the secret `microgateway-license`.
* Create the secret `iam-license`.
* Create the secret `dockerregcred`.

The instructions below explain the steps to fulfill the prerequisites:

```console
# Create the Kubernetes manifest file for the secret microgateway-license
kubectl create secret generic microgateway-license \
  --from-file=license=secrets/microgateway.lic \
  --dry-run=client \
  -o yaml > secrets/microgateway-license.yaml

# Create the Kubernetes manifest file for the secret iam-license
kubectl create secret generic iam-license \
  --from-file=license.txt=secrets/iam.lic \
  --dry-run=client \
  -o yaml > secrets/iam-license.yaml

# Create the Kubernetes manifest file for the secret dockerregcred
kubectl create secret docker-registry dockerregcred \
  --docker-server='https://index.docker.io/v1/' \
  --docker-username=<DOCKER_USER> \
  --docker-password=<DOCKER_PASSWORD> \
  --docker-email=<DOCKER_EMAIL> \
  --dry-run=client \
  -o yaml > secrets/dockerhub-secret.yaml

# Create the secrets
kubectl apply -f secrets/
```

To deploy the example in the scenario, run the following command:

```console
kubectl apply -f example/premium-with-iam.yaml
```

Wait until all pods have been deployed and are ready. This takes usually 5-15 minutes but could vary, depending on your internet connectivity to pull the images and your computer to start the pods.

## Use the example

Get the Minikube IP address:

```console
minikube ip
```

Open a browser to navigate to the different web applications. Use `user` as the username and `password` as the password to authenticate.

* Echoserver URL: `https://<MINIKUBE_IP>/echo/`
* Grafana URL: `https://<MINIKUBE_IP>/grafana/`
* Kibana URL: `https://<MINIKUBE_IP>/kibana/`

Use the Airlock IAM Adminapp to administer users and their login factors (only for [Premium Edition with IAM](#deploy-the-scenario-premium-edition-with-iam)).

* Airlock IAM Adminapp URL: `https://<MINIKUBE_IP>/auth-admin/`
  * Username: `admin`
  * Password: `password`

## Cleanup

To delete the deployment example, run the following command:

```console
# To cleanup the scenario "Community"
kubectl delete -f example/community.yaml

# To cleanup the scenario "Premium"
kubectl delete -f example/premium.yaml

# To cleanup the scenario "Premium with IAM"
kubectl delete -f example/premium-with-iam.yaml
```

If Minikube is not needed anymore or to restart from scratch, run this command:

```console
minikube delete
```

## FAQ 

### How to generate traffic

The Airlock Minikube Example provides helpful saved searches and reports to get quickly an overview. Additionally, Prometheus metrics provide further information. Nevertheless, without traffic it's difficult to get an impression about the reporting and monitoring solution we provide. Therefore, a load generator can be started which creates traffic optimized for the scenario [Premium Edition with IAM](#deploy-the-scenario-premium-edition-with-iam).

To start the load generator, run the following command:
```console
kubectl apply -k apps/artillery/
```

To stop the load generator, run the following command:
```console
kubectl delete -k apps/artillery/
```

### How to customize the example

The Airlock Minikube Example uses the GitOps tool [ArgoCD] to bootstrap the setup. Therefore, it does not work to simply adapt and re-deploy the Kubernetes manifest files. [ArgoCD] periodically checks that the desired state is what is defined in the Git repository. In order to have a customized setup, do the following:

  * Fork this Git repository
  * Change the `repoURL` to match your fork in the following files:
    * `example/community.yaml`
    * `example/premium-with-iam.yaml`
    * `example/premium.yaml`
  * Push the changes in your fork
  * Customize your fork to your desire
  * Run the example by using the adapted `example/*.yaml` files in your fork.

### How to access the ArgoCD Web UI

To check whether [ArgoCD] had issues during the deployment of the example, a look into the Web UI could help.

```console
# Retrieve the admin password
echo $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Start port forwarding for the ArgoCD Web UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Afterwards sign in: `https://localhost:8080/`
  * Username: `admin`
  * Password: `<From the command described above>`

## Additional information
- [Airlock Microgateway](https://www.airlock.com/microgateway)
- [Airlock Microgateway Manual](https://docs.airlock.com/microgateway/latest/)
- [Airlock Community Forum](https://forum.airlock.com)
- [Airlock Helm Charts](https://github.com/ergon/airlock-helm-charts)

[MIT license]: https://github.com/ergon/airlock-minikube-examples/blob/main/LICENSE

[Airlock]: https://www.airlock.com/

[Ergon]: https://www.ergon.ch/

[Minikube]: https://minikube.sigs.k8s.io/

[kubectl]: https://kubernetes.io/docs/reference/kubectl/overview/

[ArgoCD]: https://argoproj.github.io/argo-cd/