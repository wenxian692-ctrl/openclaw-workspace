#!/usr/bin/env node

function usage() {
  console.error(`Usage: find-skill.mjs <search-query>

Search for skills in the ClawHub ecosystem.

Options:
  -h, --help    Show this help message

Examples:
  find-skill.mjs "react"
  find-skill.mjs "testing"
  find-skill.mjs "docker deploy"
  find-skill.mjs "pr review"
  find-skill.mjs "changelog"

Common Categories:
  - Web Dev: react, nextjs, typescript, css, tailwind
  - Testing: testing, jest, playwright, e2e
  - DevOps: deploy, docker, kubernetes, ci-cd
  - Docs: docs, readme, changelog, api-docs
  - Code Quality: review, lint, refactor, best-practices

Installing Skills:
  npx skills add <owner/repo@skill>
  npx skills add <owner/repo@skill> -g -y  (global, no prompt)

Other Commands:
  npx skills check    - Check for skill updates
  npx skills update   - Update all installed skills
  npx skills init     - Create a custom skill

Browse skills at: https://clawhub.ai/
`);
  process.exit(0);
}

const args = process.argv.slice(2);
if (args.length === 0 || args[0] === "-h" || args[0] === "--help") usage();

const query = args.join(" ");

console.log("🔍 Find Skill - Skill Discovery Assistant\n");
console.log("=" .repeat(50));
console.log(`\nSearch Query: ${query}\n`);

// Search ClawHub
const searchUrl = `https://clawhub.ai/search?q=${encodeURIComponent(query)}`;
console.log(`📋 Browse results: ${searchUrl}\n`);

// Common skills matching the query
console.log("💡 Quick Actions:\n");
console.log(`1. Install a skill:`);
console.log(`   npx skills add <owner/repo@skill> -g -y\n`);

console.log(`2. Search more skills:`);
console.log(`   Visit https://clawhub.ai/ or https://skills.sh/\n`);

console.log(`3. Check installed skills:`);
console.log(`   npx skills check\n`);

console.log(`4. Update skills:`);
console.log(`   npx skills update\n`);

console.log("=" .repeat(50));
console.log("\n📚 Skill Categories:\n");
console.log("  Web Dev:     react, nextjs, typescript, css, tailwind");
console.log("  Testing:     testing, jest, playwright, e2e");
console.log("  DevOps:      deploy, docker, kubernetes, ci-cd");
console.log("  Docs:        docs, readme, changelog, api-docs");
console.log("  Code Quality: review, lint, refactor, best-practices");
console.log("\n");
