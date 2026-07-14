# Part 18 - dbt + CI/CD

## Goals of CI/CD for dbt

CI/CD is not only about deployment automation. It is about preventing broken data contracts from reaching production.

## GitHub Actions

Typical flow:

1. checkout code
2. install Python and dbt adapter
3. restore or fetch production manifest
4. run `dbt deps`
5. run compile and slim CI selection
6. run tests
7. publish artifacts

## Azure DevOps

Equivalent concepts apply:

- pipelines
- environment variables and secrets
- artifact publishing
- stage promotion

## Pull Requests

A strong PR process includes:

- SQL and YAML review
- DAG impact awareness
- test expectations
- artifact inspection when needed

## Testing

In CI, prioritize:

- modified nodes
- critical parent/child dependencies
- fast but meaningful assertions

## Deployment and promotion

Promotion should be deterministic:

- merge to main
- build in controlled environment
- publish artifacts
- run production job with service credentials

## Artifacts

Artifacts support:

- state comparison
- debugging
- lineage inspection
- deployment evidence

## Environment management

Keep:

- separate secrets
- distinct schemas or catalogs
- predictable target naming

## Rollback

Rollback strategy may include:

- reverting Git commit
- rerunning prior production version
- deferring to previous stable artifacts
- full refresh for damaged assets if necessary

## Key takeaways

- dbt CI/CD should validate data assets, not just code syntax.
- Slim CI and artifact reuse significantly reduce time and cost.
- Rollback must be planned before incidents, not during them.

## Hands-on exercises

1. Design a GitHub Actions workflow for dbt slim CI.
2. Define rollback steps for a broken incremental model deployment.
3. Split CI checks into fast PR checks and heavier scheduled checks.

## Interview questions

1. Why are artifacts important in dbt CI/CD?
2. What does slim CI optimize for?
3. How would you roll back a bad production dbt release?

---
