# GigsHub Demo Starter Script
# This script starts all services and generates traffic for demonstration

Write-Host "🚀 Starting GigsHub Demo Environment..." -ForegroundColor Cyan
Write-Host ""

# Step 1: Start all services with Docker Compose
Write-Host "📦 Starting Docker services..." -ForegroundColor Yellow
docker compose up -d

# Wait for services to be ready
Write-Host "⏳ Waiting for services to start (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Step 2: Check service status
Write-Host ""
Write-Host "✅ Checking service status..." -ForegroundColor Green
docker compose ps

# Step 3: Generate initial traffic
Write-Host ""
Write-Host "🔄 Generating initial traffic to populate metrics..." -ForegroundColor Yellow

for ($i=1; $i -le 100; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -Method GET -ErrorAction SilentlyContinue
        $response2 = Invoke-WebRequest -Uri "http://localhost:5000/api/gigs" -Method GET -ErrorAction SilentlyContinue
        Write-Progress -Activity "Generating Traffic" -Status "Request $i of 100" -PercentComplete ($i)
        Start-Sleep -Milliseconds 100
    } catch {
        # Ignore errors
    }
}

Write-Progress -Activity "Generating Traffic" -Completed

# Step 4: Display service URLs
Write-Host ""
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✨ Demo Environment Ready! ✨" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Application Services:" -ForegroundColor Yellow
Write-Host "   Frontend:  http://localhost:80" -ForegroundColor White
Write-Host "   API:       http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "📊 Monitoring Dashboards:" -ForegroundColor Yellow
Write-Host "   Grafana:   http://localhost:3000 (admin/admin123)" -ForegroundColor White
Write-Host "   Prometheus: http://localhost:9090" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Metrics Endpoints:" -ForegroundColor Yellow
Write-Host "   API Metrics:      http://localhost:5000/metrics" -ForegroundColor White
Write-Host "   Node Exporter:    http://localhost:9100/metrics" -ForegroundColor White
Write-Host "   MongoDB Exporter: http://localhost:9216/metrics" -ForegroundColor White
Write-Host ""
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Tips for your demonstration:" -ForegroundColor Cyan
Write-Host "   1. Open Grafana and create dashboards with the metrics" -ForegroundColor Gray
Write-Host "   2. Use Prometheus to show real-time metrics queries" -ForegroundColor Gray
Write-Host "   3. Run .\generate-traffic.ps1 to create more activity" -ForegroundColor Gray
Write-Host "   4. Run .\stop-demo.ps1 when done to stop all services" -ForegroundColor Gray
Write-Host ""
Write-Host "🎉 Ready for your presentation!" -ForegroundColor Green
Write-Host ""

# Keep generating background traffic (optional - press Ctrl+C to stop)
$continue = Read-Host "Do you want to keep generating background traffic? (y/n)"

if ($continue -eq 'y' -or $continue -eq 'Y') {
    Write-Host ""
    Write-Host "🔄 Generating continuous background traffic..." -ForegroundColor Yellow
    Write-Host "   Press Ctrl+C to stop" -ForegroundColor Gray
    Write-Host ""
    
    while ($true) {
        try {
            Invoke-WebRequest -Uri "http://localhost:5000/health" -Method GET -ErrorAction SilentlyContinue | Out-Null
            Invoke-WebRequest -Uri "http://localhost:5000/api/gigs" -Method GET -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 5
        } catch {
            # Ignore errors
        }
    }
}
