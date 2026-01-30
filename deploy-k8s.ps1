# Deploy GigsHub to Kubernetes using Helm

Write-Host "🚀 Deploying GigsHub to Kubernetes..." -ForegroundColor Cyan
Write-Host ""

# Check if kubectl is available
try {
    kubectl version --client --short 2>$null | Out-Null
} catch {
    Write-Host "❌ kubectl not found. Please install it first." -ForegroundColor Red
    Write-Host "   Run: .\install-k8s-tools.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if Helm is available
try {
    helm version --short 2>$null | Out-Null
} catch {
    Write-Host "❌ Helm not found. Please install it first." -ForegroundColor Red
    Write-Host "   Run: .\install-k8s-tools.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if Kubernetes cluster is running
Write-Host "🔍 Checking Kubernetes cluster..." -ForegroundColor Yellow
try {
    kubectl cluster-info 2>$null | Out-Null
    Write-Host "✅ Kubernetes cluster is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Kubernetes cluster is not running" -ForegroundColor Red
    Write-Host "   Please enable Kubernetes in Docker Desktop" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📦 Installing GigsHub Helm chart..." -ForegroundColor Yellow

# Install or upgrade the Helm chart
$chartPath = ".\k8s\helm\gigshub"

if (Test-Path $chartPath) {
    try {
        helm upgrade --install gigshub $chartPath --wait
        Write-Host "✅ GigsHub deployed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to deploy GigsHub" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Helm chart not found at $chartPath" -ForegroundColor Red
    exit 1
}

# Wait for pods to be ready
Write-Host ""
Write-Host "⏳ Waiting for pods to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Display deployment status
Write-Host ""
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 Deployment Status" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

kubectl get pods
Write-Host ""
kubectl get services
Write-Host ""

# Get service URLs
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🌐 Access Your Application" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$clientService = kubectl get service -o json | ConvertFrom-Json | Where-Object { $_.items.metadata.name -like "*client*" }
$grafanaService = kubectl get service -o json | ConvertFrom-Json | Where-Object { $_.items.metadata.name -like "*grafana*" }

Write-Host "Frontend:" -ForegroundColor Yellow
Write-Host "  kubectl port-forward service/gigshub-client 8080:80" -ForegroundColor White
Write-Host "  Then open: http://localhost:8080" -ForegroundColor Gray
Write-Host ""

Write-Host "Grafana:" -ForegroundColor Yellow
Write-Host "  kubectl port-forward service/gigshub-grafana 3000:3000" -ForegroundColor White
Write-Host "  Then open: http://localhost:3000 (admin/admin123)" -ForegroundColor Gray
Write-Host ""

Write-Host "API:" -ForegroundColor Yellow
Write-Host "  kubectl port-forward service/gigshub-api 5000:5000" -ForegroundColor White
Write-Host "  Then open: http://localhost:5000" -ForegroundColor Gray
Write-Host ""

Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "💡 Useful Commands" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "View logs:" -ForegroundColor Yellow
Write-Host "  kubectl logs -f <pod-name>" -ForegroundColor Gray
Write-Host ""
Write-Host "Delete deployment:" -ForegroundColor Yellow
Write-Host "  helm uninstall gigshub" -ForegroundColor Gray
Write-Host ""
Write-Host "Update deployment:" -ForegroundColor Yellow
Write-Host "  helm upgrade gigshub ./k8s/helm/gigshub" -ForegroundColor Gray
Write-Host ""
