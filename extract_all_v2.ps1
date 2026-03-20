$srcDir = "C:\openclaw_docs"
$dstDir = "C:\Users\Administrator\.openclaw\workspace\extracted_docs_v2"
New-Item -ItemType Directory -Force -Path $dstDir | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-DocxContent {
    param([string]$filePath)
    
    $tempDir = Join-Path $env:TEMP ("docx_" + [guid]::NewGuid().ToString())
    [System.IO.Compression.ZipFile]::ExtractToDirectory($filePath, $tempDir) | Out-Null
    
    $xmlPath = Join-Path $tempDir "word\document.xml"
    if (Test-Path $xmlPath) {
        $bytes = [System.IO.File]::ReadAllBytes($xmlPath)
        $content = [System.Text.Encoding]::UTF8.GetString($bytes)
        [xml]$xml = $content
        
        $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
        $ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
        
        $nodes = $xml.SelectNodes("//w:t", $ns)
        $text = ($nodes | ForEach-Object { $_.InnerText }) -join "`n"
        
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        return $text
    }
    
    Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    return ""
}

$files = Get-ChildItem -Path $srcDir -Filter "*.docx"

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)"
    $content = Get-DocxContent -filePath $file.FullName
    $outputPath = Join-Path $dstDir ($file.BaseName + ".txt")
    $content | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "  Saved: $outputPath"
}

Write-Host "Done!"
