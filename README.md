# LogLens

A telemetry ingestion and AI log-analysis service, built in public as a hands-on learning project.

**Status: planning (Phase 1).** Nothing here runs yet. This README describes what is being built and will be updated as each phase lands.

## What it is

LogLens pulls events from a free public data feed, stores them in SQL Server, exposes them through a small API, and uses an analysis agent to find slow operations and anomalies in its own telemetry. A human approves any action the agent proposes.

The project is also a deliberate exercise in the parts of delivery that sit around the code: pipelines, containers, infrastructure as code, observability, and incident response.

## Planned architecture

1. **Ingest (C#, Azure Functions):** a timer trigger polls a public feed and writes raw data to Blob Storage. A queue trigger normalizes it, and a blob trigger archives it.
2. **Data (SQL Server):** Azure SQL, with SQL Server in Docker for local work. The first schema is intentionally slow. Query times are recorded before and after tuning.
3. **API (C#, ASP.NET Core Web API, Docker):** query endpoints built in layers, with xUnit unit tests and integration tests against a real SQL container.
4. **Analysis agent (Python, FastAPI):** queries Log Analytics with KQL, finds anomalies and slow operations, and summarizes them. A human approves any action.
5. **Secrets and identity:** Key Vault and managed identity. No secrets in the repo, and a secret-scanning step in CI.
6. **Delivery:** YAML pipelines (build, test, container image, deploy to dev, QA, then production with approval gates) and Bicep templates for every Azure resource.
7. **Operations:** Application Insights and OpenTelemetry traces, alert rules, a service-level objective, a runbook, and a deliberate failure that is diagnosed and written up.

## Tech

C# on the current .NET LTS, ASP.NET Core, Azure Functions, SQL Server, Python 3 and FastAPI, Docker, Bicep, Azure DevOps and GitHub Actions, Postman and Newman, a local Kubernetes cluster (kind or minikube), and Azure monitoring tools.

## Roadmap

| Phase | Weeks | Focus |
|---|---|---|
| 1 | 1-2 | Accounts, repo, boards, design doc |
| 2 | 3-5 | Ingestion functions and the SQL schema, with tuning |
| 3 | 6-7 | Web API, Docker, Container Apps, local Kubernetes, Postman tests |
| 4 | 8-9 | CI/CD pipelines and Bicep |
| 5 | 10 | Observability and an incident postmortem |
| 6 | 11-12 | Python analysis agent with human approval |

## Ground rules

- Public data and invented names only. No code, schema, tickets, or data from any employer.
- No secrets in the repository. Secret scanning and push protection are on.
- Zero-cost target: free tiers only, with budget alerts, and resources are deleted when not in use.

## Repository layout (planned)

```
/docs       design doc, decision records, runbook, postmortem
/src        C# functions and API
/analysis   Python analysis agent
/infra      Bicep templates
/pipelines  YAML pipeline definitions
```

## Running it

Instructions will be added as each phase is built.

## Author

Lincoln Cabler. See the build log in `/docs` once it exists.

## License

MIT. See [LICENSE](LICENSE).
