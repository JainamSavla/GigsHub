# Generate Traffic for Demo
# Use this script to create activity in your metrics while presenting

Write-Host "🔄 Generating traffic to API endpoints..." -ForegroundColor Cyan
Write-Host "   This will create 200 requests to show in your graphs" -ForegroundColor Gray
Write-Host ""

$endpoints = @(
    "http://localhost:5000/health",
    "http://localhost:5000/api/gigs",
    "http://localhost:5000/metrics"
)

for ($i=1; $i -le 200; $i++) {
    $endpoint = $endpoints[($i % $endpoints.Length)]
    
    try {
        $response = Invoke-WebRequest -Uri $endpoint -Method GET -ErrorAction SilentlyContinue
        $statusColor = if ($response.StatusCode -eq 200) { "Green" } else { "Yellow" }
        Write-Host "[$i/200] " -NoNewline -ForegroundColor Gray
        Write-Host "✓" -NoNewline -ForegroundColor $statusColor
        Write-Host " $endpoint - Status: $($response.StatusCode)" -ForegroundColor Gray
        Start-Sleep -Milliseconds 150
    } catch {
        Write-Host "[$i/200] " -NoNewline -ForegroundColor Gray
        Write-Host "✗" -NoNewline -ForegroundColor Red
        Write-Host " $endpoint - Failed" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✅ Traffic generation complete!" -ForegroundColor Green
Write-Host "   Check Grafana and Prometheus for updated metrics" -ForegroundColor Gray
Write-Host ""
