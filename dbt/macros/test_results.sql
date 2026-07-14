{% macro ensure_test_results_table() %}

{% set create_test_results_sql %}
create table if not exists test.custom_test_results (
    run_id string,
    test_name string,
    bronze_count bigint,
    silver_count bigint,
    count_difference bigint,
    status string,
    recorded_at timestamp
)
{% endset %}

{% do run_query(create_test_results_sql) %}

{% endmacro %}

{% macro log_test_counts(test_name, bronze_relation, silver_relation) %}

{% do ensure_test_results_table() %}

{% set delete_sql %}
delete from test.custom_test_results
where run_id = '{{ invocation_id }}'
  and test_name = '{{ test_name }}'
{% endset %}

{% set insert_sql %}
insert into test.custom_test_results (
    run_id,
    test_name,
    bronze_count,
    silver_count,
    count_difference,
    status,
    recorded_at
)
with bronze as (
    select count(*) as bronze_count
    from {{ bronze_relation }}
),
silver as (
    select count(*) as silver_count
    from {{ silver_relation }}
)
select
    '{{ invocation_id }}' as run_id,
    '{{ test_name }}' as test_name,
    bronze.bronze_count,
    silver.silver_count,
    bronze.bronze_count - silver.silver_count as count_difference,
    case
        when bronze.bronze_count = silver.silver_count then 'PASS'
        else 'FAIL'
    end as status,
    current_timestamp as recorded_at
from bronze
cross join silver
{% endset %}

{% do run_query(delete_sql) %}
{% do run_query(insert_sql) %}

{% endmacro %}