
-- Metric query Store performance by location
WITH sales as(
	SELECT
		store_location,
		COUNT(DISTINCT(store_id)) as store_count,
		SUM(revenue) as total_revenue,
		SUM(profit) as total_profit
	FROM
		raw_marts.fct_sales
	GROUP BY 
		store_location
	ORDER BY 
		total_revenue DESC
)
SELECT
	store_location,
	store_count,
	total_revenue,
	total_profit,
	ROUND((total_revenue/store_count), 2) as avg_rev_per_store,
	ROUND((total_profit/store_count), 2) as avg_prof_per_store
FROM
	sales
ORDER BY 
	avg_rev_per_store DESC;
-- We can clearly see that Airport location turns the greatest revenue and profit. And we could open more stores in Airports.
-- Somethings to add. We would need some more info for business decision gathering. 
-- Like what is the cost of operating a store in Airport location. Its like finding the ration between revenue generation and operating cost.
-- If that ration is still greater in Airport location then that would mean we should go for that decision.