WITH primary_df AS(
    SELECT 
        product_id,
        product_name,
        product_category,
        SUM(revenue) as total_revenue,
        SUM(profit) as total_profit,
        SUM(units) as total_units,
        ROUND((AVG(margin_pct)), 2) as avg_margin
    FROM
        {{ref('fct_sales')}}
    GROUP BY
        product_id,
        product_name,
        product_category
),
rank_df AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank,
        RANK() OVER (ORDER BY total_profit DESC) as profit_rank,
        RANK() OVER (ORDER BY avg_margin DESC) as avg_margin_rank
    FROM
        primary_df
)
SELECT
    *
FROM
    rank_df