param (
  [string]$TargetEnv,
  [string]$ChangeRef,
  [string]$ChangeReason,
  [string]$RollbackPlan
)
 
"## Deployment request" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Environment: $TargetEnv" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Ticket: $ChangeRef" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Reason: $ChangeReason" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Rollback: $RollbackPlan" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Actor: @${env:GITHUB_ACTOR}" | Out-File -Append $env:GITHUB_STEP_SUMMARY
