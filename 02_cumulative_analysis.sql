-- Cumulative Analysis

-- 1. Running sales totals
SELECT order_date, total_sales, SUM(total_sales) OVER(ORDER BY order_date) as running_total_sales
FROM(
	SELECT DATETRUNC(month, order_date) as order_date, SUM(sales_amount) as total_sales
	FROM gold.sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
	) t

-- 2. Average-price analysis
SELECT order_date, total_sales, 
	SUM(total_sales) OVER(ORDER BY order_date) as running_total_sales, 
	AVG(avg_price) OVER(ORDER BY order_date) as moving_avg_price
FROM(
	SELECT DATETRUNC(month, order_date) as order_date, SUM(sales_amount) as total_sales,
	AVG(price) as avg_price
	FROM gold.sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
	) t