#!/bin/bash
echo " "
echo "--------------"
echo "show all objects"
echo "--------------"
echo " "
kubectl get all


echo " "
echo "--------------"
echo "data pod debug info:"
echo "--------------"
echo " "
kubectl describe pod/data-pod
kubectl logs data-pod -c iam-init
kubectl logs data-pod

echo " "
echo "--------------"
echo "microgateway-echoserver debug info:"
echo "--------------"
echo " "
kubectl describe pod -l app=microgateway-echoserver
kubectl logs -l app=microgateway-echoserver -c configbuilder
kubectl logs -l app=microgateway-echoserver

echo " "
echo "--------------"
echo "microgateway-kibana debug info:"
echo "--------------"
echo " "
kubectl describe pod -l app=microgateway-kibana
kubectl logs -l app=microgateway-kibana -c configbuilder
kubectl logs -l app=microgateway-kibana


echo " "
echo "--------------"
echo "microgateway-iam debug info:"
echo "--------------"
echo " "
kubectl describe pod -l app=microgateway-iam
kubectl logs -l app=microgateway-iam -c configbuilder
kubectl logs -l app=microgateway-iam

echo " "
echo "--------------"
echo "iam debug info:"
echo "--------------"
echo " "
kubectl describe pod -l app=iam
kubectl logs -l app=iam
