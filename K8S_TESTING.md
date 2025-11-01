# Testing Your Local Kubernetes Setup

## Quick Test Script

Run the automated test script:

```bash
./test-k8s.sh
```

This script checks:

- ✅ Cluster connectivity
- ✅ Node status
- ✅ Deployment status
- ✅ Pod health
- ✅ Service configuration
- ✅ Health check endpoints
- ✅ Recent logs

## Manual Testing Commands

### 1. Check Cluster Status

```bash
# Verify cluster is running
kubectl cluster-info

# Check nodes
kubectl get nodes

# Check all resources in default namespace
kubectl get all -n default
```

### 2. Check Deployment & Pods

```bash
# View deployment
kubectl get deployment api-deployment -n default

# View pods
kubectl get pods -n default

# Check pod status in detail
kubectl describe pod -n default -l app=backend-challenge-app

# Watch pods in real-time
kubectl get pods -n default -w
```

### 3. Check Service

```bash
# View service
kubectl get service backend-challenge-app-service -n default

# Get service details
kubectl describe service backend-challenge-app-service -n default

# Get NodePort
kubectl get service backend-challenge-app-service -n default -o jsonpath='{.spec.ports[0].nodePort}'
```

### 4. Test Application Endpoints

#### Option A: Port Forward (Recommended)

```bash
# Forward service to localhost:8080
kubectl port-forward -n default service/backend-challenge-app-service 8080:80

# In another terminal, test endpoints
curl http://localhost:8080/healthz
curl http://localhost:8080/readyz
curl http://localhost:8080/api/items
```

#### Option B: Port Forward to Specific Pod

```bash
# Get pod name
POD_NAME=$(kubectl get pods -n default -l app=backend-challenge-app -o jsonpath='{.items[0].metadata.name}')

# Forward pod port
kubectl port-forward -n default pod/$POD_NAME 3001:3001

# Test endpoints
curl http://localhost:3001/healthz
curl http://localhost:3001/readyz
```

#### Option C: NodePort (if configured)

```bash
# Get NodePort
NODE_PORT=$(kubectl get service backend-challenge-app-service -n default -o jsonpath='{.spec.ports[0].nodePort}')

# Test via NodePort (may require k3d port mapping)
curl http://localhost:$NODE_PORT/healthz
```

### 5. View Logs

```bash
# View logs from all pods
kubectl logs -n default -l app=backend-challenge-app --tail=50

# View logs from specific pod
POD_NAME=$(kubectl get pods -n default -l app=backend-challenge-app -o jsonpath='{.items[0].metadata.name}')
kubectl logs -n default $POD_NAME

# Follow logs (live)
kubectl logs -n default -l app=backend-challenge-app -f
```

### 6. Debug Issues

```bash
# Describe deployment to see events
kubectl describe deployment api-deployment -n default

# Describe pod to see events and status
kubectl describe pod -n default -l app=backend-challenge-app

# Check pod events
kubectl get events -n default --sort-by='.lastTimestamp'

# Execute command in pod (debugging)
POD_NAME=$(kubectl get pods -n default -l app=backend-challenge-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n default $POD_NAME -- ls -la /usr/src/app
kubectl exec -n default $POD_NAME -- env
```

### 7. Test Health Checks

```bash
# Check readiness probe
kubectl get pods -n default -o wide

# Manually test health endpoints
POD_NAME=$(kubectl get pods -n default -l app=backend-challenge-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n default $POD_NAME -- wget -qO- http://localhost:3001/healthz
kubectl exec -n default $POD_NAME -- wget -qO- http://localhost:3001/readyz
```

### 8. Clean Up (if needed)

```bash
# Delete deployment
kubectl delete deployment api-deployment -n default

# Delete service
kubectl delete service backend-challenge-app-service -n default

# Delete everything in k8s directory
kubectl delete -f ./k8s

# Delete k3d cluster (if needed)
k3d cluster delete dev-cluster
```

## Common Issues & Solutions

### Pods Not Ready

```bash
# Check pod status
kubectl describe pod -n default -l app=backend-challenge-app

# Check logs
kubectl logs -n default -l app=backend-challenge-app

# Check if health checks are failing
kubectl get pods -n default -o wide
```

### Service Not Accessible

```bash
# Verify service selector matches pod labels
kubectl get service backend-challenge-app-service -n default -o yaml
kubectl get pods -n default --show-labels

# Check endpoints
kubectl get endpoints backend-challenge-app-service -n default
```

### Image Pull Errors

```bash
# Check pod events
kubectl describe pod -n default -l app=backend-challenge-app | grep Events -A 10

# Verify image exists
docker images | grep backend-challenge-app
```

## Expected Results

When everything is working correctly, you should see:

- ✅ 2/2 pods ready and running
- ✅ Service with ClusterIP and NodePort assigned
- ✅ Health endpoints return: `{"status":"OK","service":"backend-challenge"}`
- ✅ Ready endpoints return: `{"status":"ready","service":"backend-challenge"}`
- ✅ API endpoints accessible via port-forward
