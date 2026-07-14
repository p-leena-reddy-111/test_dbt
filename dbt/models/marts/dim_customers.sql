select
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    customer_tier,
    signup_date,
    updated_at
from {{ ref('stg_customers') }}
