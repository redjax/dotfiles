[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false, HelpMessage = "Package manager to install Wezterm with")]
    [ValidateSet("winget", "scoop")]
    [string]$PackageManager = "winget"
)

$WeztermInstalled = $false

if ( ( Get-Command wezterm.exe -ErrorAction SilentlyContinue ) -or ( Get-Command wezterm-gui.exe -ErrorAction SilentlyContinue ) ) {
    Write-Host "Wezterm is already installed." -ForegroundColor Green
    $WeztermInstalled = $true
}

function Install-ScoopCli {
    Write-Information "Install scoop from https://get.scoop.sh"
    Write-Host "Download & install scoop"

    If ( -Not ( Get-Command scoop ) ) {
        try {
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        }
        catch {
            Write-Error "Failed to install scoop."
            Write-Error "Exception details: $($exc.Message)"
            exit 1
        }
    }
}

function Initialize-ScoopCli {
    Write-Host "Installing aria2 for accelerated downloads"

    try {
        scoop install aria2
        if ( -Not $(scoop config aria2-enabled) -eq $True) {
            scoop config aria2-enabled true
        }
    }
    catch {
        Write-Error "Failed to install aria2."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Enable scoop buckets"
    try {
        scoop bucket add extras
        scoop bucket add nerd-fonts
    }
    catch {
        Write-Error "Failed to enable 1 or more scoop buckets."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Disable scoop warning when using aria2 for downloads"
    try {
        scoop config aria2-warning-enabled false
    }
    catch {
        Write-Error "Failed to disable aria2 warning."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Install git"
    try {
        scoop install git
    }
    catch {
        Write-Error "Failed to install git."
        Write-Error "Exception details: $($exc.Message)"
    }
}

switch ( $PackageManager ) {
    "winget" {
        Write-Host "Installing Wezterm with winget" -ForegroundColor Cyan
    }
    "scoop" {
        Write-Host "Installing Wezterm with scoop" -ForegroundColor Cyan
    }
}

if ( -Not $WeztermInstalled ) {
    if ( $PackageManager -eq "winget" ) {
        winget install wez.wezterm
        if ( $LASTEXITCODE -ne 0 ) {
            Write-Error "Error installing Wezterm with winget. Please install Wezterm manually."
            exit 1
        }
    }

    if ( $PackageManager -eq "scoop" ) {
        scoop install wezterm
        if ( $LASTEXITCODE -ne 0 ) {
            Write-Error "Error installing Wezterm with scoop. Please install Wezterm manually."
            exit 1
        }
    }
}
else {
    Write-Host "Wezterm is already installed." -ForegroundColor Green
    exit 0
}
