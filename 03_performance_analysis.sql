-- Performance Analysis (YoY)

WITH yearly_product_sales AS(
SELECT YEAR(s.order_date) as order_year, p.product_name, SUM(s.sales_amount) as current_sales
FROM gold.sales s
LEFT JOIN gold.products p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
)
SELECT order_year, product_name, current_sales, 
AVG(current_sales) OVER(PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
	ELSE 'No Difference'
END avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as previous_year_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as diff_previous_sales,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Sales Increased'
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Sales Decreased'
	ELSE 'No Change'
END previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year;

