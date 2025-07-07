
WITH customer_orders AS (
    SELECT 
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month
    FROM orders o
    WHERE o.order_status = 'Completed'
),
pre_crisis_customers AS (
    SELECT DISTINCT customer_id
    FROM customer_orders
    WHERE month IN ('2024-01', '2024-02')
),
post_crisis_customers AS (
    SELECT DISTINCT customer_id
    FROM customer_orders
    WHERE month IN ('2024-05', '2024-06', '2024-07')
),
retained_customers AS (
    SELECT pc.customer_id
    FROM pre_crisis_customers pc
    INNER JOIN post_crisis_customers po ON pc.customer_id = po.customer_id
)
SELECT 
    ROUND(
        (SELECT COUNT(*) FROM retained_customers) * 100.0 / 
        (SELECT COUNT(*) FROM pre_crisis_customers), 1
    ) AS retention_rate_percent;