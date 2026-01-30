# Install Kubernetes Tools for Windows
# Run this script in PowerShell as Administrator

Write-Host "🚀 Installing Kubernetes Tools..." -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Please run this script as Administrator!" -ForegroundColor Red
    exit 1
}

# Install kubectl
Write-Host "📦 Installing kubectl..." -ForegroundColor Yellow
$kubectlPath = "C:\Windows\System32\kubectl.exe"

if (Test-Path $kubectlPath) {
    Write-Host "✅ kubectl already installed" -ForegroundColor Green
} else {
    try {
        Invoke-WebRequest -Uri "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe" -OutFile $kubectlPath
        Write-Host "✅ kubectl installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install kubectl" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Install Helm
Write-Host ""
Write-Host "📦 Installing Helm..." -ForegroundColor Yellow
$helmPath = "C:\Windows\System32\helm.exe"

if (Test-Path $helmPath) {
    Write-Host "✅ Helm already installed" -ForegroundColor Green
} else {
    try {
        $tempDir = New-Item -ItemType Directory -Path "$env:TEMP\helm-install" -Force
        Invoke-WebRequest -Uri "https://get.helm.sh/helm-v3.13.0-windows-amd64.zip" -OutFile "$tempDir\helm.zip"
        Expand-Archive -Path "$tempDir\helm.zip" -DestinationPath $tempDir -Force
        Copy-Item "$tempDir\windows-amd64\helm.exe" -Destination $helmPath
        Remove-Item -Path $tempDir -Recurse -Force
        Write-Host "✅ Helm installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install Helm" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Verify installations
Write-Host ""
Write-Host "🔍 Verifying installations..." -ForegroundColor Cyan
Write-Host ""

try {
    $kubectlVersion = kubectl version --client --short 2>$null
    Write-Host "✅ kubectl: $kubectlVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl not found" -ForegroundColor Red
}

try {
    $helmVersion = helm version --short 2>$null
    Write-Host "✅ Helm: $helmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Helm not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✨ Installation Complete!" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Enable Kubernetes in Docker Desktop:" -ForegroundColor White
Write-Host "   - Open Docker Desktop" -ForegroundColor Gray
Write-Host "   - Settings -> Kubernetes -> Enable Kubernetes" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Wait for Kubernetes to start (2-5 minutes)" -ForegroundColor White
Write-Host ""
Write-Host "3. Verify Kubernetes is running:" -ForegroundColor White
Write-Host "   kubectl cluster-info" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Deploy GigsHub to Kubernetes:" -ForegroundColor White
Write-Host "   helm install gigshub ./k8s/helm/gigshub" -ForegroundColor Gray
Write-Host ""
