
-- Metric query Top 10 products
SELECT
	product_name,
	SUM(profit) as profit
FROM
	raw_marts.fct_sales
GROUP BY product_name
ORDER BY profit DESC
LIMIT 10;
