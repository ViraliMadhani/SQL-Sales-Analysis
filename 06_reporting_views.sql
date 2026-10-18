-- Customer Report

CREATE VIEW gold.reports_customer AS
WITH base_query AS (
-- CTE 1 - retrives main columns from diff tables
SELECT s.order_number, s.product_key, s.order_date, s.sales_amount, s.quantity, 
	c.customer_key, c.customer_number, CONCAT(c.first_name,' ',c.last_name) as customer_name, 
	DATEDIFF(year, c.birthdate, GETDATE()) as age
FROM gold.sales s
LEFT JOIN gold.customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL 
)
, customer_aggregation as(
-- CTE 2 - summarising key metrices at customer level
SELECT customer_key, customer_number, customer_name, age, 
	COUNT(DISTINCT order_number) as total_orders,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	COUNT(DISTINCT product_key) as total_products,
	MAX(order_date) as last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
FROM base_query
GROUP BY customer_key, customer_number, customer_name, age
)

SELECT customer_key, customer_number, customer_name, age,
	CASE 
	 WHEN age<20 THEN 'Under 20'
	 WHEN age between 20 AND 29 THEN '20-29'
	 WHEN age between 30 AND 39 THEN '30-39'
	 WHEN age between 40 AND 49 THEN '40-49'
	 ELSE '50 & above'
	END age_group,
	CASE 
	 WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	 ELSE 'New'
	END customer_segment,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) as recency,
	   total_orders, total_sales, total_quantity, total_products,
	   lifespan,
	CASE WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders 
	END avg_order_value,
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan 
	END avg_monthly_spend
FROM customer_aggregation;



-- Product Report
SELECT * FROM gold.products;

WITH product_base_query AS(
SELECT s.order_number, s.customer_key, s.order_date, s.sales_amount, s.quantity, 
		p.product_key, p.product_name, p.category, p.subcategory, p.cost
FROM gold.sales s
LEFT JOIN gold.products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL 
), product_aggregation AS(
SELECT product_key, product_name, category, subcategory, cost,
    MAX(order_date) AS last_sale,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM product_base_query
GROUP BY product_key, product_name, category, subcategory, cost
)
SELECT product_key,	product_name, category, subcategory, cost, total_orders,
	total_sales, 
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	total_quantity,
	total_customers,
	lifespan,
	last_sale,
	DATEDIFF(MONTH, last_sale, GETDATE()) AS recency_in_months,
	CASE WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregation