---
name: find-skill
description: Skill discovery and installation assistant. Helps users find and install skills from the ecosystem.
homepage: https://clawhub.ai/Breckengan/find-skill
metadata: {"openclaw":{"emoji":"🔍","requires":{"bins":["node","npm"]}}}
---

# Find Skill

A skill discovery tool that helps you find and install other skills from the ecosystem.

## Quick Start

### Search for skills

```bash
node {baseDir}/scripts/find-skill.mjs "react"
node {baseDir}/scripts/find-skill.mjs "testing"
node {baseDir}/scripts/find-skill.mjs "docker deploy"
```

### Install a skill

```bash
npx skills add <owner/repo@skill>
```

## Examples

| User Need | Search Command |
|-----------|----------------|
| React performance | `find-skill.mjs "react performance"` |
| PR review help | `find-skill.mjs "pr review"` |
| Generate changelog | `find-skill.mjs "changelog"` |
| Testing tools | `find-skill.mjs "testing"` |
| Docker deployment | `find-skill.mjs "docker"` |

## Common Skill Categories

- **Web Dev**: react, nextjs, typescript, css, tailwind
- **Testing**: testing, jest, playwright, e2e
- **DevOps**: deploy, docker, kubernetes, ci-cd
- **Docs**: docs, readme, changelog, api-docs
- **Code Quality**: review, lint, refactor, best-practices

## Other Commands

| Command | Function |
|---------|----------|
| `npx skills check` | Check for skill updates |
| `npx skills update` | Update all installed skills |
| `npx skills init` | Create a custom skill |

## Tips

- Search with keywords related to your task
- Review skills before installing (check source, maintainer, popularity)
- Use `-g` flag for global installation
- Use `-y` flag to skip confirmation prompts
