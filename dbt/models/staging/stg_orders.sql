select
    cast(order_id as integer) as order_id,
    cast(customer_id as integer) as customer_id,
    cast(order_date as date) as order_date,
    lower(order_status) as order_status,
    cast(amount as decimal(18, 2)) as amount,
    cast(updated_at as timestamp) as updated_at
from {{ source('raw', 'raw_orders') }}
