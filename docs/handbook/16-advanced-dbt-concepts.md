# Part 16 - Advanced dbt Concepts

## State comparison

State comparison uses prior artifacts to determine what changed between project versions.

Why it matters:

- supports slim CI
- reduces unnecessary builds

## Deferral

Deferral lets unresolved upstream references point to previously built production relations instead of requiring all parents to be rebuilt in CI.

This is powerful because it enables realistic validation without full environment duplication.

## Selectors

Selectors define reusable selection logic for nodes. They improve operational consistency for jobs and CI.

## Artifacts

Major artifacts:

- `manifest.json`
- `run_results.json`
- `catalog.json`
- sources freshness results where applicable

## Partial parsing

Partial parsing speeds startup by reusing parse information when only part of the project changed.

## Slim CI

Slim CI usually means:

- compare current branch state to a prior manifest
- build only modified nodes and relevant children
- defer unchanged parents to production objects

## Contracts

Model contracts enforce expected schema and types for model outputs.

Why they matter:

- prevent downstream surprises
- improve platform governance

## Versioned models

Versioning allows controlled breaking changes and coexistence of old and new model interfaces.

## Mesh

dbt Mesh is an organizational and technical approach for multi-team data products with clear ownership and controlled cross-project interfaces.

## Cross-project references

These allow dependencies across projects, but should be governed carefully to avoid tight coupling.

## Semantic Layer, Metrics, Groups, Access control, Exposures

These features support enterprise governance, discoverability, and standardized consumption.

## Python models

Supported on some platforms. Use them when logic is better expressed in Python and the adapter/platform supports the execution semantics you need.

Do not assume Python models are a universal substitute for SQL models.

## Unit Tests

Unit tests validate model logic against controlled inputs. They are useful for deterministic transformation behavior and faster confidence in critical logic.

## Model Contracts

Contracts formalize expectations about columns and types. They are especially valuable where multiple teams depend on stable interfaces.

## Key takeaways

- Advanced dbt features are mainly about scale: scale of codebase, teams, governance, and CI efficiency.
- State, deferral, selectors, and contracts are foundational in enterprise operations.
- Mesh only succeeds with strong ownership boundaries and disciplined interfaces.

## Hands-on exercises

1. Design a slim CI workflow using state comparison and deferral.
2. Decide which models in a project should have contracts.
3. Sketch cross-project boundaries for a multi-domain mesh.

## Interview questions

1. What is deferral and why is it useful in CI?
2. Why are contracts important in large organizations?
3. What problem does dbt Mesh solve?

---
