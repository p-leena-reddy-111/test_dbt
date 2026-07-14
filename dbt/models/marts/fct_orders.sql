{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    order_id,
    customer_id,
    order_date,
    order_status,
    amount,
    updated_at
from {{ ref('stg_orders') }}
{% if is_incremental() %}
where updated_at >= (
    select coalesce(max(updated_at), cast('1900-01-01 00:00:00' as timestamp))
    from {{ this }}
)
{% endif %}
