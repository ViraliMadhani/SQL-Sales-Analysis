-- Data Segmentation

-- 1. Customer segments 
WITH product_segments AS (
SELECT product_key, product_name, cost, 
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END cost_range
FROM gold.products
)
SELECT cost_range, COUNT(product_key) as total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

-- 2. Product cost bands
WITH customer_spending AS(
SELECT c.customer_key, 
SUM(s.sales_amount) as total_spending, 
MIN(order_date) as first_order, MAX(order_date) as last_order,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
FROM gold.sales s
LEFT JOIN gold.customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT customer_segment, COUNT(customer_key) as total_customers
FROM
(
SELECT customer_key,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	 ELSE 'New'
	END customer_segment
FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
GO