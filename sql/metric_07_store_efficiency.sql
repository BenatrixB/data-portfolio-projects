-- Metric 07 store efficiency 
SELECT
	*,
	RANK() OVER (ORDER BY revenue_per_day DESC) as rev_per_day_rank,
	RANK() OVER (ORDER BY profit_per_day DESC) as prof_per_day_rank
FROM 
	raw_marts.fct_store_performance;