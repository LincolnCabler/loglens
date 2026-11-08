# LogLens build log

One entry each Friday: what worked, what broke, what I would change. Only verified work goes here.

## Week 1 (Nov 2–8, 2026)

### What worked

- Set up two-factor on the Microsoft and GitHub accounts, plus security defaults on the Microsoft directory.
- Created the public `loglens` repo with a README, the Visual Studio .gitignore, and the MIT license; turned on secret scanning and push protection.
- Created an Azure subscription and saved a budget.
- Created the Azure DevOps organization `LincolnCabler` with a private LogLens project; confirmed free pipeline minutes.
- Set up a password manager with GitHub and Proton entries.
- Created the claude.ai Project for LogLens and added `README.md` and `CLAUDE.md`.
- Installed Git and cloned `loglens` outside OneDrive.
- Connected the repo to the claude.ai Project.
- Renamed the GitHub account to LincolnCabler before connecting pipelines; confirmed the clone and project sync still work.
- Connected Azure Pipelines to GitHub (repo `loglens` only) and ran the hello-world pipeline successfully.
- CI runs on every push to `main`. Latest run #20261105.4 (Nov 5, commit `e4aea7b`) succeeded in 16s with one warning.
- Built a Claude Code project skill, `build-log-entry`, that drafts this log from git history and pasted pipeline results; tested it on this entry.

### What broke or got in the way

- OneDrive Folder Backup redirects Documents into OneDrive, so several "Documents" entries show in File Explorer, and a tool looking in the empty local Documents folder missed the Obsidian vault. Decision: leave OneDrive alone and tidy the File Explorer navigation pane instead. The code repo clone will live outside OneDrive.
- Azure Cost Management may not show data until about Sunday, Nov 8, so the budget alert needs a re-check then.
- Authorize-versus-install confusion:  The pipelines wizard showed a GitHub authorization page that looked like a repo picker but wasn't.  Authorizing Azure DevOps to sign in is not the same as installing the app on a repo, and the wizard spinner hung until I refreshed the tab. Afterward I checked GitHub’s installed-apps page and confirmed the app is limited to the `loglens` repo only.
- Public-repo-in-private-project warning (ignored on purpose):  Azure DevOps warned that a public repo was selected in a non-public project. I ignored it on purpose: the project stays private, and the pipeline ran successfully on the standard free tier.
- The `ubuntu-latest` migration warning:  The run showed a warning that the `ubuntu-latest` label is migrating to Ubuntu 26 starting Oct 19, 2026. Still showing as of run #20261105.4. It didn’t affect the result.

### What I would change

- Pin the ubuntu-latest image version when builds start to matter, so they stay reproducible.
- Set branch policies on `main` before adding more pipelines, so nothing reaches `main` without review and a passing build.
- Write down where to find run evidence (pipeline → newest run → summary) so the weekly log doesn't stall on it.

### Open items

- Re-check Cost Management and the budget (due Nov 8): unverified, not yet done.
- Boards work items, design doc, branch policies on `main`.
- Commit the `.claude/` skill folder to the repo.