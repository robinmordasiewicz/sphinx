#!/bin/bash
#

echo "deploy sphinx container"

kubectl apply -f deployment.yaml --namespace r-mordasiewicz

echo "kubectl exec --namespace r-mordasiewicz -it sphinx -c sphinx -- /bin/bash"
