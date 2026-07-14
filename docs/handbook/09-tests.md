# Part 9 - Tests

## Built-in tests

Built-in generic tests:

- `unique`
- `not_null`
- `accepted_values`
- `relationships`

Example YAML:

```yaml
models:
  - name: dim_customers
    columns:
      - name: customer_id
        tests:
          - not_null
          - unique
      - name: customer_status
        tests:
          - accepted_values:
              values: ['active', 'inactive', 'churned']
```

## How tests execute

Tests compile to SQL queries that return failing rows.

`not_null` shape:

```sql
select *
from analytics.dim_customers
where customer_id is null
```

`unique` shape:

```sql
select customer_id
from analytics.dim_customers
group by 1
having count(*) > 1
```

Why this approach is excellent:

- transparent
- warehouse-native
- easy to debug

## Performance

Tests can become expensive on very large models. Strategies:

- test at the right layer
- use filtered custom tests for very large historical assets
- run critical tests on every PR, broader suites on scheduled jobs

## Generic tests

Generic tests are parameterized test macros attached in YAML.

Use when:

- the same assertion applies across many models or columns

## Singular tests

Singular tests are standalone SQL files under `tests/`.

Use when:

- the assertion is complex or cross-table

Example:

```sql
select order_id
from {{ ref('fct_orders') }}
where order_total < 0
```

## Custom tests

Custom tests are often implemented as generic test macros or singular SQL checks for business rules.

Examples:

- one active subscription per customer
- fact rows must map to valid dimension windows
- event timestamps cannot precede account creation date

## `dbt-utils` tests

Common examples:

- `expression_is_true`
- `unique_combination_of_columns`
- `recency`

These save time but should still be understood, not blindly used.

## Expectations package

Expectation-style packages offer richer assertion vocabulary similar to data quality frameworks.

Trade-off:

- more expressive
- sometimes more abstraction and more runtime cost

## Test severity and warnings

dbt tests can fail or warn. Use warnings for:

- non-critical thresholds
- freshness drift that should page only after escalation

Do not downgrade genuinely broken data contracts to warnings just to keep pipelines green.

## Storing test results

You can persist failures using store-failures patterns so bad records are inspectable. This is extremely useful in operations.

## Alerting

Common pattern:

- CI fails on broken model-level tests
- scheduled production jobs publish alerts to Slack, Teams, PagerDuty, or incident tooling

## CI/CD integration

Typical strategy:

- PR: compile, modified model selection, fast tests
- main branch: broader validation
- production: run build and publish artifacts

## Common mistakes

- too few tests at the source and staging layers
- only testing not null and unique, ignoring business logic
- running every expensive test on every pull request

## Key takeaways

- dbt tests are executable SQL assertions.
- Test breadth should increase with model criticality.
- Business-rule tests are where mature analytics engineering differentiates itself.

## Hands-on exercises

1. Write a singular test for negative revenue.
2. Design a generic test for one current subscription per user.
3. Split a hypothetical test suite into PR-time and nightly execution sets.

## Interview questions

1. How does dbt implement tests under the hood?
2. What is the difference between generic and singular tests?
3. Why might you store test failures as tables?

---
