select
    customer_id,
    full_name,
    customer_tier,
    count(order_id) as total_orders,
    sum(case when order_status = 'completed' then amount else 0 end) as completed_revenue,
    max(order_date) as most_recent_order_date
from (
    select
        c.customer_id,
        c.full_name,
        c.customer_tier,
        o.order_id,
        o.order_status,
        o.amount,
        o.order_date
    from {{ ref('dim_customers') }} as c
    left join {{ ref('fct_orders') }} as o
        on c.customer_id = o.customer_id
) as joined_data
group by 1, 2, 3
