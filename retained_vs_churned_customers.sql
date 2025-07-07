WITH customer_orders AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        c.customer_id,
        c.full_name
    FROM orders o 
    JOIN customers c ON o.customer_id = c.customer_id
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
labeled_customers AS (
    SELECT pc.customer_id,
    CASE
    WHEN pc.customer_id IN (SELECT customer_id FROM post_crisis_customers) THEN 'RETAINED'
	ELSE 'CHURNED'
    END AS STATUS
    FROM pre_crisis_customers pc
)
SELECT status,
COUNT(lc.customer_id) count 
FROM labeled_customers lc
GROUP BY status;