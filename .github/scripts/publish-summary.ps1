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
 
# Always write to GitHub summary file
$summary = $env:GITHUB_STEP_SUMMARY
if (-not $summary) {
  throw "GITHUB_STEP_SUMMARY is not set."
}
 
# Evidence folder is created by download-artifact steps
$evidenceDir = Join-Path (Get-Location) "evidence"
$statsPath   = Join-Path $evidenceDir "plan_stats.json"
$previewPath = Join-Path $evidenceDir "plan_preview.txt"
 
$runUrl = "https://github.com/$Repository/actions/runs/$RunId"
 
# Helper to append UTF-8 text reliably
function Append-SummaryLine {
  param([string]$Text)
  Add-Content -Path $summary -Value $Text -Encoding utf8
}
 
# Header
Set-Content -Path $summary -Value "## Summary (review before approving)" -Encoding utf8
Append-SummaryLine ""
Append-SummaryLine "- Target environment: **$TargetEnv**"
Append-SummaryLine "- Change reference: **$ChangeRef**"
Append-SummaryLine "- Reason: $ChangeReason"
Append-SummaryLine "- Rollback: $RollbackPlan"
Append-SummaryLine "- Requested by: @$Actor"
Append-SummaryLine "- Workflow run: $runUrl"
Append-SummaryLine ""
 
# Plan counts (if available)
Append-SummaryLine "### Terraform plan counts"
Append-SummaryLine ""
if (Test-Path $statsPath) {
  $stats = Get-Content -Raw $statsPath | ConvertFrom-Json
  Append-SummaryLine "- Adds: **$($stats.adds)**"
  Append-SummaryLine "- Changes: **$($stats.changes)**"
  Append-SummaryLine "- Destroys: **$($stats.destroys)**"
  Append-SummaryLine "- Replaces: **$($stats.replaces)**"
} else {
  Append-SummaryLine "- plan_stats.json not found (stats unavailable)"
}
Append-SummaryLine ""
 
# Plan preview excerpt (first 250 lines)
Append-SummaryLine "### Plan preview (first 250 lines)"
Append-SummaryLine ""
Append-SummaryLine "~~~"
if (Test-Path $previewPath) {
  # Write exactly first 250 lines
  Get-Content -Path $previewPath -TotalCount 250 | ForEach-Object {
    Append-SummaryLine $_
  }
} else {
  Append-SummaryLine "plan_preview.txt not found under '$evidenceDir'."
  Append-SummaryLine "Downloaded evidence directory listing:"
  if (Test-Path $evidenceDir) {
    Get-ChildItem -Recurse -Force $evidenceDir | ForEach-Object { Append-SummaryLine $_.FullName }
  } else {
    Append-SummaryLine "Evidence directory not found."
  }
}
Append-SummaryLine "~~~"
Append-SummaryLine ""
 
# Artifact references (as text)
Append-SummaryLine "### Evidence artifacts"
Append-SummaryLine "- $PlanArtifactName (tfplan.binary)"
Append-SummaryLine "- $PlanArtifactName-preview (plan_preview.txt)"
Append-SummaryLine "- $PlanArtifactName-json (tfplan.json)"
Append-SummaryLine "- $PlanArtifactName-stats (plan_stats.json)"
Append-SummaryLine "- $PlanArtifactName-approval-pack (approval_pack.md)"
