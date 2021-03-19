#!/bin/bash
echo "show all objects"
kubectl get all

echo "data pod debug info:"
kubectl describe pod/data-pod
kubectl logs data-pod -c iam-init
kubectl logs data-pod

echo "microgateway-echoserver debug info:"
kubectl describe pod -l app=microgateway-echoserver
kubectl logs -l app=microgateway-echoserver -c configbuilder
kubectl logs -l app=microgateway-echoserver

echo "microgateway-kibana debug info:"
kubectl describe pod -l app=microgateway-kibana
kubectl logs -l app=microgateway-kibana -c configbuilder
kubectl logs -l app=microgateway-kibana

echo "microgateway-iam debug info:"
kubectl describe pod -l app=microgateway-iam
kubectl logs -l app=microgateway-iam -c configbuilder
kubectl logs -l app=microgateway-iam

echo "iam debug info:"
kubectl describe pod -l app=iam
kubectl logs -l app=iam
