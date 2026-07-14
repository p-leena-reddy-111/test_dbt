# Part 3 - dbt Core Installation

## dbt Core vs dbt Cloud

dbt Core is the open-source command line product. You manage:

- installation
- credentials
- orchestration
- CI/CD
- environments

dbt Cloud adds a managed web application with:

- IDE and job orchestration
- environment management
- artifact browsing
- scheduler and metadata features

Choose dbt Core when:

- you want full control
- you already have orchestration and CI standards
- platform engineering prefers open tooling

Choose dbt Cloud when:

- you want faster operational onboarding
- you prefer managed jobs and web UX
- your team benefits from integrated governance features

## Installation

Typical installation approach:

1. install Python
2. create a virtual environment
3. install `dbt-core`
4. install a warehouse adapter such as `dbt-databricks`, `dbt-bigquery`, `dbt-redshift`, or `dbt-spark`

Example:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install dbt-core dbt-databricks
```

Best practice:

- pin versions in dependency management
- align adapter and core versions
- standardize Python version across environments

## Adapters

The adapter is what makes dbt work against a specific engine. It provides warehouse-specific implementations for:

- connection handling
- relation naming
- DDL and DML patterns
- incremental strategies
- catalog generation
- adapter macros

Why adapters matter:

- not every materialization behaves the same across warehouses
- performance techniques vary significantly

Example differences:

- BigQuery favors partitioning and clustering
- Redshift performance often depends on sort and distribution design
- Databricks may use Delta Lake merge semantics, file compaction patterns, and SQL warehouse sizing

## Profiles

`profiles.yml` defines connection profiles outside the project. This separation exists because credentials and environment-specific connectivity should not usually live inside source-controlled project code.

Typical location:

- user home directory under `.dbt/profiles.yml`

## profiles.yml

Example:

```yaml
enterprise_dbt:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: analytics_dev
      schema: dbt_alice
      host: dbc-1234567890123456.cloud.databricks.com
      http_path: /sql/1.0/warehouses/abc123def4567890
      token: "{{ env_var('DBT_DATABRICKS_TOKEN') }}"
      threads: 4
    prod:
      type: databricks
      catalog: analytics_prod
      schema: analytics
      host: dbc-1234567890123456.cloud.databricks.com
      http_path: /sql/1.0/warehouses/fedcba0987654321
      token: "{{ env_var('DBT_DATABRICKS_TOKEN') }}"
      threads: 16
```

Important properties you will commonly see:

- `type`: adapter type
- `account`, `host`, `server`, `project`, `token`: engine-specific connectivity settings
- `user`, `password`, `private_key`, `oauth`: authentication method
- `database` or `catalog`: logical database target
- `schema`: target schema
- `warehouse`, `cluster`, `http_path`: compute target depending on platform
- `role`: security context
- `threads`: max concurrent model execution threads
- `target`: default named environment output

Guidelines:

- use environment variables for secrets
- avoid personal schemas in shared prod targets
- isolate dev schemas per engineer
- align catalog and schema naming with Unity Catalog conventions when applicable

## dbt_project.yml

This is the project control plane. It defines project identity, paths, defaults, model configs, and behavior.

Example:

```yaml
name: enterprise_dbt
version: 1.0.0
config-version: 2

profile: enterprise_dbt

model-paths: ["models"]
seed-paths: ["seeds"]
snapshot-paths: ["snapshots"]
macro-paths: ["macros"]
test-paths: ["tests"]
analysis-paths: ["analyses"]
docs-paths: ["docs"]
target-path: "target"
clean-targets: ["target", "dbt_packages"]

models:
  enterprise_dbt:
    staging:
      +materialized: view
    intermediate:
      +materialized: ephemeral
    marts:
      +materialized: table

vars:
  currency: USD

flags:
  partial_parse: true
```

Important properties and why they exist:

- `name`: unique project name used in namespaces and artifacts
- `version`: project version for governance and package semantics
- `config-version`: dbt configuration schema version
- `profile`: which profile name to use from `profiles.yml`
- `*-paths`: where dbt should look for resource files
- `target-path`: where compiled files and artifacts are written
- `clean-targets`: directories that `dbt clean` removes
- `models`, `seeds`, `snapshots`, `tests`: resource-level default configs
- `vars`: user-defined runtime variables
- `flags`: engine behavior toggles such as partial parsing
- `require-dbt-version`: protect compatibility boundaries
- `packages-install-path`: customize package install location if needed

## Environment setup

A practical enterprise setup usually includes:

- local virtual environment or container
- standardized adapter version
- environment variables for credentials
- dev schema isolation
- Databricks SQL warehouse or approved cluster for execution
- CI profile for pull request validation
- production service principal or service account

## Targets

A target is a named output environment in `profiles.yml`. Common targets:

- `dev`
- `qa`
- `prod`

Why targets exist:

- same project code, different execution context
- different catalogs, schemas, compute sizes, credentials, or workspaces

## Dev, QA, Prod environments

Recommended pattern:

- Dev: personal schemas, smaller SQL warehouses, fast iteration
- QA: shared integration validation, production-like datasets when feasible
- Prod: controlled service account, stable schemas, monitored jobs on governed Databricks compute

Common mistakes:

- running development work in production schemas
- pointing prod and dev to the same schema
- overusing environment conditionals inside model SQL instead of keeping logic environment-agnostic

## Key takeaways

- dbt Core requires explicit setup, but that control is valuable in enterprise environments.
- The adapter determines many warehouse-specific behaviors.
- `profiles.yml` controls connectivity; `dbt_project.yml` controls project behavior.
- Strong environment isolation prevents accidental production damage.

## Hands-on exercises

1. Draft a `profiles.yml` for your preferred warehouse with separate dev and prod targets.
2. Explain every property in a sample `dbt_project.yml`.
3. Design a local developer workflow with virtual environments and secret management.

## Interview questions

1. What is the difference between `profiles.yml` and `dbt_project.yml`?
2. Why should credentials live outside the project repository?
3. What problems do separate dev, QA, and prod targets prevent?

---
