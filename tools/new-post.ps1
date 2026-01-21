param(
  [Parameter(Mandatory = $true, Position = 0)][string]$Title,
  [string[]]$Categories = @(),
  [string[]]$Tags = @(),
  [switch]$Pin,
  [switch]$Math,
  [switch]$Mermaid
)

# Normalize a URL-friendly slug from the title
$slug = ($Title -replace '[^a-zA-Z0-9]+','-').ToLower().Trim('-')
$now  = Get-Date
$date = $now.ToString('yyyy-MM-dd')
$time = $now.ToString('yyyy-MM-dd HH:mm:ss K')
$path = "_posts/$date-$slug.md"

if (-not (Test-Path "_posts")) {
  New-Item -ItemType Directory -Path "_posts" | Out-Null
}

# Build YAML list blocks or empty array tokens
$categoriesBlock = if ($Categories.Count -gt 0) {
  "- " + ($Categories -join "`n- ")
} else {
  "[]"
}

$tagsBlock = if ($Tags.Count -gt 0) {
  "- " + ($Tags -join "`n- ")
} else {
  "[]"
}

$frontMatter = @"
---
title: "$Title"
date: $time
categories: $categoriesBlock
tags: $tagsBlock
pin: $($Pin.IsPresent)
math: $($Math.IsPresent)
mermaid: $($Mermaid.IsPresent)
---

Write your content here.
"@

$frontMatter | Set-Content -Path $path -Encoding UTF8
Write-Host "Created $path"
