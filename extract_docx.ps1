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
            $ns.AddNamespace("w14", "http://schemas.microsoft.com/office/word/2010/wordml")
            
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
        Write-Host "Error: $_" -ForegroundColor Red
        return ""
    }
}

$files = Get-ChildItem "D:\相关资料\openclaw\*.docx"
foreach ($file in $files) {
    Write-Host "=== $($file.Name) ===" -ForegroundColor Cyan
    $content = Get-DocxText -FilePath $file.FullName
    Write-Host $content
    Write-Host "`n--- END ---`n"
}
