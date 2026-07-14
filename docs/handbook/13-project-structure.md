# Part 13 - Project Structure

## Recommended folder structure

```text
models/
  staging/
  intermediate/
  marts/
    dimensions/
    facts/
    reporting/
snapshots/
macros/
tests/
analyses/
seeds/
docs/
```

## Why each folder exists

### models/staging

Purpose:

- rename columns
- cast types
- standardize flags
- lightly clean raw data

Why it exists:

- creates a stable interface between chaotic raw data and downstream logic

### models/intermediate

Purpose:

- reusable joins
- business-rule enrichment
- grain transitions

Why it exists:

- prevents marts from becoming monoliths

### models/marts

Purpose:

- business-facing entities
- facts, dimensions, and domain marts

### dimensions

Purpose:

- descriptive entities used for slicing and filtering

### facts

Purpose:

- measurable business events at a clear grain

### reporting

Purpose:

- purpose-built presentation models for high-value consumption patterns

### snapshots

Purpose:

- historical state capture

### macros

Purpose:

- reusable SQL and cross-platform abstractions

### tests

Purpose:

- singular assertions and special quality checks

### analyses

Purpose:

- ad hoc analytical SQL kept under version control without becoming production models

### seeds

Purpose:

- small controlled lookup tables

### docs

Purpose:

- supporting long-form engineering documentation and project docs

## Example enterprise project

Domain-oriented extension:

```text
models/
  staging/
    marketing/
    sales/
    finance/
  intermediate/
    marketing/
    shared/
  marts/
    core/
    marketing/
    finance/
```

## Key takeaways

- Folder structure is about cognitive clarity, not aesthetics.
- Staging should standardize, intermediate should compose, marts should present business-ready assets.
- A good structure makes ownership and model purpose obvious.

## Hands-on exercises

1. Design folder structure for a three-domain enterprise project.
2. Move a hypothetical monolithic marts model into staging, intermediate, and mart layers.
3. Define ownership conventions by folder or domain.

## Interview questions

1. Why separate staging from intermediate models?
2. What belongs in `analyses/` instead of `models/`?
3. How should enterprise folder structure evolve with multiple domains?

---
