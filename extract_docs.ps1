$word = New-Object -ComObject Word.Application
$word.Visible = $false

$files = @(
    "D:\相关资料\openclaw\日常主动询问规则.docx",
    "D:\相关资料\openclaw\行为打卡后追问规则.docx",
    "D:\相关资料\openclaw\饮食记录追问策略.docx",
    "D:\相关资料\openclaw\运动打卡反馈收集.docx",
    "D:\相关资料\openclaw\饮食打卡反馈收集.docx",
    "D:\相关资料\openclaw\查看方案.docx"
)

foreach ($file in $files) {
    Write-Host "=== Processing: $file ===" -ForegroundColor Cyan
    try {
        $doc = $word.Documents.Open($file)
        $text = $doc.Content.Text
        $doc.Close($false)
        Write-Host $text
        Write-Host "`n--- END OF FILE ---`n"
    } catch {
        Write-Host "Error processing $file : $_" -ForegroundColor Red
    }
}

$word.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
