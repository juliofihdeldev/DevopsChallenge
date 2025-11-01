#!/bin/bash

# Test script for local Kubernetes cluster
# This script verifies that your k8s setup is working correctly

set -e

NAMESPACE=default
SERVICE_NAME=backend-challenge-app-service
DEPLOYMENT_NAME=api-deployment

echo "========================================="
echo "Kubernetes Cluster Test"
echo "========================================="
echo ""

# Check cluster connection
echo "1. Checking cluster connection..."
if kubectl cluster-info &>/dev/null; then
    echo "✓ Cluster is accessible"
    kubectl cluster-info | head -1
else
    echo "✗ Cannot connect to cluster"
    exit 1
fi
echo ""

# Check nodes
echo "2. Checking nodes..."
NODES=$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$NODES" -gt 0 ]; then
    echo "✓ Found $NODES node(s):"
    kubectl get nodes
else
    echo "✗ No nodes found"
    exit 1
fi
echo ""

# Check deployment
echo "3. Checking deployment..."
if kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE &>/dev/null; then
    echo "✓ Deployment '$DEPLOYMENT_NAME' exists"
    kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE
    echo ""
    echo "  Deployment details:"
    kubectl describe deployment $DEPLOYMENT_NAME -n $NAMESPACE | grep -A 10 "Replicas:"
else
    echo "✗ Deployment '$DEPLOYMENT_NAME' not found"
    exit 1
fi
echo ""

# Check pods
echo "4. Checking pods..."
PODS=$(kubectl get pods -n $NAMESPACE -l app=backend-challenge-app --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$PODS" -gt 0 ]; then
    echo "✓ Found $PODS pod(s):"
    kubectl get pods -n $NAMESPACE -l app=backend-challenge-app
    echo ""
    # Check pod status
    READY_PODS=$(kubectl get pods -n $NAMESPACE -l app=backend-challenge-app --no-headers 2>/dev/null | grep "Running" | grep "1/1" | wc -l | tr -d ' ')
    if [ "$READY_PODS" -eq "$PODS" ]; then
        echo "✓ All pods are ready"
    else
        echo "⚠ Not all pods are ready yet"
        kubectl get pods -n $NAMESPACE -l app=backend-challenge-app
    fi
else
    echo "✗ No pods found"
    exit 1
fi
echo ""

# Check service
echo "5. Checking service..."
if kubectl get service $SERVICE_NAME -n $NAMESPACE &>/dev/null; then
    echo "✓ Service '$SERVICE_NAME' exists:"
    kubectl get service $SERVICE_NAME -n $NAMESPACE
    NODE_PORT=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
    CLUSTER_IP=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')
    echo ""
    echo "  Cluster IP: $CLUSTER_IP"
    echo "  NodePort: $NODE_PORT"
else
    echo "✗ Service '$SERVICE_NAME' not found"
    exit 1
fi
echo ""

# Test health check endpoints via port-forward
echo "6. Testing health check endpoints..."
POD_NAME=$(kubectl get pods -n $NAMESPACE -l app=backend-challenge-app -o jsonpath='{.items[0].metadata.name}')

if [ -n "$POD_NAME" ]; then
    echo "  Using pod: $POD_NAME"
    
    # Start port-forward in background
    echo "  Starting port-forward..."
    kubectl port-forward -n $NAMESPACE pod/$POD_NAME 3001:3001 > /dev/null 2>&1 &
    PF_PID=$!
    sleep 2
    
    # Test healthz endpoint
    echo "  Testing /healthz endpoint..."
    if curl -s http://localhost:3001/healthz > /dev/null; then
        HEALTHZ_RESPONSE=$(curl -s http://localhost:3001/healthz)
        echo "  ✓ /healthz: $HEALTHZ_RESPONSE"
    else
        echo "  ✗ /healthz failed"
    fi
    
    # Test readyz endpoint
    echo "  Testing /readyz endpoint..."
    if curl -s http://localhost:3001/readyz > /dev/null; then
        READYZ_RESPONSE=$(curl -s http://localhost:3001/readyz)
        echo "  ✓ /readyz: $READYZ_RESPONSE"
    else
        echo "  ✗ /readyz failed"
    fi
    
    # Kill port-forward
    kill $PF_PID 2>/dev/null || true
    wait $PF_PID 2>/dev/null || true
    
    echo ""
    echo "  To test via NodePort, you can also run:"
    echo "    curl http://localhost:$NODE_PORT/healthz"
    echo "    curl http://localhost:$NODE_PORT/readyz"
else
    echo "  ✗ No pod found for testing"
fi
echo ""

# Show pod logs
echo "7. Recent pod logs (last 10 lines):"
if [ -n "$POD_NAME" ]; then
    echo "  Pod: $POD_NAME"
    kubectl logs -n $NAMESPACE $POD_NAME --tail=10 2>/dev/null | sed 's/^/  /' || echo "  (No logs available)"
else
    echo "  (No pods available)"
fi
echo ""

echo "========================================="
echo "✓ All basic checks completed!"
echo "========================================="
echo ""
echo "Quick access commands:"
echo "  - View pods: kubectl get pods -n $NAMESPACE"
echo "  - View logs: kubectl logs -n $NAMESPACE -l app=backend-challenge-app --tail=50"
echo "  - Port forward: kubectl port-forward -n $NAMESPACE service/$SERVICE_NAME 8080:80"
echo "  - Test via NodePort: curl http://localhost:$NODE_PORT/healthz"
echo "  - Describe pod: kubectl describe pod -n $NAMESPACE -l app=backend-challenge-app"
echo ""

