-- Metric 06 YoY growth
SELECT
	RANK() OVER( ORDER BY yoy_revenue_growth DESC) as rev_growth_rank,
	RANK() OVER( ORDER BY yoy_profit_growth DESC) as prof_growth_rank,
	*
FROM
	raw_marts.fct_monthly_revenue
WHERE 
	sale_year = 2023
ORDER BY
	yoy_revenue_growth DESC;

