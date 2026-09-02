$ErrorActionPreference = "Stop"

$owner = "mumbles1"
$packages = @(
    "uhppoted-simulator",
    "uhppoted-rest",
    "uhppoted-mqtt",
    "uhppoted-httpd"
)

Write-Host "Checking GitHub authentication..."
& gh auth status
if ($LASTEXITCODE -ne 0) {
    throw "GitHub CLI is not authenticated. Run: gh auth login -h github.com -p https --web"
}

foreach ($package in $packages) {
    Write-Host "Making ghcr.io/$owner/$package public..."
    & gh api "users/$owner/packages/container/$package" --method PATCH -f visibility=public --silent
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to update $package. Confirm that its first workflow build has completed."
    }
}

Write-Host "All UHPPOTED mirror packages are public."

