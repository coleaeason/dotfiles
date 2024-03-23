Import-Module PSReadLine
oh-my-posh init pwsh --config "$HOME/theme.omp.json" | Invoke-Expression
$env:VIRTUAL_ENV_DISABLE_PROMPT=1