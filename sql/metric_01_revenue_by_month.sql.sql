-- Revenue and profits by Month
SELECT
	DATE_TRUNC('month', sale_date) AS month,
	SUM(revenue) as revenue,
	SUM(profit) as profit
FROM 
	raw_marts.fct_sales
GROUP BY 
	DATE_TRUNC('month', sale_date)
ORDER BY month;

