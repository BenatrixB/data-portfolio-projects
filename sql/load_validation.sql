







-- SQL Load validation and testing
SELECT * fROM raw.products;
-- Products secure

SELECT * FROM raw.stores;
--

SELECT * FROM raw_staging.stg_products LIMIT 5;

SELECT * FROM raw_intermediate.int_sales_enriched LIMIT 5;

SELECT 
    product_category,
    SUM(revenue)    AS total_revenue,
    SUM(profit)     AS total_profit,
    ROUND(AVG(margin_pct), 2) AS avg_margin
FROM raw_marts.fct_sales
GROUP BY product_category
ORDER BY total_profit DESC;