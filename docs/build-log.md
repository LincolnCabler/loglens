# LogLens build log

One entry each Friday: what worked, what broke, what I would change. Only verified work goes here.

## Week 1 (started Nov 2, 2026; entry opened Nov 4, in progress)

### What worked

- Set up two-factor on the Microsoft and GitHub accounts, plus security defaults on the Microsoft directory.
- Created the public `loglens` repo with a README, the Visual Studio .gitignore, and the MIT license; turned on secret scanning and push protection.
- Created an Azure subscription and saved a budget.
- Created the Azure DevOps organization `LincolnCabler` with a private LogLens project; confirmed free pipeline minutes.
- Set up a password manager with GitHub and Proton entries.
- Created the claude.ai Project for LogLens and added `README.md` and `CLAUDE.md`.
- Install Git and clone `loglens` outside OneDrive.
- Connect the repo to the claude.ai Project.
- Renamed the GitHub account to LincolnCabler before connecting pipelines; confirmed the clone and project sync still work.

### What broke or got in the way

- OneDrive Folder Backup redirects Documents into OneDrive, so several "Documents" entries show in File Explorer, and a tool looking in the empty local Documents folder missed the Obsidian vault. Decision: leave OneDrive alone and tidy the File Explorer navigation pane instead. The code repo clone will live outside OneDrive.
- Azure Cost Management may not show data until about Sunday, Nov 8, so the budget alert needs a re-check then.

### What I would change

- To be filled in at the end of the week.

### Open items

- Connect Azure Pipelines to GitHub (repo `loglens` only) and run a hello-world pipeline.
- Re-check Cost Management and the budget on Nov 8.
- Boards work items, design doc, branch policies on `main`