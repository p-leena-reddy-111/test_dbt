# Part 19 - Common Interview Questions

## Beginner questions

### What is dbt?

Expected answer:

dbt is a transformation framework for analytics engineering that lets teams define data models, tests, documentation, and lineage in code, usually using SQL and Jinja, executed inside a warehouse or lakehouse.

### What is `ref()`?

Expected answer:

`ref()` creates a dependency between models and resolves the correct relation name for the target environment.

## Intermediate questions

### Why use incremental models?

Expected answer:

To reduce cost and runtime by processing only changed data, while preserving correctness through unique keys, watermarks, and warehouse-specific strategies.

### What is the difference between staging and marts?

Expected answer:

Staging standardizes raw data with minimal business logic. Marts expose business-ready entities and metrics for consumption.

## Advanced questions

### How would you design dbt for a multi-team enterprise?

Expected answer:

Use domain ownership, strong naming conventions, contracts, CI/CD, artifacts, deferral, selectors, lineage governance, and clear boundaries for shared models and cross-project interfaces.

### What are the biggest risks in incremental models?

Expected answer:

Missed late-arriving updates, incorrect unique keys, weak backfill strategy, and merge performance issues.

### When would you not use dbt?

Expected answer:

When the workload is not well expressed in SQL assets, requires streaming or complex iterative computation, or needs heavy custom distributed processing better suited to Spark or code-native pipelines.

## Key takeaways

- Strong interview answers explain trade-offs, not just definitions.
- Senior-level answers connect dbt features to operating models, reliability, and platform design.

## Hands-on exercises

1. Practice answering five questions aloud in under two minutes each.
2. Rewrite a weak feature-only answer into a trade-off-based answer.
3. Prepare examples from your own work for incremental, testing, and CI/CD topics.

## Interview questions

1. What is the difference between a definition answer and a senior-level answer?
2. Why are trade-offs central to dbt interview performance?
3. How do you demonstrate enterprise maturity in answers?

---
