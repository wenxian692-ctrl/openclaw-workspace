[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$xmlPath = 'C:\Users\Administrator\.openclaw\workspace\extracted_ref\word\document.xml'
$xmlContent = Get-Content $xmlPath -Raw -Encoding UTF8

# 使用正则提取所有w:t标签中的文本
$pattern = '<w:t[^>]*>([^<]*)</w:t>'
$matches = [regex]::Matches($xmlContent, $pattern)

$texts = @()
foreach ($match in $matches) {
    $texts += $match.Groups[1].Value
}

$fullText = $texts -join "`n"
$fullText | Out-File -FilePath 'C:\Users\Administrator\.openclaw\workspace\extracted_ref\full_text.txt' -Encoding UTF8
Write-Output "Extracted $($texts.Count) text segments"
