$content = Get-Content 'C:\Users\Administrator\.openclaw\workspace\extracted_ref\word\document.xml' -Raw -Encoding UTF8
$output = $content.Substring(0, [Math]::Min(10000, $content.Length))
$output | Out-File -FilePath 'C:\Users\Administrator\.openclaw\workspace\extracted_ref\doc_content.txt' -Encoding UTF8
Write-Output "Done"
