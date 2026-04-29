SELECT
	*
FROM
	raw_marts.fct_sales;

SELECT
	sale_month,
	sale_year,
	yoy_revenue_growth
FROM
	raw_marts.fct_monthly_revenue
WHERE 
	sale_year = 2023
ORDER BY yoy_revenue_growth DESC;

SELECT
	*
FROM
	raw_marts.fct_store_performance
ORDER BY
	units_sold_per_day DESC;


SELECT
*
FROM
	raw_marts.fct_product_performance;

SELECT
	*
FROM
	raw_marts.fct_inventory_risk;