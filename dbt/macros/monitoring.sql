{% macro ensure_monitoring_tables() %}

{% set create_counts_table_sql %}
create table if not exists test.model_counts (
    run_id string,
    table_name string,
    source_count bigint,
    target_count bigint,
    filtered_count bigint,
    deduped_count bigint,
    incremental_source_count bigint,
    incremental_target_count bigint,
    window_start timestamp,
    run_time timestamp
)
{% endset %}

{% do run_query(create_counts_table_sql) %}

{% endmacro %}

{% macro capture_incremental_watermark(table_name, target_relation, watermark_column, initial_value) %}

{% do ensure_monitoring_tables() %}

{% set existing_relation = adapter.get_relation(
    database=target_relation.database,
    schema=target_relation.schema,
    identifier=target_relation.identifier
) %}

{% if existing_relation is none %}
    {% set watermark_sql %}
    select cast('{{ initial_value }}' as timestamp) as window_start
    {% endset %}
{% else %}
    {% set watermark_sql %}
    select coalesce(max({{ watermark_column }}), cast('{{ initial_value }}' as timestamp)) as window_start
    from {{ existing_relation }}
    {% endset %}
{% endif %}

{% set delete_sql %}
delete from test.model_counts
where run_id = '{{ invocation_id }}'
  and table_name = '{{ table_name }}'
{% endset %}

{% set insert_sql %}
insert into test.model_counts (
    run_id,
    table_name,
    source_count,
    target_count,
    filtered_count,
    deduped_count,
    incremental_source_count,
    incremental_target_count,
    window_start,
    run_time
)
select
    '{{ invocation_id }}' as run_id,
    '{{ table_name }}' as table_name,
    cast(null as bigint) as source_count,
    cast(null as bigint) as target_count,
    cast(null as bigint) as filtered_count,
    cast(null as bigint) as deduped_count,
    cast(null as bigint) as incremental_source_count,
    cast(null as bigint) as incremental_target_count,
    window_start,
    current_timestamp as run_time
from (
    {{ watermark_sql }}
)
{% endset %}

{% do run_query(delete_sql) %}
{% do run_query(insert_sql) %}

{% endmacro %}

{% macro log_counts(table_name,
        bronze_relation,
        silver_relation,
        filtered_condition,
        dedupe_columns,
        order_column,
        watermark_column) %}

{% do ensure_monitoring_tables() %}

{% set sql %}

update test.model_counts
set
    source_count = (
        select count(*)
        from {{ bronze_relation }}
    ),
    target_count = (
        select count(*)
        from {{ silver_relation }}
    ),
    filtered_count = (
        select count(*)
        from {{ bronze_relation }}
        where {{ filtered_condition }}
    ),
    deduped_count = (
        select count(*)
        from (
            select
                *,
                row_number() over (
                    partition by {{ dedupe_columns }}
                    order by {{ order_column }}
                ) rn
            from {{ bronze_relation }}
        )
        where rn > 1
    ),
    incremental_source_count = (
        select count(*)
        from {{ bronze_relation }}
        where {{ watermark_column }} > (
            select window_start
            from test.model_counts
            where run_id = '{{ invocation_id }}'
              and table_name = '{{ table_name }}'
        )
    ),
    incremental_target_count = (
        select count(*)
        from {{ silver_relation }}
        where {{ watermark_column }} > (
            select window_start
            from test.model_counts
            where run_id = '{{ invocation_id }}'
              and table_name = '{{ table_name }}'
        )
    ),
    run_time = current_timestamp
where run_id = '{{ invocation_id }}'
  and table_name = '{{ table_name }}'

{% endset %}

{% do run_query(sql) %}

{% endmacro %}