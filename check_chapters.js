const fs = require('fs');
const t = fs.readFileSync('extracted_v2.txt', 'utf8');
const lines = t.split('\n');

let chapters = [];
let currentMain = '';

lines.forEach((line, idx) => {
  const match = line.match(/^(\d+)\.\s+(.+)$/);
  if (match) {
    chapters.push({ num: match[1], title: match[2], line: idx + 1 });
  }
});

console.log('章节序号 | 章节标题');
console.log('--- | ---');
chapters.forEach(c => {
  if (c.num !== currentMain) {
    currentMain = c.num;
    console.log(`${currentMain} | ${c.title}`);
  }
});
