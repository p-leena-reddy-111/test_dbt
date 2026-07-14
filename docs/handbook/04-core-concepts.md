# Part 4 - Core Concepts

## Models

A model is usually a SQL select statement that defines a dataset. dbt turns that SQL into a warehouse relation according to the configured materialization.

Lifecycle:

1. parse file
2. resolve Jinja and refs
3. compile SQL
4. execute materialization logic
5. create or update relation
6. record artifact metadata

Models should represent clear business entities or transformation steps.

Common mistake:

- creating huge all-purpose models that combine unrelated business logic

## Materializations

Materializations define how a model is persisted or inlined.

Common types:

- view
- table
- incremental
- ephemeral
- materialized view when supported by the adapter

Why materializations exist:

- different workloads have different trade-offs between cost, freshness, performance, and storage

## Sources

Sources declare upstream raw objects that dbt does not build but depends on. They provide:

- dependency references
- metadata
- tests
- freshness checks

Why sources matter:

- they formalize raw data contracts
- they keep lineage starting from ingestion tables instead of the first dbt-built model

## Seeds

Seeds are CSV files loaded by dbt into warehouse tables.

Good use cases:

- small mapping tables
- country codes
- controlled reference lists

Bad use cases:

- large operational datasets
- frequently changing source data

## Snapshots

Snapshots capture historical changes, commonly for SCD Type 2 behavior.

Use them when you need row-level change history over time.

Do not use them:

- when the source already provides full history
- when only current-state dimensions are needed

## Tests

dbt tests are SQL assertions. A test fails when the SQL query returns rows.

This design matters because it keeps validation transparent and warehouse-native.

## Macros

Macros are reusable Jinja functions. They exist to:

- reduce duplication
- encapsulate adapter-specific behavior
- generate SQL dynamically

Common mistake:

- over-abstracting simple SQL into unreadable macro layers

## Variables

Variables allow runtime parameterization through `var()`. Use them sparingly.

Good uses:

- environment-level thresholds
- feature toggles for controlled behavior

Bad uses:

- changing core business logic unpredictably across runs

## Documentation

Documentation in dbt includes:

- model descriptions
- column descriptions
- tests
- lineage
- exposures and metadata

Its value is operational, not cosmetic. Good docs reduce onboarding time and production ambiguity.

## Exposures

Exposures describe downstream consumers such as dashboards, machine learning jobs, or applications.

Why they matter:

- they connect data products to business-facing dependencies
- they improve impact analysis

## Metrics and Semantic Layer

Metrics define reusable business calculations. The Semantic Layer aims to centralize metric logic and dimensional semantics for downstream tools.

Why this exists:

- without semantic reuse, metric definitions drift across BI tools

When not to overuse it:

- when the organization is not operationally mature enough to maintain a governed semantic contract

## Groups

Groups allow ownership metadata for resources. They support governance and accountability.

## Tags

Tags support resource classification and selective execution. Example uses:

- `hourly`
- `finance`
- `pii`
- `heavy`

## Meta

`meta` stores arbitrary metadata on resources. This is useful for governance tooling, custom docs, or orchestration policies.

## Hooks

Hooks run SQL before or after resources or runs.

Use carefully. Hooks are powerful but can hide side effects.

Good uses:

- auditing inserts
- warehouse session setup

Bad uses:

- stuffing orchestration logic into model hooks

## Packages

Packages are reusable dbt code libraries. Examples include `dbt-utils` and adapter packages.

Why packages matter:

- standardized macros and tests
- reduced reinvention

Risk:

- over-dependence on external packages without version control discipline

## Dispatch

Dispatch lets dbt resolve a macro implementation by namespace and adapter. This enables cross-database abstractions.

## Config inheritance

Configs can be set at different scopes:

- project
- folder
- model file
- inline config block

dbt resolves them by precedence. Strong teams keep this simple and predictable because hidden inheritance chains are hard to debug.

## Key takeaways

- Core dbt resources are not independent features. They form a coherent asset development model.
- The strongest dbt projects keep resources explicit, modular, and easy to reason about.
- Overuse of hooks, variables, and macros is a common maturity trap.

## Hands-on exercises

1. Categorize a sample set of warehouse objects into sources, models, seeds, and snapshots.
2. Design tagging and ownership strategy for a data domain.
3. Write down three cases where a hook is justified and three where it is not.

## Interview questions

1. Why are dbt tests implemented as SQL queries returning failing rows?
2. When would you use a seed instead of a source table?
3. What problem does dispatch solve?

---
