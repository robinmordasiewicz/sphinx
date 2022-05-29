#!/bin/bash
#

echo "deploy sphinx container"

kubectl apply -f deployment.yaml --namespace r-mordasiewicz

echo "kubectl exec --namespace r-mordasiewicz -it sphinx -c sphinx -- /bin/bash"

echo "kubectl describe pod sphinx -n r-mordasiewicz"
