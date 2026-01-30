# Stop Demo Environment
# Use this script to stop all Docker services after your presentation

Write-Host "🛑 Stopping GigsHub Demo Environment..." -ForegroundColor Yellow
Write-Host ""

# Stop all containers
docker compose down

Write-Host ""
Write-Host "✅ All services stopped!" -ForegroundColor Green
Write-Host "   Run .\start-demo.ps1 to start again" -ForegroundColor Gray
Write-Host ""
