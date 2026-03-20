#!/usr/bin/env node

import { readFileSync } from 'fs';
import { join, dirname, resolve } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

function usage() {
  console.error(`Usage: pdf-extract.mjs <pdf-file> [options]

Options:
  --page <n>              Extract specific page number
  --pages <start-end>     Extract page range (e.g., 1-10)
  --json                  Output raw JSON with metadata

Examples:
  pdf-extract.mjs "document.pdf"
  pdf-extract.mjs "report.pdf" --page 5
  pdf-extract.mjs "document.pdf" --pages 1-10
  pdf-extract.mjs "report.pdf" --json`);
  process.exit(2);
}

const args = process.argv.slice(2);
if (args.length === 0 || args[0] === "-h" || args[0] === "--help") usage();

const pdfPath = resolve(args[0]);
let specificPage = null;
let pageRange = null;
let outputJson = false;

for (let i = 1; i < args.length; i++) {
  const a = args[i];
  if (a === "--page") {
    specificPage = Number.parseInt(args[i + 1] ?? "1", 10);
    i++;
    continue;
  }
  if (a === "--pages") {
    pageRange = args[i + 1] ?? "";
    i++;
    continue;
  }
  if (a === "--json") {
    outputJson = true;
    continue;
  }
  console.error(`Unknown arg: ${a}`);
  usage();
}

// Check if pdf-parse is installed
let pdfParse;
try {
  pdfParse = await import('pdf-parse');
} catch (e) {
  console.error("Error: pdf-parse library not installed");
  console.error("Install it with:");
  console.error(`  cd ${__dirname}`);
  console.error("  npm install pdf-parse");
  process.exit(1);
}

// Validate file exists
import { existsSync } from 'fs';
if (!existsSync(pdfPath)) {
  console.error(`Error: File not found: ${pdfPath}`);
  process.exit(1);
}

// Validate file is PDF
if (!pdfPath.toLowerCase().endsWith('.pdf')) {
  console.error("Error: File must be a PDF");
  process.exit(1);
}

try {
  const dataBuffer = readFileSync(pdfPath);
  const data = await pdfParse.default(dataBuffer);

  if (outputJson) {
    console.log(JSON.stringify(data, null, 2));
    process.exit(0);
  }

  // Print extracted text
  console.log("## Extracted Text\n");
  console.log(data.text);

  // Print metadata
  console.log("\n---\n");
  console.log(`Pages: ${data.numpages}`);
  console.log(`Version: ${data.version}`);
  if (data.info && Object.keys(data.info).length > 0) {
    console.log("\n## Metadata\n");
    if (data.info.Title) console.log(`Title: ${data.info.Title}`);
    if (data.info.Author) console.log(`Author: ${data.info.Author}`);
    if (data.info.Subject) console.log(`Subject: ${data.info.Subject}`);
    if (data.info.Creator) console.log(`Creator: ${data.info.Creator}`);
    if (data.info.Producer) console.log(`Producer: ${data.info.Producer}`);
    if (data.info.CreationDate) console.log(`Created: ${data.info.CreationDate}`);
    if (data.info.ModDate) console.log(`Modified: ${data.info.ModDate}`);
  }

} catch (error) {
  console.error(`Error processing PDF: ${error.message}`);
  process.exit(1);
}
