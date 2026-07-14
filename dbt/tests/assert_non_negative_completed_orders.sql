select
    order_id,
    amount,
    order_status
from {{ ref('fct_orders') }}
where order_status = 'completed'
  and amount < 0
