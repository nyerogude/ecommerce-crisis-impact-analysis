-- revenue percent change by month
WITH monthly_revenue AS (

select DATE_FORMAT(o.order_date,'%Y-%m') month,
SUM(p.amount) revenue
FROM orders o 
JOIN payments p 
ON o.order_id = p.order_id
WHERE o.order_status = 'Completed'
GROUP BY month
),
lag_revenue AS (
SELECT 
month,
revenue,
LAG(revenue) OVER(ORDER BY month) prev_month_rev
FROM monthly_revenue
)

SELECT *,
ROUND(((revenue-prev_month_rev)/prev_month_rev)*100,1) perct_change
FROM lag_revenue;