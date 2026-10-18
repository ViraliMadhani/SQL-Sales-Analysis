-- Trend Analysis

SELECT YEAR(order_date) as order_year,
MONTH(order_date) as order_month,
SUM(sales_amount) as total_month,
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);