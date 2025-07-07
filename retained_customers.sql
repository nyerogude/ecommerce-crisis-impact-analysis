 WITH customer_details AS (
 SELECT DISTINCT o.customer_id,
 c.full_name,
 DATE_FORMAT(o.order_date,'%Y-%m') month
 FROM orders o
 JOIN customers c 
 ON o.customer_id = c.customer_id
 WHERE o.order_status = 'Completed'
 ),
 
 pre_crisis AS
 (
 SELECT DISTINCT customer_id,
 full_name
 FROM customer_details
 WHERE month IN ('2024-01','2024-02')
 ),
 
 post_crisis AS (
 SELECT DISTINCT customer_id,
 full_name
 FROM customer_details
 WHERE month IN ('2O24-05','2024-06', '2024-07')
 )
 
 SELECT customer_id,
 full_name
 FROM pre_crisis pc
 WHERE customer_id IN 
 (SELECT po.customer_id
 FROM post_crisis po)
 ORDER BY full_name;