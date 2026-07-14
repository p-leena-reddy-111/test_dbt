# Part 14 - Enterprise Best Practices

## Naming conventions

Common conventions:

- `stg_` for staging
- `int_` for intermediate
- `dim_` for dimensions
- `fct_` for facts
- `mart_` or domain-specific names for presentation models

Why naming matters:

- improves readability
- accelerates lineage interpretation
- reduces accidental misuse

## Folder organization and model layering

Two common mental models can coexist:

- medallion: Bronze, Silver, Gold
- analytics engineering layers: Staging, Intermediate, Mart

Mapping:

- Bronze roughly aligns with raw ingestion
- Silver often aligns with staging and intermediate
- Gold aligns with marts and presentation

Use the model that fits your organization, but define it clearly.

## Fact, Dimension, Mart

Facts should have:

- one clear event grain
- additive or semi-additive measures
- foreign keys to descriptive dimensions where appropriate

Dimensions should have:

- stable business keys
- conformed attributes when shared across marts

Marts should have:

- business-oriented interfaces
- limited ambiguity

## Business logic placement

Place business logic where it is easiest to govern and test.

Avoid:

- hiding KPI definitions in BI dashboards
- mixing semantics across multiple downstream layers

## Documentation

Document:

- model grain
- source dependencies
- business caveats
- owner
- SLA or refresh expectations

## Version control and code reviews

Best practices:

- small pull requests
- required review for production changes
- style guides for SQL and YAML
- CI gates on compile and tests

## Modularity and reusability

Good modularity:

- avoids repeated logic
- does not fragment models beyond readability

Bad modularity:

- dozens of tiny models that make the DAG hard to understand

## Avoiding technical debt

Watch for:

- dead models
- duplicated business logic
- unused tags and meta fields
- broken docs
- no ownership metadata

## Key takeaways

- Enterprise dbt quality depends on consistency more than cleverness.
- Layering, naming, and review discipline reduce operational entropy.
- Business logic should be centralized and documented.

## Hands-on exercises

1. Write a naming standard for a dbt team.
2. Audit a hypothetical project for technical debt symptoms.
3. Decide whether three pieces of logic belong in staging, intermediate, mart, or BI.

## Interview questions

1. What is the difference between good modularity and over-fragmentation?
2. Why should KPI logic stay out of dashboards when possible?
3. How do naming conventions affect maintainability?

---
