WITH fact_sales as(
    SELECT
    *
    FROM
        {{ref('int_sales_enriched')}}
),
rev_cost as(
    SELECT
        *,
        units * product_price as revenue,
        units * product_cost as cost
    FROM
    fact_sales
),
profit as(
    SELECT
        *,
        revenue - cost as profit
    FROM
        rev_cost
),
mrg_pct as(
    SELECT
        *,
        ROUND((profit/revenue)*100, 2) as margin_pct,
        DATE_TRUNC('month', sale_date) as sale_month,
        EXTRACT(year FROM sale_date) as sale_year,
        EXTRACT(month FROM sale_date) as sale_month_num,
        ROUND(revenue / units, 2) as revenue_per_unit
    FROM
        profit
)
SELECT
*
FROM
    mrg_pct