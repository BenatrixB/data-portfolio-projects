-- Metric Best performing cities
WITH city_sales AS(
	SELECT
		store_city,
		COUNT(DISTINCT(store_id)) as store_count,
		SUM(revenue) as total_revenue,
		SUM(profit) as total_profit
	FROM
		raw_marts.fct_sales
	GROUP BY
		store_city
	ORDER BY
		total_revenue DESC
)
SELECT
	store_city,
	store_count,
	total_revenue,
	total_profit,
	ROUND(total_revenue/store_count, 2) as rev_per_store,
	ROUND(total_profit/store_count, 2) as prof_per_store
FROM
	city_sales
ORDER BY rev_per_store DESC;