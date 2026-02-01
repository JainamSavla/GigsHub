# GigsHub - Freelance Marketplace (DevOps Branch)

A full-stack freelance marketplace application with complete DevOps setup including Kubernetes, ArgoCD, monitoring, and CI/CD pipelines.

> **Note:** For application code only, switch to the `main` branch. This `devops` branch contains the complete infrastructure and deployment setup.

## 🚀 Live Demo

- **Frontend:** [https://gigs-hub-one.vercel.app](https://gigs-hub-one.vercel.app)
- **Backend API:** [https://gigshub-jy7k.onrender.com](https://gigshub-jy7k.onrender.com)

## Screenshots
<img width="1503" height="702" alt="image" src="https://github.com/user-attachments/assets/214b7ac2-cefb-4015-bac9-d418f735a8b5" />
<img width="1477" height="765" alt="image" src="https://github.com/user-attachments/assets/848821cf-4051-415c-94c1-72ff9e46130b" />
<img width="1486" height="764" alt="image" src="https://github.com/user-attachments/assets/22b6c708-63bb-4a47-93fb-8e871735997f" />
<img width="1444" height="778" alt="image" src="https://github.com/user-attachments/assets/5a83a501-853c-4ab7-8605-37238bac5625" />
<img width="1429" height="722" alt="image" src="https://github.com/user-attachments/assets/33b295ee-95c7-4f42-9220-13e2bd396cfb" />
<img width="1421" height="775" alt="image" src="https://github.com/user-attachments/assets/004940e4-3f62-42ba-b65f-aed2aca23b29" />

## ✨ Features

- **User Authentication** - Register and login with JWT authentication
- **Browse Gigs** - Search and filter freelance services by category, price, and popularity
- **Create Gigs** - Sellers can create and manage their service listings
- **Orders System** - Complete order management for buyers and sellers
- **Real-time Messaging** - Chat between buyers and sellers
- **Payment Integration** - Stripe payment processing in INR (Indian Rupees)
- **Image Upload** - Cloudinary integration for gig images
- **Reviews & Ratings** - Leave reviews for completed orders
- **Responsive Design** - Mobile-friendly interface

## 🛠️ Tech Stack

### Frontend
- **React** - UI library
- **Vite** - Build tool
- **React Router** - Navigation
- **React Query** - Data fetching and caching
- **Axios** - HTTP client
- **Sass** - CSS preprocessor
- **Stripe** - Payment processing

### Backend
- **Node.js** - Runtime environment
- **Express** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **Bcrypt** - Password hashing
- **Stripe** - Payment API

### Cloud Services
- **Vercel** - Frontend hosting
- **Render** - Backend hosting
- **MongoDB Atlas** - Database hosting
- **Cloudinary** - Image storage

## 📦 DevOps Stack

### Infrastructure
- **Kubernetes** - Container orchestration (Docker Desktop)
- **Helm** - Kubernetes package manager
- **ArgoCD** - GitOps continuous deployment
- **Sealed Secrets** - Encrypted secrets management
- **Docker** - Containerization

### Monitoring & Observability
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **kube-prometheus-stack** - Complete monitoring solution
- **ServiceMonitor** - Custom API metrics

### CI/CD
- **GitHub Actions** - Automated build and deploy
- **Docker Hub** - Container registry
- **GitOps Repository** - [gigshub-gitops](https://github.com/JainamSavla/gigshub-gitops)

---

## 🚀 Quick Start - DevOps Setup

### Prerequisites

1. **Docker Desktop** with Kubernetes enabled
2. **kubectl** - Kubernetes CLI
3. **Helm** - Package manager for Kubernetes
4. **kubeseal** - Sealed Secrets CLI
5. **Git** - Version control

### Install Prerequisites (Windows)

```powershell
# Install kubectl
winget install Kubernetes.kubectl

# Install Helm
winget install Helm.Helm

# Install kubeseal
choco install kubeseal

# Or download from: https://github.com/bitnami-labs/sealed-secrets/releases
```

### Enable Kubernetes in Docker Desktop

1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"
5. Wait for Kubernetes to start (green indicator)

---

## 🔧 Complete Deployment Guide

### 1. Install ArgoCD

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port-forward ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access at: https://localhost:8080
# Username: admin
# Password: (from command above)
```

### 2. Install Sealed Secrets Controller

```bash
# Install sealed-secrets controller
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.26.0/controller.yaml

# Verify installation
kubectl get pods -n kube-system | grep sealed-secrets

# Wait for controller to be ready
kubectl wait --for=condition=Ready pod -l name=sealed-secrets-controller -n kube-system --timeout=120s
```

### 3. Install Monitoring Stack

```bash
# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring

# Install kube-prometheus-stack
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set grafana.adminPassword=admin

# Verify installation
kubectl get pods -n monitoring

# Access Grafana
kubectl port-forward -n monitoring svc/monitoring-grafana 3001:80

# Access Prometheus
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090

# Grafana: http://localhost:3001 (admin/admin)
# Prometheus: http://localhost:9090
```

### 4. Install Metrics Server (Required for HPA)

```bash
# Download metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Patch for Docker Desktop (insecure TLS)
kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

# Verify metrics working
kubectl top nodes
kubectl top pods -n gigshub
```

### 5. Create Sealed Secrets

```bash
cd k8s/sealed-secrets

# Create sealed secrets from your actual values
kubectl create secret generic gigshub-secrets \
  --from-literal=MONGO='your_mongodb_atlas_connection_string' \
  --from-literal=JWT_KEY='your_jwt_secret' \
  --from-literal=STRIPE='your_stripe_secret_key' \
  --from-literal=FRONTEND_URL='https://gigs-hub-one.vercel.app' \
  --dry-run=client -o yaml | \
  kubeseal --format=yaml > ../../k8s/helm/gigshub/templates/sealed-secret.yaml

# Verify sealed secret created
cat ../../k8s/helm/gigshub/templates/sealed-secret.yaml
```

### 6. Deploy Application with ArgoCD

#### Option A: Using ArgoCD UI

1. Open ArgoCD UI: https://localhost:8080
2. Click "New App"
3. Fill details:
   - **Application Name:** gigshub
   - **Project:** default
   - **Sync Policy:** Automatic
   - **Repository URL:** https://github.com/JainamSavla/gigshub-gitops
   - **Path:** .
   - **Cluster:** https://kubernetes.default.svc
   - **Namespace:** gigshub
4. Click "Create"
5. ArgoCD will automatically sync and deploy

#### Option B: Using kubectl

```bash
# Apply ArgoCD application manifest
kubectl apply -f k8s/argocd/application.yaml

# Check application status
kubectl get applications -n argocd

# Watch deployment
kubectl get pods -n gigshub -w
```

### 7. Verify Deployment

```bash
# Check all pods are running
kubectl get pods -n gigshub

# Check services
kubectl get svc -n gigshub

# Check HPA (Horizontal Pod Autoscaler)
kubectl get hpa -n gigshub

# Check sealed secret decryption
kubectl get secret gigshub-secrets -n gigshub -o yaml

# View API logs
kubectl logs -f -n gigshub -l app=api

# Check ArgoCD sync status
kubectl get applications -n argocd
```

### 8. Access Applications

```bash
# Port-forward API service
kubectl port-forward -n gigshub svc/gigshub-api 5000:5000

# Test API
curl http://localhost:5000/api/gigs

# Access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access Grafana
kubectl port-forward -n monitoring svc/monitoring-grafana 3001:80

# Access Prometheus
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```

---

## 📊 Monitoring Setup

### Grafana Dashboards

1. **Access Grafana:** http://localhost:3001
2. **Login:** admin / (get password from secret)

```bash
# Get Grafana password
kubectl get secret -n monitoring monitoring-grafana -o jsonpath='{.data.admin-password}' | base64 -d
```

3. **Import Recommended Dashboards:**
   - Dashboard ID **15760** - Kubernetes Dashboard (Docker Desktop compatible)
   - Custom Node.js metrics (already configured)

4. **Custom Metrics:**
   - `http_requests_total` - Total API requests
   - `http_request_duration_ms` - Request latency
   - Node.js process metrics (CPU, memory, event loop)

### Prometheus Queries

Access Prometheus at http://localhost:9090 and try these queries:

```promql
# API request rate
rate(http_requests_total{namespace="gigshub"}[5m])

# API pod CPU usage
rate(container_cpu_usage_seconds_total{namespace="gigshub",pod=~"gigshub-api.*"}[5m])

# API pod memory usage
container_memory_working_set_bytes{namespace="gigshub",pod=~"gigshub-api.*"}

# Request duration (95th percentile)
histogram_quantile(0.95, rate(http_request_duration_ms_bucket{namespace="gigshub"}[5m]))
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The CI/CD pipeline automatically:

1. **Triggers on:** Push to `devops` branch
2. **Builds:** Docker images for API and Client
3. **Scans:** Images with Trivy for security vulnerabilities
4. **Pushes:** Images to Docker Hub with tags
5. **Updates:** GitOps repository with new image tags
6. **Deploys:** ArgoCD automatically syncs changes to Kubernetes

### Setup GitHub Secrets

Add these secrets to your GitHub repository:

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_TOKEN` | Docker Hub access token |
| `GITOPS_REPO` | GitOps repo (e.g., JainamSavla/gigshub-gitops) |
| `GITOPS_TOKEN` | GitHub PAT with repo access |

### Manual Trigger

```bash
# Make a change and push to devops branch
git checkout devops
git add .
git commit -m "Update deployment"
git push origin devops

# GitHub Actions will automatically build and deploy
```

---

## 🐳 Local Development with Docker Compose

For local development without Kubernetes:

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Services available at:
# - API: http://localhost:8800
# - Client: http://localhost:5173
# - MongoDB: localhost:27017
# - Prometheus: http://localhost:9090
# - Grafana: http://localhost:3000
```

---

## 📁 Repository Structure

```
devops/
├── .github/workflows/      # CI/CD pipelines
│   └── ci-cd.yml          # Main deployment workflow
├── api/                   # Backend application
│   ├── Dockerfile        # Production Docker image
│   └── package.json
├── client/               # Frontend application
│   ├── Dockerfile       # Production Docker image
│   └── package.json
├── k8s/                 # Kubernetes manifests
│   ├── argocd/          # ArgoCD application config
│   ├── helm/gigshub/    # Helm chart
│   │   ├── templates/   # K8s resource templates
│   │   │   ├── api-deployment.yaml
│   │   │   ├── api-service.yaml
│   │   │   ├── api-hpa.yaml
│   │   │   ├── sealed-secret.yaml
│   │   │   └── servicemonitor.yaml
│   │   ├── values.yaml            # Default values
│   │   └── values-production.yaml # Production values
│   ├── monitoring/      # Monitoring configs
│   └── sealed-secrets/  # Sealed secrets scripts
├── grafana/            # Grafana dashboards
├── docker-compose.yml  # Local development
├── prometheus.yml     # Prometheus config
└── README.md         # This file
```

---

## 🔐 Secrets Management

### Production Secrets

Secrets are encrypted using Sealed Secrets and stored safely in Git:

```bash
# Sealed secret is in: k8s/helm/gigshub/templates/sealed-secret.yaml
# It gets automatically decrypted by sealed-secrets-controller in the cluster

# To update secrets:
cd k8s/sealed-secrets
./create-production-secrets.sh  # Edit with your values first

# Or manually:
kubectl create secret generic gigshub-secrets \
  --from-literal=MONGO='new_value' \
  --dry-run=client -o yaml | \
  kubeseal --format=yaml > ../helm/gigshub/templates/sealed-secret.yaml
```

### Required Secrets

- **MONGO** - MongoDB Atlas connection string
- **JWT_KEY** - Secret key for JWT tokens
- **STRIPE** - Stripe secret key (sk_test_...)
- **FRONTEND_URL** - Vercel frontend URL

---

## 🚨 Troubleshooting

### ArgoCD Application Stuck in "Progressing"

```bash
# Check if metrics-server is installed
kubectl get deployment metrics-server -n kube-system

# If not installed, install it (see step 4 above)
```

### Sealed Secret Not Decrypting

```bash
# Check controller logs
kubectl logs -n kube-system -l name=sealed-secrets-controller

# Regenerate sealed secret with current cluster key
cd k8s/sealed-secrets
./create-production-secrets.sh
```

### Prometheus Not Scraping Metrics

```bash
# Check ServiceMonitor has correct labels
kubectl get servicemonitor gigshub-api -n gigshub -o yaml | grep -A 5 labels

# Should have: release: monitoring

# Check Prometheus targets
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
# Open http://localhost:9090/targets
```

### Grafana Dashboards Showing "No Data"

```bash
# Verify metrics are being collected
kubectl top pods -n gigshub

# Use Dashboard ID 15760 (Docker Desktop compatible)
# Or create custom dashboards with these queries:
# - container_memory_working_set_bytes{namespace="gigshub"}
# - rate(container_cpu_usage_seconds_total{namespace="gigshub"}[5m])
```

### HPA Not Working

```bash
# Check metrics-server
kubectl get apiservice v1beta1.metrics.k8s.io

# Should show: True

# Check HPA status
kubectl describe hpa gigshub-api -n gigshub

# Test metrics
kubectl top pods -n gigshub
```

---

## 🔄 Update Deployment

### Update Application Code

```bash
# 1. Make changes to api/ or client/
# 2. Commit and push to devops branch
git add .
git commit -m "Update: your changes"
git push origin devops

# 3. GitHub Actions will automatically:
#    - Build new Docker images
#    - Push to Docker Hub
#    - Update GitOps repo
#    - ArgoCD syncs to cluster
```

### Update Kubernetes Configuration

```bash
# Edit Helm values
vi k8s/helm/gigshub/values-production.yaml

# Commit changes
git add k8s/
git commit -m "Update K8s config"
git push origin devops

# Update GitOps repo (ArgoCD will sync automatically)
```

### Manual Sync with ArgoCD

```bash
# Using ArgoCD UI
# 1. Open https://localhost:8080
# 2. Click on "gigshub" application
# 3. Click "Sync" → "Synchronize"

# Using CLI
kubectl patch application gigshub -n argocd --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
```

---

## 📈 Scaling

### Manual Scaling

```bash
# Scale API pods
kubectl scale deployment gigshub-api -n gigshub --replicas=5

# View scaled pods
kubectl get pods -n gigshub
```

### Auto-Scaling (HPA)

HPA is already configured:
- **Min replicas:** 3
- **Max replicas:** 10
- **Target CPU:** 70%

```bash
# Check HPA status
kubectl get hpa -n gigshub

# View HPA details
kubectl describe hpa gigshub-api -n gigshub
```

---

## 🧹 Cleanup

```bash
# Delete application
kubectl delete -f k8s/argocd/application.yaml

# Delete monitoring
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring

# Delete ArgoCD
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd

# Delete sealed-secrets
kubectl delete -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.26.0/controller.yaml

# Delete metrics-server
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Delete application namespace
kubectl delete namespace gigshub
```

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request to `devops` branch

---

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**Jainam Savla**
- GitHub: [@JainamSavla](https://github.com/JainamSavla)
- Main Repo: [GigsHub](https://github.com/JainamSavla/GigsHub)
- GitOps Repo: [gigshub-gitops](https://github.com/JainamSavla/gigshub-gitops)

