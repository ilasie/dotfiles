Import-Module PSReadLine

$newHOME = "C:\Home"

# === scripts ===
$scriptsRepo = "D:\pscripts"

# ---- daily news ----
# & "$scriptsRepo\GetDailyNews.ps1"

# === colorscheme ===

Set-PSReadLineOption -Color @{
    "Command"   = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator"  = [ConsoleColor]::Cyan
    "Variable"  = [ConsoleColor]::Yellow
    "String"    = [ConsoleColor]::Magenta
    "Number"    = [ConsoleColor]::Blue
    "Type"      = [ConsoleColor]::Cyan
    "Comment"   = [ConsoleColor]::DarkGray
}

# === personal prompt ===

$segLeft  = [char]0xe0b1  # 
$segRight = [char]0xe0b0  # 
$timeSep  = [char]0xe0b3  # 

# icon
# $userIcon = " "
$pathIcon  = " "
$gitIcon   = " "
$gitDirty  = " "
$condaIcon = " "
$timeIcon  = " "

function Get-ShortPath {
    param([int]$MaxLength = 30)
    $path = if ($PWD.Path -eq $newHOME) { "~" } else { $PWD.Path }

    # newHOME -> ~
    if ($path.StartsWith($newHOME)) {
        $path = "~" + $path.Substring($newHOME.Length)
    }

    if ($path.Length -le $MaxLength) {
        return $path
    }
    
    $suffix = $path.Substring($path.Length - $MaxLength + 3)
    return "..." + $suffix
}

function Get-GitInfo {
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    if (-not $branch) { return $null }
    $status = git status --porcelain 2>$null
    $icon = if ($status) { $gitDirty } else { $gitIcon }
    return "$icon$branch"
}

function Get-CondaEnv {
    if (Test-Path env:CONDA_DEFAULT_ENV) {
        return $env:CONDA_DEFAULT_ENV
    }
    return $null
}

function prompt {
    $shortPath = Get-ShortPath -MaxLength 30
    
    $gitInfo = Get-GitInfo
    $hasGit = $null -ne $gitInfo
    
    $condaEnv = Get-CondaEnv
    $hasConda = $null -ne $condaEnv

    # color
    # $userBg   = "White"
    $pathBg   = "Blue"
    $gitBg    = "DarkGreen"
    $condaBg  = "Magenta"
    $timeBg   = "White"
    $timeFg   = "Black"
    $sepColor = "Gray"

    # --- status bar (path + git + conda + time) ---
    Write-Host "░▒▓" -NoNewLine -ForegroundColor $pathBg
    
    # $userAtHost = $userIcon + $env:USERNAME + "@" + $env:COMPUTERNAME
    # Write-Host $userAtHost -NoNewline -BackgroundColor $userBg -ForegroundColor Black
    # Write-Host $segRight -NoNewline -BackgroundColor $pathBg -ForegroundColor $userBg
    
    $pathDisplay = $pathIcon + $shortPath
    Write-Host " $pathDisplay " -NoNewline -BackgroundColor $pathBg -ForegroundColor White
    
    # git segment
    if ($hasGit) {
        Write-Host $segRight -NoNewline -BackgroundColor $gitBg -ForegroundColor $pathBg
        Write-Host " $gitInfo " -NoNewline -BackgroundColor $gitBg -ForegroundColor White
        if ($hasConda) {
            Write-Host $segRight -NoNewLine -BackgroundColor $condaBg -ForegroundColor $gitBg
        } else {
            Write-Host $segRight -NoNewLine -BackgroundColor $timeBg -ForegroundColor $gitBg
        }
    } else {
        if ($hasConda) {
            Write-Host $segRight -NoNewLine -BackgroundColor $condaBg -ForegroundColor $pathBg
        } else {
            Write-Host $segRight -NoNewLine -BackgroundColor $timeBg -ForegroundColor $pathBg
        }
    }
    
    # conda segment
    if ($hasConda) {
        Write-Host " $condaIcon$condaEnv " -NoNewline -BackgroundColor $condaBg -ForegroundColor White
        Write-Host $segRight -NoNewline -BackgroundColor $timeBg -ForegroundColor $condaBg
    }
    
    # time segment
    Write-Host "$timeIcon$(Get-Date -Format 'HH:mm:ss')" -NoNewline -ForegroundColor $timeFg -BackgroundColor $timeBg
    Write-Host "▓▒░" -NoNewLine -ForegroundColor $timeBg
    
    Write-Host "" # new line
    
    # --- cmd --- #
    Write-Host "❯" -NoNewline -ForegroundColor Green
    
    return " "
}

# === alias ===
function Invoke-PowerOff { shutdown /s /t 0 }

Set-Alias -Name poweroff -Value Invoke-PowerOff
Set-Alias -Name touch -Value New-Item

# === conda lazy load ===

$condaPath = "C:\Users\Administrator\miniconda3"
$global:condaLoaded = $false

function conda {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )
    
    if (-not $global:condaLoaded) {
        Write-Host "Initializing conda..." -ForegroundColor Green
        (& "$condaPath\shell\condabin\conda-hook.ps1") | Out-String | Invoke-Expression
        $global:conda = "$condaPath\condabin\conda.exe"
        $global:condaLoaded = $true
    }
    
    if ($Arguments) {
        & $global:conda @Arguments
    } else {
        & $global:conda
    }
}

# === python from conda ===
# Set-Alias -Name python -Value C:\Users\Administrator\miniconda3\python.exe

# === lua ===
Set-Alias -Name lua -Value lua54
Set-Alias -Name luac -Value luac54

# === rustup ===
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

# === tmp & advanced Edit ===
Set-Alias -Name edit -Value D:\bin\edit-nightly\edit.exe