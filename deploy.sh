#!/bin/bash

# Exit on error
set -e

NAME="backend-challenge-app"
USERNAME="juliofihdeldev"
IMAGE_TAG="latest"
IMAGE="$USERNAME/$NAME:$IMAGE_TAG"
echo "Building Docker image $IMAGE..."
# Build the Docker image
docker build -t "$IMAGE" .
echo "Pushing Docker image $IMAGE to Docker Hub..."

# Push the Docker image to Docker Hub
docker push "$IMAGE"
echo "Docker image pushed successfully."

# Namespace and manifest directory (edit as needed)
NAMESPACE=default
MANIFEST_DIR=./k8s

echo "Applying Kubernetes manifests from $MANIFEST_DIR to namespace $NAMESPACE..."

# Check if k3d cluster exists, create if not
K3D_CLUSTER_NAME="dev-cluster"
if ! k3d cluster list | grep -q "$K3D_CLUSTER_NAME"; then
  echo "Creating k3d cluster '$K3D_CLUSTER_NAME'..."
  k3d cluster create "$K3D_CLUSTER_NAME"
else
  echo "k3d cluster '$K3D_CLUSTER_NAME' already exists."
fi

# Set kubectl context to k3d cluster
kubectl config use-context "k3d-$K3D_CLUSTER_NAME"

# Delete existing deployment if it exists (to handle immutable selector changes)
# This allows us to update the selector label if needed
echo "Checking for existing deployment..."
if kubectl get deployment api-deployment -n "$NAMESPACE" &>/dev/null; then
  echo "Deleting existing deployment to allow selector updates..."
  kubectl delete deployment api-deployment -n "$NAMESPACE" --ignore-not-found=true
  echo "Waiting for deployment to be fully deleted..."
  kubectl wait --for=delete deployment/api-deployment -n "$NAMESPACE" --timeout=60s 2>/dev/null || true
fi

kubectl apply -n "$NAMESPACE" -f "$MANIFEST_DIR"
echo "Deployment complete."

echo "Verifying deployment..."
kubectl rollout status deployment/api-deployment -n "$NAMESPACE"
echo "Deployment verified successfully."

echo "Getting pods in namespace $NAMESPACE..."
kubectl get pods

echo "Getting services in namespace $NAMESPACE..."
kubectl get services

echo "Fetching the main service URL..."
kubectl get service backend-challenge-app-service
