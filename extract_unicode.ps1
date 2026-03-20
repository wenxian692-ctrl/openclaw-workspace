$ws = 'C:\Users\Administrator\.openclaw\workspace'
$srcName = [char]0x597D + [char]0x4EAB + [char]0x5065 + [char]0x5EB7
$src = Join-Path $ws $srcName
$dst = Join-Path $ws 'imported'
New-Item -ItemType Directory -Force -Path $dst | Out-Null
$files = Get-ChildItem -LiteralPath $src -Filter *.md | Sort-Object Length -Descending
$counter = 1
foreach ($f in $files) {
  $destPath = Join-Path $dst ("file{0}.md" -f $counter)
  Copy-Item -LiteralPath $f.FullName -Destination $destPath -Force
  $counter++
}
Write-Host "Copied $($files.Count) files to $dst"