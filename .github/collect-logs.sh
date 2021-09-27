#!/bin/bash
echo " "
echo "--------------"
echo "show all objects"
echo "--------------"
echo " "
kubectl get all

for pod in $(kubectl get pods -o=jsonpath={.items..metadata.name})
do
  echo "--------------"
  echo "${pod} debug info:"
  echo "--------------"
  kubectl logs ${pod}

  kubectl describe pod ${pod}
done