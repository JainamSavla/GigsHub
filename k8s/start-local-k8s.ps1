# Start Local Kubernetes Development Environment

Write-Host "🚀 Starting GigsHub on Kubernetes..." -ForegroundColor Green

# Refresh PATH for Helm
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Check if Helm release exists
$releaseExists = helm list -n gigshub -q | Select-String "gigshub"

if ($releaseExists) {
    Write-Host "📦 Upgrading existing Helm release..." -ForegroundColor Yellow
    helm upgrade gigshub ./k8s/helm/gigshub --namespace gigshub
} else {
    Write-Host "📦 Installing Helm release..." -ForegroundColor Yellow
    helm install gigshub ./k8s/helm/gigshub --create-namespace --namespace gigshub
}

Write-Host "`n⏳ Waiting for pods to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Show pod status
Write-Host "`n📊 Pod Status:" -ForegroundColor Cyan
kubectl get pods -n gigshub

# Port forward services
Write-Host "`n🔌 Setting up port forwarding..." -ForegroundColor Green
Write-Host "  - Client: localhost:3000 -> gigshub-client:80" -ForegroundColor Gray
Write-Host "  - API: localhost:5000 -> gigshub-api:5000" -ForegroundColor Gray

Start-Process pwsh -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n gigshub svc/gigshub-client 3000:80"
Start-Sleep -Seconds 2
Start-Process pwsh -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n gigshub svc/gigshub-api 5000:5000"

Write-Host "`n✅ GigsHub is ready!" -ForegroundColor Green
Write-Host "`n📱 Kubernetes (Local):" -ForegroundColor Cyan
Write-Host "  - Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "  - API: http://localhost:5000/api" -ForegroundColor White

Write-Host "`n🌐 Production (Cloud):" -ForegroundColor Cyan
Write-Host "  - Frontend (Vercel): [Your Vercel URL]" -ForegroundColor Gray
Write-Host "  - API (Render): [Your Render URL]" -ForegroundColor Gray

Write-Host "`n💡 Useful Commands:" -ForegroundColor Yellow
Write-Host "  - View API logs: kubectl logs -n gigshub -l app=gigshub-api -f" -ForegroundColor Gray
Write-Host "  - View Client logs: kubectl logs -n gigshub -l app=gigshub-client -f" -ForegroundColor Gray
Write-Host "  - View pods: kubectl get pods -n gigshub" -ForegroundColor Gray
Write-Host "  - Delete deployment: helm uninstall gigshub -n gigshub" -ForegroundColor Gray
Write-Host "  - Restart Docker Compose: docker compose up -d" -ForegroundColor Gray
