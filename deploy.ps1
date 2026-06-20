# Clear any conflicting environment tokens
$env:GITHUB_TOKEN = $null

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  DEPLOYING PROJECT TO GITHUB & GITHUB PAGES" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Auth on GitHub
Write-Host "[1/4] Authenticating with GitHub..." -ForegroundColor Yellow
.\gh.exe auth login -h github.com -p https -w

if ($LASTEXITCODE -ne 0) {
    Write-Host "Authentication failed. Make sure you enter the code in your browser." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit
}

# 2. Get GitHub Username
$username = (.\gh.exe api user --jq ".login").Trim()
Write-Host "Successfully authenticated as: $username" -ForegroundColor Green
Write-Host ""

# 3. Create Repo on GitHub
Write-Host "[2/4] Creating repository 'png-remover' on GitHub..." -ForegroundColor Yellow
.\gh.exe repo create png-remover --public --source=. --push

# 4. Enable GitHub Pages
Write-Host "[3/4] Enabling GitHub Pages..." -ForegroundColor Yellow
.\gh.exe api repos/$username/png-remover/pages -f "source[branch]=main" -f "source[path]=/"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully enabled GitHub Pages!" -ForegroundColor Green
} else {
    Write-Host "GitHub Pages is already configured or configuring..." -ForegroundColor Gray
}

# Done
$pageUrl = "https://$username.github.io/png-remover/"
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "  SUCCESS!" -ForegroundColor Green
Write-Host "  Your project is published at:" -ForegroundColor Green
Write-Host "  $pageUrl" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to finish..."
