{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key=['customer_id'],
        schema='silver',
        on_schema_change='sync_all_columns',
        pre_hook="{{ capture_incremental_watermark('stg_customers', this, 'updated_at', '1900-01-01 00:00:00') }}",
        post_hook="{{ log_counts('stg_customers', source('raw', 'raw_customers'), this, 'updated_at is not null', 'customer_id, customer_tier', 'updated_at', 'updated_at') }}"
    )
}}


{% if is_incremental() %}
    {% set incr_filter %}
        where updated_at >(
            select coalesce(max(updated_at), cast('1900-01-01 00:00:00' as timestamp))
            from {{ this }}
        )
    {% endset %}
{% else %}
    {% set incr_filter %}
       where updated_at >='2024-02-01T10:15:00.000+00:00'
    {% endset %}
{% endif %}

select
    cast(customer_id as integer) as customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    lower(customer_tier) as customer_tier,
    cast(signup_date as date) as signup_date,
    cast(updated_at as timestamp) as updated_at,
    current_timestamp as silver_ts
from {{ source('raw', 'raw_customers') }}
{{incr_filter}}