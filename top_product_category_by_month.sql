-- top product category by month
USE ecommerce_crisis;

WITH product_categories AS (
    SELECT 
        DATE_FORMAT(o.order_date,'%Y-%m') AS month,
        SUM(oi.quantity * p.price) AS sales,
        p.category AS product_category
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    JOIN payments py    ON o.order_id = py.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY month, product_category
    
),
ranked_categories AS (
    SELECT
        month,
        sales,
        product_category,
        DENSE_RANK() OVER (
            PARTITION BY month 
            ORDER BY sales DESC
        ) AS category_rank
    FROM product_categories
)
SELECT *
FROM ranked_categories
WHERE category_rank = 1
ORDER BY month;