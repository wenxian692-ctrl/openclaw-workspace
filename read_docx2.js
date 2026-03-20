const fs = require('fs');
const path = require('path');

const docxPath = 'D:/相关资料/openclaw/（整合版0319）PRD_监督与调整模块.docx';
const zipPath = 'D:/相关资料/openclaw/temp_docx2.zip';
const extractPath = 'D:/相关资料/openclaw/docx_extract2/';

fs.copyFileSync(docxPath, zipPath);
const AdmZip = require('adm-zip');
const zip = new AdmZip(zipPath);
zip.extractAllTo(extractPath, true);

const docXml = fs.readFileSync(extractPath + 'word/document.xml', 'utf8');
const textMatches = docXml.match(/<w:t[^>]*>([^<]*)<\/w:t>/g);
if (textMatches) {
  const text = textMatches
    .map(m => m.replace(/<[^>]+>/g, ''))
    .join('\n');
  fs.writeFileSync('extracted_v2.txt', text, 'utf8');
  console.log('Extracted, length:', text.length);
}
