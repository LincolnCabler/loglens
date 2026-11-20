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

## Week 2 (Nov 9–15, 2026)

### What worked

- Added 18 Pester tests for the push-guard hooks. They cover `check-emails.ps1`, the Claude `push-guard.ps1` hook (7 push forms blocked, 5 non-push commands allowed) and the git pre-push hook, which is tested with a real push to a local bare repo. Each test uses a throwaway repo, and no literal email appears in the test file.
- Checked that the tests catch real regressions. On Windows PowerShell 5.1, putting back the old narrow push pattern fails 4 tests, and putting back the path-text scan bug fails 9.
- Replaced the hello-world pipeline steps with real CI. The pipeline now runs on pull requests into `main` as well as pushes, and it installs a pinned Pester (6.2.0) and publishes the hook test results.
- Made the pre-push hook use `pwsh` when it's available, so it also works on macOS, Linux and the Linux pipeline agent.
- Added the .NET 10 SDK and the xUnit tests to the pipeline, with results published as a separate ".NET tests" run. The .NET steps use `succeededOrFailed()`, so one run reports both suites even if the hook tests fail.
- Added a project-scoped Azure DevOps MCP server for Claude Code. It's limited to Boards and uses a read-only token kept outside the repo. Tested: it listed the LogLens project.
- Merged both changes through pull requests (#4 and #5).
- Pipeline run #20261109.4 on commit `06099a5` (the PR #5 merge) succeeded with one warning. Both test runs passed on the Linux agent: 23 of 23 tests, 5 more than the previous run, in a test duration of 16.8s.

### What broke or got in the way

- The Azure DevOps MCP server's default sign-in uses Microsoft Entra, and it rejected the personal Microsoft account. I switched to token authentication: the server reads a personal access token from my environment, scoped to Work Items: Read and Project and Team: Read.
- Both test changes were verified only on Windows when they were committed. Linux was confirmed later by pipeline run #20261109.4.
- The `ubuntu-latest` migration warning (moving to Ubuntu 26 from Oct 19, 2026) still appears as of run #20261109.4. It didn't affect the result.

### What I would change

- Pin the agent image now. The pipeline runs real tests, so a silent switch to Ubuntu 26 could change results.
- Set branch policies on `main` (a required build on pull requests) now that pull requests trigger CI. Nothing enforces a passing build before merge yet.
- Keep the commit-message habit of saying what was verified and where (for example "Linux run not yet verified"). It made this log easy to write.

### Open items

- Re-check Cost Management and the budget alert: unverified, carried over from Week 1.
- Boards work items, design doc (`docs/design-doc.md` is still headings only), and branch policies on `main`.
- Pin the pipeline agent image.
