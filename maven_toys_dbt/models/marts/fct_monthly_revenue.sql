WITH monthly_agg_df AS (
    SELECT
        sale_month,
        sale_year,
        SUM(revenue) as total_revenue,
        SUM(profit) as total_profit,
        SUM(units) as total_units,
        ROUND(AVG(margin_pct), 2) as avg_margin
    FROM
        {{ ref('fct_sales')}}
    GROUP BY
        sale_month,
        sale_year
),
yoy_df AS (
    SELECT
        *,
        LAG(total_revenue, 12) OVER (ORDER BY sale_month) as prev_year_revenue,
        LAG(total_profit, 12) OVER (ORDER BY sale_month) as prev_year_profit
    FROM
        monthly_agg_df
),
final_df AS (
    SELECT
        *,
        CASE 
            WHEN prev_year_revenue IS NOT NULL 
            THEN ROUND((total_revenue - prev_year_revenue) / prev_year_revenue * 100, 2)   
        END as yoy_revenue_growth,
        CASE 
            WHEN prev_year_profit IS NOT NULL 
            THEN ROUND((total_profit - prev_year_profit) / prev_year_profit * 100, 2)   
        END as yoy_profit_growth
    FROM
    yoy_df
)
SELECT
    *
FROM
    final_df