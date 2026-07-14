# Part 12 - Macros

## Reusable SQL

Macros let teams centralize patterns such as:

- surrogate key generation
- safe division
- null normalization
- date spine generation

Example:

```sql
{% macro safe_divide(numerator, denominator) %}
    case when {{ denominator }} = 0 then null else {{ numerator }} / {{ denominator }} end
{% endmacro %}
```

## Dynamic SQL

Macros can generate SQL based on inputs, metadata, or adapter.

Use cases:

- dynamic pivots
- repetitive audit queries
- dynamic merge predicates

## Adapter dispatch

Dispatch allows a single macro call to resolve to warehouse-specific implementations.

Example idea:

- a generic `generate_surrogate_key()` macro that differs by adapter because hash functions vary

## Macro packages

Package macros help standardize behavior across projects. Internal package patterns are common in large organizations.

Examples:

- shared fiscal calendar macros
- PII masking helpers
- enterprise testing library

## Recursive macros

Possible, but use sparingly. If the macro layer becomes hard to reason about, maintainability collapses.

## Logging

Use `log()` to expose useful compile or runtime details for debugging.

## Exceptions

Use compiler errors for invalid configuration or impossible states.

Example:

```sql
{% if var('load_window_days', 0) < 0 %}
  {{ exceptions.raise_compiler_error('load_window_days must be non-negative') }}
{% endif %}
```

## Common mistakes

- writing macros that obscure simple SQL
- treating macros as general-purpose application code
- insufficient testing of macro packages across adapters

## Key takeaways

- Macros should improve consistency and maintainability, not hide logic unnecessarily.
- Dispatch is a major tool for multi-platform portability.
- Compiler-time validation in macros can prevent expensive runtime failures.

## Hands-on exercises

1. Build a macro for safe division.
2. Sketch an adapter-dispatched surrogate key macro.
3. Add compile-time validation to a macro using exceptions.

## Interview questions

1. What is adapter dispatch and why is it important?
2. When do macros become an anti-pattern?
3. Why might logging inside macros be useful?

---
