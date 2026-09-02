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
    Write-Host "Checking ghcr.io/$owner/$package visibility..."
    $visibility = (& gh api "users/$owner/packages/container/$package" `
        --header "Accept: application/vnd.github+json" `
        --header "X-GitHub-Api-Version: 2022-11-28" `
        --jq ".visibility").Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to read $package. Confirm that its first workflow build has completed."
    }

    if ($visibility -ne "public") {
        $settingsUrl = "https://github.com/users/$owner/packages/container/$package/settings"
        throw "ghcr.io/$owner/$package is '$visibility'. GitHub does not expose a REST endpoint for changing package visibility. Change it at: $settingsUrl"
    }

    Write-Host "ghcr.io/$owner/$package is public."
}

Write-Host "All UHPPOTED mirror packages are public."
