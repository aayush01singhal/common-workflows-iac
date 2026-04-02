$sha = (git rev-parse HEAD).Trim()
"sha=$sha" | Out-File -FilePath $env:GITHUB_OUTPUT -Append
