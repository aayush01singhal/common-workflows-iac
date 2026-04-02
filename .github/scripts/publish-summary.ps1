param (
  [string]$TargetEnv,
  [string]$ChangeRef,
  [string]$ChangeReason,
  [string]$RollbackPlan,
  [string]$PlanArtifactName,
  [string]$Repository,
  [string]$RunId,
  [string]$Actor
)
 
$ErrorActionPreference = 'Stop'
$runUrl = "https://github.com/$Repository/actions/runs/$RunId"
 
"## Summary (review before approving)" | Out-File $env:GITHUB_STEP_SUMMARY
"" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Environment: **$TargetEnv**" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Change reference: **$ChangeRef**" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Reason: $ChangeReason" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Rollback: $RollbackPlan" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Requested by: @$Actor" | Out-File -Append $env:GITHUB_STEP_SUMMARY
"- Workflow run: $runUrl" | Out-File -Append $env:GITHUB_STEP_SUMMARY
