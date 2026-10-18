-- Proportional Analysis

-- 1. Category contributions to total sales
WITH category_sales AS (
SELECT category, SUM(sales_amount) as total_sales
FROM gold.sales s
LEFT JOIN gold.products p
ON s.product_key = p.product_key
GROUP BY category
)
SELECT category, total_sales, 
SUM(total_sales) OVER() as overall_sales, 
CONCAT(ROUND(( CAST(total_sales AS FLOAT) / SUM(total_sales) OVER())*100, 2),'%') as percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

-- 2. Country contributions to total sales.
WITH country_sales AS (
SELECT country, SUM(sales_amount) as total_sales
FROM gold.sales s
LEFT JOIN gold.customers c
ON s.customer_key = c.customer_key
GROUP BY country
)
SELECT country, total_sales, 
SUM(total_sales) OVER() as overall_sales, 
CONCAT(ROUND(( CAST(total_sales AS FLOAT) / SUM(total_sales) OVER())*100, 2),'%') as percentage_of_total
FROM country_sales
ORDER BY total_sales DESC;
