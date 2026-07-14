# Part 15 - Performance Optimization

## Query optimization

dbt cannot rescue poor SQL design. Warehouse engines still execute the SQL. Focus on:

- selective filters
- avoiding unnecessary cross joins
- reducing repeated scans
- predicate pushdown opportunities
- join order awareness where relevant to the platform

## Model optimization

Ask:

- should this be persisted instead of a view?
- should this large transformation be split for reuse and stability?
- is the grain correct and minimal?

## Incremental optimization

Optimize:

- filter predicates
- partition alignment
- clustering or sorting keys where available
- merge scope reduction

## Partition pruning

Pruning matters when the engine can skip data segments or files. Your SQL must actually filter on the partition-aligned column in a compatible way.

Common mistake:

- wrapping partition columns in expressions that defeat pruning

## Clustering

Clustering or sorting can improve scan efficiency for repeated access patterns. It is workload-dependent and platform-specific.

## Caching

Some warehouses cache results or metadata. Do not build correctness assumptions on cache behavior. Treat cache as opportunistic performance, not a contract.

## Parallel execution and threading

dbt parallelism is graph- and thread-driven. More threads are not always better.

Too many threads can:

- overload the warehouse
- increase queueing
- raise costs
- contend with other workloads

## Reducing warehouse costs

Strategies:

- incrementalize large stable tables
- persist high-value shared intermediates
- reduce unnecessary full refreshes
- use dev row limiting carefully
- tune warehouse size to actual concurrency needs

## Model selection

Run only what changed when possible. Selectors and state comparison are major cost controls in CI.

## Compile optimization

Partial parsing reduces parse overhead on large projects. Macro design can also affect compile time significantly.

## Key takeaways

- Performance optimization in dbt is mostly about SQL design, storage layout, and execution scope.
- Thread count and incremental strategy should be tuned, not guessed.
- Cost optimization and correctness must be balanced deliberately.

## Hands-on exercises

1. Identify three SQL patterns that would defeat partition pruning.
2. Decide where persistence would outperform a deep view chain.
3. Create a cost-reduction plan for a project with too many full rebuilds.

## Interview questions

1. Why can increasing thread count make performance worse?
2. How does partition pruning affect cost?
3. What is partial parsing solving?

---
