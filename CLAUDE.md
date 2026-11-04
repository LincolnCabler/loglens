# LogLens: project rules

## Purpose

Public demo project that shows senior-level skills: Azure Functions, SQL Server tuning, containers, CI/CD, infrastructure as code (Bicep), observability, and AI-assisted development. It must stay presentable to a recruiter.

## Hard rules

- **No employer material.** Nothing from any current or past employer: no code, schema, ticket text, data, names, or screenshots. Use public data and invented names only.
- **No secrets in the repo.** No keys, passwords, tokens or connection strings. Use Key Vault and managed identity; run secret scanning before every push.
- **Zero cost.** Stay inside free tiers. No paid AI API. Keep a budget alert on the Azure subscription; keep every Azure resource in one resource group so it can be deleted.
- **Honest claims.** Only describe work that was actually done and verified.

## Conventions

- C# on the current .NET LTS, SOLID layers, xUnit tests; Python 3 with FastAPI for the analysis service.
- Small pull requests, one reviewer (the owner) plus Claude as a second reviewer; work tracked in Azure Boards.
- Update `docs/build-log.md` each Friday.

## Owner

Lincoln Cabler. Using personal Microsoft account. Never ask for or accept passwords or tokens in chat.

## Status

Phase 1, Step 0 (accounts): in progress as of Nov 4, 2026. Accounts, public `loglens` repo with secret scanning, Azure budget, and Azure DevOps project are done. Open: connect Azure Pipelines to GitHub, run a hello-world pipeline. Full checklist is in `README.md`.