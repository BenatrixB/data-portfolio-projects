WITH sales_df AS(
    SELECT
        product_id,
        product_name,
        product_category,
        product_cost,
        SUM(units) as total_units_sold
    FROM
        {{ref('fct_sales')}}
    GROUP BY
        product_id,
        product_name,
        product_category,
        product_cost
),
inventory_df AS (
    SELECT 
        product_id,
        SUM(stock_on_hand) as total_stock
    FROM
        {{ref('stg_inventory')}}
    GROUP BY
        product_id
),
join_df AS(
    SELECT
    sales_df.product_id,
    sales_df.product_name,
    sales_df.product_category,
    sales_df.product_cost,
    sales_df.total_units_sold,
    inventory_df.total_stock
    FROM
        sales_df
    JOIN
        inventory_df
    ON 
        sales_df.product_id = inventory_df.product_id
),
stock_risk_df AS(
    SELECT
        *,
        ROUND(total_stock / (total_units_sold / 21), 2) as months_of_stock,
        (total_stock * product_cost) as inventory_value
    FROM
        join_df
),
risk_flag_df AS(
    SELECT
        *,
        CASE 
            WHEN months_of_stock < 0.5 THEN  'CRITICAL'
            WHEN months_of_stock < 1.0 THEN 'LOW'
            ELSE  'OK'
        END as risk_flag
    FROM
        stock_risk_df
)
SELECT
    *
FROM
    risk_flag_df

