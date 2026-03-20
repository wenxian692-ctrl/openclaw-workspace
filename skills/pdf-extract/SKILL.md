---
name: pdf-extract
description: Extract text from PDF files for LLM processing.
homepage: https://clawhub.ai/Xejrax/pdf-extract
metadata: {"openclaw":{"emoji":"📄","requires":{"bins":["node"]}}}
---

# PDF Extract

Extract text from PDF documents for LLM processing.

## Installation

This skill uses Node.js with `pdf-parse` library. Install dependencies:

```bash
cd C:\Users\Administrator\.openclaw\workspace\skills\pdf-extract
npm install
```

## Quick Start

### Extract text from a PDF

```bash
node {baseDir}/scripts/pdf-extract.mjs "document.pdf"
```

### Examples

```bash
# Extract all text
node {baseDir}/scripts/pdf-extract.mjs "report.pdf"

# Extract from specific page
node {baseDir}/scripts/pdf-extract.mjs "document.pdf" --page 5

# Extract page range
node {baseDir}/scripts/pdf-extract.mjs "document.pdf" --pages 1-10

# Output as JSON
node {baseDir}/scripts/pdf-extract.mjs "document.pdf" --json
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--page <n>` | Extract specific page number | All pages |
| `--pages <start-end>` | Extract page range | All pages |
| `--json` | Output raw JSON with metadata | false |

## Notes

- Supports PDF files only
- Large PDFs may take longer to process
- Text extraction quality depends on PDF format (text-based vs scanned)
