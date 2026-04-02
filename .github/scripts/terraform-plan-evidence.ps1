param (
  [string]$TargetEnv,
  [string]$ChangeRef,
  [string]$ChangeReason,
  [string]$RollbackPlan,
  [string]$SelectedBranch,
  [string]$PlanArtifactName,
  [string]$Repository,
  [string]$RunId,
  [string]$Actor,
  [string]$CommitSha
)
 
$ErrorActionPreference = 'Stop'
 
terraform version
terraform fmt -check
terraform validate
 
terraform plan -out="tfplan.binary"
terraform show -no-color "tfplan.binary" > plan_preview.txt
terraform show -json "tfplan.binary" > tfplan.json
 
$plan = Get-Content -Raw "tfplan.json" | ConvertFrom-Json
$add = 0; $change = 0; $destroy = 0; $replace = 0
 
if ($plan.resource_changes) {
  foreach ($rc in $plan.resource_changes) {
    $actions = $rc.change.actions
    if ($actions -contains "create") { $add++ }
    if ($actions -contains "update") { $change++ }
    if ($actions -contains "delete") { $destroy++ }
    if (($actions -contains "delete") -and ($actions -contains "create")) { $replace++ }
  }
}
 
$stats = [ordered]@{
  environment = $TargetEnv
  change_ref  = $ChangeRef
  commit_sha  = $CommitSha
  branch      = $SelectedBranch
  adds        = $add
  changes     = $change
  destroys    = $destroy
  replaces    = $replace
  generated_at_utc = (Get-Date).ToUniversalTime().ToString("s") + "Z"
}
 
$stats | ConvertTo-Json -Depth 10 | Out-File "plan_stats.json" -Encoding utf8
 
$runUrl = "https://github.com/$Repository/actions/runs/$RunId"
 
$preview = (Get-Content plan_preview.txt -TotalCount 300) -join "`n"
 
@"
# Approval Pack
 
## Request
- Target environment: **$TargetEnv**
- Change reference: **$ChangeRef**
- Reason: $ChangeReason
- Rollback plan: $RollbackPlan
 
## Source
- Repo: `$Repository`
- Branch: `$SelectedBranch`
- Commit SHA: `$CommitSha`
- Actor: `@$Actor`
- Workflow run: $runUrl
 
## Terraform Plan Summary
- Adds: **$add**
- Changes: **$change**
- Destroys: **$destroy**
- Replaces: **$replace**
 
## Plan Preview (excerpt)
~~~
$preview
~~~
"@ | Out-File "approval_pack.md" -Encoding utf8
