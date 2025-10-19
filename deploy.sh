#!/bin/bash

# Exit on error
set -e

NAME ="backend_challenge-app"
USERNAME ="juliofihdeldev"
IMAGE_TAG ="latest"
IMAGE="$USERNAME/$NAME:$IMAGE_TAG"
echo "Building Docker image $IMAGE..."
# Build the Docker image
docker build -t "$IMAGE" .
echo "Pushing Docker image $IMAGE to Docker Hub..."

echo "Tagging Docker image..."
docker tag "$IMAGE" "$IMAGE"
echo "Docker image tagged successfully."

# Push the Docker image to Docker Hub
docker push "$IMAGE"
echo "Docker image pushed successfully."

# Namespace and manifest directory (edit as needed)
NAMESPACE=default
MANIFEST_DIR=./k8s

echo "Applying Kubernetes manifests from $MANIFEST_DIR to namespace $NAMESPACE..."

# start minikube if not running
if ! minikube status &> /dev/null; then
  echo "Starting minikube..."
  minikube start
fi

kubectl apply -n "$NAMESPACE" -f "$MANIFEST_DIR"
echo "Deployment complete."

echo "Verifying deployment..."
kubectl rollout status deployment/"$NAME" -n "$NAMESPACE"
echo "Deployment verified successfully."

echo "Getting pods in namespace $NAMESPACE..."
kubectl get pods

echo "Getting services in namespace $NAMESPACE..."
kubectl get services

echo "Fetching the main service URL..."
kubectl get service $NAME-service