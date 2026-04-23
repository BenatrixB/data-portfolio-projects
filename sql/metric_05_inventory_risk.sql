-- 05 metric inventory risk

WITH stock_h AS(
	SELECT
	    product_id,
	    SUM(stock_on_hand) as total_stock
	FROM raw.inventory
	GROUP BY product_id
),
sales AS(
SELECT
    product_id,
    product_name,
    SUM(units) as total_units_sold
FROM raw_marts.fct_sales
GROUP BY product_id, product_name
)
SELECT
	sales.product_id,
	sales.product_name,
	sales.total_units_sold,
	stock_h.total_stock,
	ROUND(stock_h.total_stock / (sales.total_units_sold / 21.0), 1) as months_of_stock
FROM 
	sales
JOIN stock_h
ON sales.product_id = stock_h.product_id
ORDER BY months_of_stock ASC;