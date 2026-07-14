{% snapshot customer_tiers_snapshot %}

{{
    config(
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    customer_id,
    customer_tier,
    updated_at
from {{ ref('stg_customers') }}

{% endsnapshot %}
