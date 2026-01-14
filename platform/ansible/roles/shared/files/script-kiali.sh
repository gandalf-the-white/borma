#!/usr/bin/bash

CONTEXT="$1"
CONFIG_FILE="$2"
CLUSTER_NAME="$3"

if [[ -z "$CONFIG_FILE" || -z "$CLUSTER_NAME" ]]; then
    echo "Usage: $0 <kubeconfig_file> <cluster_name>"
    exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
    echo "yq is required but not installed. Install it from https://github.com/mikefarah/yq/"
    exit 1
fi

CA_DATA=$(yq eval ".clusters[] | select(.name == \"$CLUSTER_NAME\") | .cluster.\"certificate-authority-data\"" "$CONFIG_FILE")

if [[ -z "$CA_DATA" || "$CA_DATA" == "null" ]]; then
    echo "certificate-authority-data not found for cluster '$CLUSTER_NAME'"
    exit 1
fi

echo "certificate-authority-data (base64):"
echo "$CA_DATA"

# Optional: decode the base64 certificate
# echo
# echo "Decoded certificate (PEM format):"
# echo "$CA_DATA" | base64 --decode

# Trouver le contexte qui correspond au cluster
CONTEXT_NAME=$(yq eval ".contexts[] | select(.context.cluster == \"$CLUSTER_NAME\") | .name" "$CONFIG_FILE")

if [[ -z "$CONTEXT_NAME" ]]; then
    echo "No context found for cluster '$CLUSTER_NAME'"
    exit 1
fi

echo "Using context: $CONTEXT_NAME"

# Extraire le token via kubectl
TOKEN=$(KUBECONFIG="$CONFIG_FILE" kubectl --context="$CLUSTER_NAME" -n istio-system create token kiali)

if [[ -z "$TOKEN" ]]; then
    echo "No token found for context '$CLUSTER_NAME'. It may be using a different auth provider (e.g., exec, oidc)."
    exit 1
fi

echo "Token:"
echo "$TOKEN"

CLUSTER_URL=$(yq eval ".clusters[] | select(.name == \"$CLUSTER_NAME\") | .cluster.server" "$CONFIG_FILE")

if [[ -z "$CLUSTER_URL" || "$CLUSTER_URL" == "null" ]]; then
    echo "Cluster URL not found for cluster '$CLUSTER_NAME'"
    exit 1
fi

echo "Cluster '$CLUSTER_NAME' URL: $CLUSTER_URL"

cat <<EOF | kubectl apply -n istio-system --context $CONTEXT -f -
apiVersion: v1
kind: Secret
metadata:
  name: kiali-multi-cluster-secret
  labels:
    kiali.io/kiali-multi-cluster-secret: "true"
stringData:
  $CLUSTER_NAME: |
    apiVersion: v1
    kind: Config
    preferences: {}
    current-context: $CLUSTER_NAME
    contexts:
    - name: $CLUSTER_NAME
      context:
        cluster: $CLUSTER_NAME
        user: $CLUSTER_NAME
    users:
    - name: $CLUSTER_NAME
      user:
        token: $TOKEN
    clusters:
    - name: $CLUSTER_NAME
      cluster:
        server: $CLUSTER_URL
        certificate-authority-data: $CA_DATA
EOF

sleep 4

kubectl delete pod -l app=kiali -n istio-system
