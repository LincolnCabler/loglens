# LogLens

A demo project: telemetry ingestion and AI-assisted log analysis on Azure. Built to practice and show CI/CD, containers, infrastructure as code, event-driven services, observability, and AI-assisted development.

The master copy of code and docs lives in the public GitHub repo `loglens`.

## Where things are

- `docs/training-plan.md`: kept locally and not in the repo
- `docs/design-doc.md`: design document (Phase 1)
- `docs/build-log.md`: Friday build log (what worked, what broke, what I would change)
- `CLAUDE.md`: rules for Claude Code and Claude Projects

## Status

Last updated: Nov 4, 2026. Planned start was Nov 2, 2026.

Phase 1, Step 0 (accounts and configuration): **in progress**

Done:

- Microsoft account protected (two-factor, security defaults on the directory)
- GitHub account with two-factor; public `loglens` repo with README, secret scanning and push protection
- Azure subscription with a budget saved (Cost Management may not be fully live until about Sunday, Nov 8)
- Azure DevOps organization `LincolnCabler` with the private LogLens project; free pipeline minutes confirmed
- Password manager set up with GitHub and Proton saved
- claude.ai Project for LogLens created (with README.md and CLAUDE.md)

Still open:

1. Install Git; clone `loglens` outside OneDrive (for example `C:\Users\Lincoln Cabler\source\repos`)
2. Install the Azure Pipelines GitHub app on the `loglens` repo only; run a "hello world" pipeline (completes the Step 0 checkpoint)
3. Tools that can wait for Phase 2: Docker Desktop, Python 3, Postman, Azure CLI, Node.js and Newman; confirm Visual Studio 2026 is signed in with the personal Microsoft account
4. Connect the repo to the claude.ai Project
5. Boards work items, design doc, branch policies on `main`
6. Record Azure DevOps and Azure details in the private note and password manager

Open decision: final GitHub username (renaming later changes the profile URL).