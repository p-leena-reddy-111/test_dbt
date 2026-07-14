# Part 2 - Prerequisites

## Knowledge required before learning dbt

dbt is approachable, but it rewards strong foundations. The most important prerequisite is not syntax. It is data modeling judgment.

## Incremental processing

You need to understand how systems avoid recomputing all history on every run.

Core ideas:

- append-only ingestion
- change data capture
- watermarks such as `updated_at` or ingestion timestamps
- idempotency
- backfills
- handling late-arriving records

Why this matters in dbt:

- incremental models are one of the most important cost and performance levers
- weak incremental design causes duplicates, missed records, or expensive full scans

Common mistakes:

- using `max(updated_at)` without accounting for late data
- assuming source timestamps are monotonic
- not defining a unique grain for merge logic

## Data modeling

You should understand:

- grain
- dimensions and facts
- slowly changing dimensions
- normalization vs denormalization
- star schemas
- semantic consistency

dbt does not invent good models. It amplifies good or bad modeling choices. If your grain is unclear, every downstream model becomes fragile.

## Git

You need working knowledge of:

- branches
- commits
- pull requests
- merge conflicts
- code review

Why Git matters:

- dbt projects are codebases
- production changes should be reviewed
- CI depends on reliable version control workflows

## YAML

YAML is used for metadata, not transformation logic. You need to understand:

- indentation sensitivity
- dictionaries and lists
- quoting rules
- booleans and strings

Common mistake:

- treating YAML as casual configuration and introducing indentation bugs that silently alter metadata behavior

## Jinja

Jinja is the templating engine dbt uses in SQL and macros. You need to understand:

- variables
- conditionals
- loops
- macro invocation
- string interpolation

Why this matters:

- dbt SQL is usually SQL plus Jinja
- advanced projects use Jinja for reuse, parameterization, and adapter-specific logic

## Key takeaways

- Incremental processing and data modeling matter more than memorizing dbt commands.
- Git, YAML, and Jinja are essential working tools in any serious dbt project.
- dbt magnifies both good engineering discipline and bad habits.

## Hands-on exercises

1. Explain the grain of five important tables in your warehouse.
2. Write a YAML document with nested model metadata and validate its indentation manually.
3. Create a small Jinja template that loops through a list of metrics.

## Interview questions

1. Why is grain the most important concept in dimensional modeling?
2. What can go wrong with incremental processing if source timestamps are unreliable?
3. Why does dbt use YAML and Jinja instead of pure SQL alone?

---
