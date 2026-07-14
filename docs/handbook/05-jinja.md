# Part 5 - Jinja

## Why Jinja exists in dbt

Pure SQL becomes repetitive quickly. Warehouses differ, environments differ, and many models share patterns. Jinja gives dbt controlled metaprogramming.

The purpose is not to turn SQL into a programming language. The purpose is to remove duplication and enable maintainable patterns.

## Variables

Example:

```sql
select *
from {{ ref('fct_orders') }}
where order_date >= '{{ var("start_date", "2024-01-01") }}'
```

Use variables for runtime parameters with stable meaning.

Anti-pattern:

- dozens of hidden vars that make compiled SQL unpredictable

## Loops

Example:

```sql
select
    customer_id,
    {% for metric in ['revenue', 'discount', 'tax'] %}
    sum({{ metric }}) as total_{{ metric }}{% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_orders') }}
group by 1
```

Why loops help:

- reduce repetitive aggregations
- keep column families consistent

When not to use loops:

- when the generated SQL becomes harder to understand than the repeated SQL

## If statements

Example:

```sql
select *
from {{ ref('stg_events') }}
{% if target.name == 'dev' %}
where event_date >= current_date - 7
{% endif %}
```

Use with caution. Environment-specific filters are useful for dev acceleration, but production semantics should remain stable.

## Functions and built-ins

Important built-ins:

- `ref()`
- `source()`
- `var()`
- `config()`
- `env_var()`
- `target`
- `this`
- `run_query()`
- `adapter`
- `log()`
- `exceptions.raise_compiler_error()`

## Macros

Simple macro example:

```sql
{% macro cents_to_dollars(column_name) %}
    ({{ column_name }} / 100.0)
{% endmacro %}
```

Usage:

```sql
select {{ cents_to_dollars('amount_cents') }} as amount_usd
from {{ ref('stg_payments') }}
```

## Refactoring SQL

A useful standard:

- if repeated SQL appears in more than two or three places and represents a stable pattern, consider a macro
- if the logic is business-specific and only appears once, keep it inline

## Dynamic SQL generation

Example pivot-style generation:

```sql
{% set channels = ['search', 'social', 'email'] %}

select
    session_date,
    {% for channel in channels %}
    sum(case when channel = '{{ channel }}' then sessions else 0 end) as sessions_{{ channel }}{% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_sessions') }}
group by 1
```

Trade-off:

- concise source code
- potentially very large compiled SQL

## Common patterns

- reusable surrogate key generation
- null-safe comparison wrappers
- adapter-specific date spine logic
- incremental filter generators
- standardized test macros

## Common mistakes

- hiding too much SQL behind macros
- debugging source Jinja instead of inspecting compiled SQL
- mixing business logic and environment logic carelessly

## Key takeaways

- Jinja is a maintainability tool, not a license to over-engineer SQL.
- Good Jinja makes repetitive SQL shorter and clearer.
- Always debug through compiled SQL, not only through template source.

## Hands-on exercises

1. Create a macro that standardizes boolean casting.
2. Rewrite repetitive metric SQL using a loop.
3. Inspect the compiled SQL and compare readability before and after templating.

## Interview questions

1. When should a macro be avoided even if it reduces duplication?
2. What is the risk of heavy Jinja abstraction?
3. How do you debug a Jinja-related dbt issue?

---
