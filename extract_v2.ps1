$srcDir = "D:\相关资料\openclaw"
$dstDir = "C:\Users\Administrator\.openclaw\workspace\extracted_docs_v2"
New-Item -ItemType Directory -Force -Path $dstDir | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Get-DocxTextUtf8 {
    param([string]$FilePath)
    try {
        $tempDir = Join-Path $env:TEMP ("docx2_" + [guid]::NewGuid().ToString())
        [System.IO.Compression.ZipFile]::ExtractToDirectory($FilePath, $tempDir)
        $xmlPath = Join-Path $tempDir "word\document.xml"
        
        if (Test-Path $xmlPath) {
            # Read as UTF-8 bytes then decode
            $bytes = [System.IO.File]::ReadAllBytes($xmlPath)
            $content = [System.Text.Encoding]::UTF8.GetString($bytes)
            
            [xml]$xml = $content
            $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
            $ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
            $ns.AddNamespace("w14", "http://schemas.microsoft.com/office/word/2010/wordml")
            $ns.AddNamespace("mc", "http://schemas.openxmlformats.org/markup-compatibility/2006")
            
            $textNodes = $xml.SelectNodes("//w:t", $ns)
            $textBuilder = New-Object System.Text.StringBuilder
            
            foreach ($node in $textNodes) {
                [void]$textBuilder.Append($node.InnerText)
                [void]$textBuilder.Append("`n")
            }
            
            Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
            return $textBuilder.ToString()
        }
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        return ""
    }
    catch {
        return "ERROR: " + $_.Exception.Message
    }
}

Get-ChildItem -Path $srcDir -Filter "*.docx" | ForEach-Object {
    $baseName = $_.BaseName
    $outputFile = Join-Path $dstDir "$baseName.txt"
    Write-Host "Processing: $baseName"
    $content = Get-DocxTextUtf8 -FilePath $_.FullName
    $content | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "  Saved: $outputFile"
}

Write-Host "`nDone! Files extracted to: $dstDir"
