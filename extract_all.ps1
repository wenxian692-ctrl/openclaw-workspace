Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-DocxText {
    param([string]$FilePath)
    
    try {
        $tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
        [System.IO.Compression.ZipFile]::ExtractToDirectory($FilePath, $tempDir)
        
        $xmlPath = Join-Path $tempDir "word\document.xml"
        if (Test-Path $xmlPath) {
            [xml]$xml = Get-Content $xmlPath -Encoding UTF8
            $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
            $ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
            
            $textNodes = $xml.SelectNodes("//w:t", $ns)
            $text = ""
            foreach ($node in $textNodes) {
                $text += $node.InnerText + "`n"
            }
            
            Remove-Item $tempDir -Recurse -Force
            return $text
        }
        Remove-Item $tempDir -Recurse -Force
        return ""
    }
    catch {
        return "Error: $_"
    }
}

$srcDir = "D:\相关资料\openclaw"
$outputDir = "C:\Users\Administrator\.openclaw\workspace\extracted_docs"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

# Get all docx files
$allFiles = Get-ChildItem -Path $srcDir -Filter "*.docx"

foreach ($file in $allFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Cyan
    $content = Get-DocxText -FilePath $file.FullName
    
    $outputFile = Join-Path $outputDir "$($file.BaseName).txt"
    $content | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "Saved to: $outputFile" -ForegroundColor Green
}
