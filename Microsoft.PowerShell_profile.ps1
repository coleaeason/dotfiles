Import-Module PSReadLine
oh-my-posh init pwsh --config "$HOME/theme.omp.json" | Invoke-Expression
$env:VIRTUAL_ENV_DISABLE_PROMPT=1

# Expensify aliases
function pfab { saltfab -P -z 100 @args }
function gab { saltfab -g bastion1.sjc @args }
function pgab { saltfab -g bastion1.sjc -P -z 100 @args }
function sshtun { ssh -At -t bastion1.sjc ssh -A @args }
function misc {
    Set-Location "$HOME/source/Expensify/misc-scripts"
    . ./venv/bin/Activate.ps1
}
function edev { Set-Location "$HOME/source/Expensify/Expensidev" }
function exp  { Set-Location "$HOME/source/Expensify" }
function src  { Set-Location "$HOME/source" }

# Git aliases
function gm   { git pull origin main @args }
function gco  { git checkout @args }
function gcom { git checkout main @args }
function gcob { git checkout -b @args }
function gcbo { git checkout -b @args }
function gcm  { git commit -m @args }
function gcnm { git commit -n -m @args }
function gcmn { git commit -n -m @args }
function gaa  { git add . @args }
function gau  { git add -u @args }
function gs   { git status @args }
function gp   { git push origin @args }
function gpn  { git push origin --no-verify @args }
function gpf  { git push origin --force @args }
function gpfn { git push origin --no-verify --force @args }
function gpnf { git push origin --no-verify --force @args }

# Shell things
function ..   { Set-Location .. }
function ...  { Set-Location ../.. }
function ll   { Get-ChildItem -Force @args }

function pr {
    $remote = (git remote -v | Select-String origin | Select-Object -First 1).ToString()
    $repo = $remote -replace '.*:([^ ]+).*', '$1' -replace '\.git$', ''
    $branch = git rev-parse --abbrev-ref HEAD
    Start-Process "https://github.com/$repo/pull/new/$branch"
}

# create a socks proxy on port 8080 to a given host, use compression for the data.
function socks { ssh -D 8080 -C $args[0] }

# get info from a cert quickly
function certinfo { openssl x509 -in $args[0] -noout -text }

# generate a password from op
function genpass {
    if (-not (Get-Command op -ErrorAction SilentlyContinue)) {
        Write-Output "op is not installed"
        return
    }
    op item create --category password --generate-password --dry-run --format json |
        ConvertFrom-Json |
        Select-Object -ExpandProperty fields |
        Select-Object -First 1 -ExpandProperty value
}

function tf {
    op run --env-file="$HOME/source/Expensify/Expensidev/Terraform/.env" -- /opt/homebrew/bin/terraform @args
}
