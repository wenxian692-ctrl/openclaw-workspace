const fs = require('fs');
const path = require('path');

// 尝试直接复制文件为zip然后解压读取
const docxPath = 'D:/相关资料/openclaw/（整合版）PRD_监督与调整模块.docx';
const zipPath = 'D:/相关资料/openclaw/temp_docx.zip';
const extractPath = 'D:/相关资料/openclaw/docx_extract/';

// 复制为zip
fs.copyFileSync(docxPath, zipPath);
console.log('Copied to zip');

// 解压
const AdmZip = require('adm-zip');
const zip = new AdmZip(zipPath);
zip.extractAllTo(extractPath, true);
console.log('Extracted');

// 读取document.xml
const docXml = fs.readFileSync(extractPath + 'word/document.xml', 'utf8');

// 提取纯文本（简化版）
const textMatches = docXml.match(/<w:t[^>]*>([^<]*)<\/w:t>/g);
if (textMatches) {
  const text = textMatches
    .map(m => m.replace(/<[^>]+>/g, ''))
    .join('\n');
  
  // 保存到txt
  fs.writeFileSync('extracted_content.txt', text, 'utf8');
  console.log('Text extracted to extracted_content.txt');
  console.log('Total length:', text.length);
}
