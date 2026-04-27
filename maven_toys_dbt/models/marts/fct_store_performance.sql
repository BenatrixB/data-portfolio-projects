WITH primary_df AS(
    SELECT 
        store_id,
        store_name,
        store_location,
        store_city,
        SUM(revenue) as total_revenue,
        SUM(profit) as total_profit,
        SUM(units) as total_units,
        DATE '2023-10-01' - MIN(store_open_date) as days_open
    FROM
        {{ref('fct_sales')}}
    GROUP BY
        store_id, 
        store_name,
        store_location,
        store_city
),
rev_per_day_df AS (
    SELECT
        *,
        ROUND(total_revenue / days_open, 2) as revenue_per_day,
        ROUND(total_profit / days_open, 2) as profit_per_day,
        ROUND(total_units / days_open, 2) as units_sold_per_day
    FROM
    primary_df
)
SELECT
    *
FROM
    rev_per_day_df