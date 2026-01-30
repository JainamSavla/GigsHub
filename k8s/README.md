# 🚀 Kubernetes Setup Guide (Free & Local)

## Prerequisites
- Docker Desktop (you already have this)
- kubectl (Kubernetes command-line tool)
- Helm (Kubernetes package manager)

---

## Step 1: Enable Kubernetes in Docker Desktop

1. **Open Docker Desktop**
2. Click **Settings** (gear icon)
3. Go to **Kubernetes** tab
4. Check ✅ **Enable Kubernetes**
5. Click **Apply & Restart**
6. Wait 2-5 minutes for Kubernetes to start

---

## Step 2: Install kubectl (if not installed)

### Windows (PowerShell):
```powershell
# Download kubectl
curl.exe -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"

# Move to a directory in your PATH
Move-Item .\kubectl.exe C:\Windows\System32\

# Verify installation
kubectl version --client
```

---

## Step 3: Install Helm

### Windows (PowerShell):
```powershell
# Using Chocolatey (if you have it)
choco install kubernetes-helm

# OR download manually
curl https://get.helm.sh/helm-v3.13.0-windows-amd64.zip -o helm.zip
Expand-Archive helm.zip
Move-Item .\helm\windows-amd64\helm.exe C:\Windows\System32\

# Verify installation
helm version
```

---

## Step 4: Verify Kubernetes is Running

```powershell
# Check cluster info
kubectl cluster-info

# Check nodes
kubectl get nodes

# Should show something like:
# NAME             STATUS   ROLE           AGE   VERSION
# docker-desktop   Ready    control-plane   1m    v1.28.0
```

---

## Step 5: Deploy Your Application with Helm

```powershell
# Navigate to your project
cd C:\Data\Documents\Codes\Mern\GigsHub

# Install the Helm chart (we'll create this next)
helm install gigshub ./k8s/helm/gigshub

# Check deployment status
kubectl get pods
kubectl get services

# Access your application
kubectl port-forward service/gigshub-client 8080:80
# Then open: http://localhost:8080
```

---

## Step 6: Useful Commands

### View Everything
```powershell
kubectl get all
```

### View Logs
```powershell
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # Follow logs
```

### Delete Everything
```powershell
helm uninstall gigshub
```

### Update Deployment
```powershell
helm upgrade gigshub ./k8s/helm/gigshub
```

---

## Alternative: Minikube (If Docker Desktop Kubernetes doesn't work)

```powershell
# Install Minikube
choco install minikube

# Start Minikube
minikube start

# Enable ingress addon
minikube addons enable ingress

# Get Minikube IP
minikube ip
```

---

## What We're Deploying

- ✅ MongoDB (Database)
- ✅ API (Backend)
- ✅ Client (Frontend)
- ✅ Prometheus (Monitoring)
- ✅ Grafana (Dashboards)

All running in Kubernetes with Helm!
