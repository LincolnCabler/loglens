---
name: build-log-entry
description: Drafts the weekly LogLens build-log entry from git history and pipeline results. Use when the user asks for a build-log entry, weekly update, or Friday log.
---

# Build-log entry

## Steps
1. Run `git log --since="7 days ago" --oneline` and list the commits.
2. Ask the user to paste the latest pipeline run status. Do not assume it passed.
3. Draft the entry in the docs/build-log.md format: What worked, What broke or got in the way, What I would change, Open items.
4. Include a claim only if a commit or pasted output supports it.

## Rules
- Mark anything unverified as "unverified" instead of stating it as done.
- Never include emails or personal details (see CLAUDE.md).

## Output
Show the draft first. Write to the file only after the user approves.