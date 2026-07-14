# Part 10 - Sources

## Why sources matter

Sources are the formal boundary between ingestion and transformation. They declare what raw data exists and what dbt expects from it.

## Freshness

Freshness checks ask whether source data arrived recently enough.

Example:

```yaml
sources:
  - name: raw
    tables:
      - name: orders
        loaded_at_field: ingested_at
        freshness:
          warn_after: {count: 2, period: hour}
          error_after: {count: 6, period: hour}
```

Why this matters:

- broken transformation logic is not the only failure mode
- stale raw data can invalidate executive reporting just as much as SQL bugs

## Source testing

Apply tests early to catch ingestion issues before they spread.

Typical source checks:

- primary key uniqueness where expected
- required fields not null
- accepted status values

## Source documentation

Document:

- system of origin
- ingestion owner
- update cadence
- latency expectations
- business caveats

## External tables

In lakehouse systems, raw sources may be external tables over object storage. dbt can reference them as sources just like database-native tables.

Considerations:

- schema drift is often more common
- partition metadata quality matters
- ingestion SLA may be less deterministic

## Raw layer

A strong rule:

- do not treat raw as business-ready
- do minimal assumptions
- keep staging responsible for standardization and sanitization

## Key takeaways

- Sources define the contract between ingestion and transformation.
- Freshness checks are operational guardrails, not optional extras.
- Source documentation reduces ambiguity when incidents happen.

## Hands-on exercises

1. Define three raw sources with freshness thresholds.
2. Add source tests that would catch common ingestion problems.
3. Write source documentation for a CDC orders table.

## Interview questions

1. Why should source tests exist if ingestion is managed by another team?
2. What is freshness checking actually validating?
3. How should a raw layer differ from staging?

---
