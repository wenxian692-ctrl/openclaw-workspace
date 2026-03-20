const fs = require('fs');
const txt = fs.readFileSync('C:/Users/Administrator/.openclaw/workspace/extracted_content.txt', 'utf8');
const lines = txt.split('\n');

let toc = [];
let currentNum = '';

lines.forEach((line, idx) => {
  const match = line.match(/^(\d+)\.\s+(.+)$/);
  if (match) {
    toc.push(match[1] + '. ' + match[2]);
  }
});

console.log('Current TOC:');
console.log(toc.join('\n'));
