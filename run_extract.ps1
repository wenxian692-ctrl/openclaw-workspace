$src = "C:\openclaw_temp"
$dst = "C:\Users\Administrator\.openclaw\workspace\extracted_docs"
New-Item -ItemType Directory -Force -Path $dst | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-DocxText {
    param([string]$FilePath)
    try {
        $temp = Join-Path $env:TEMP ("docx_" + [guid]::NewGuid().ToString())
        [System.IO.Compression.ZipFile]::ExtractToDirectory($FilePath, $temp)
        $xml = Join-Path $temp "word\document.xml"
        if (Test-Path $xml) {
            [xml]$content = Get-Content $xml -Encoding UTF8
            $ns = New-Object System.Xml.XmlNamespaceManager($content.NameTable)
            $ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
            $nodes = $content.SelectNodes("//w:t", $ns)
            $text = ($nodes | ForEach-Object { $_.InnerText }) -join "`n"
            Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
            return $text
        }
        Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
        return ""
    } catch {
        return "ERROR: " + $_.Exception.Message
    }
}

Get-ChildItem -Path $src -Filter "*.docx" | ForEach-Object {
    $name = $_.BaseName
    Write-Host "Processing: $name"
    $text = Get-DocxText -FilePath $_.FullName
    $outFile = Join-Path $dst "$name.txt"
    $text | Out-File -FilePath $outFile -Encoding UTF8
    Write-Host "Saved: $outFile"
}
