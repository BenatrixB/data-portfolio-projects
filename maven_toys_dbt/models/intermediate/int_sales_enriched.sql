WITH sales as(
    SELECT 
        * 
    FROM 
        {{ref('stg_sales')}}
),
products as (
    SELECT 
        * 
    FROM
        {{ref('stg_products')}}
),
stores as (
    SELECT
        *
    FROM {{ref('stg_stores')}}
),
sales_joined as (
    SELECT 
    sales.product_id,
    sales.store_id,
    sales.sale_id,
    sales.sale_date,
    sales.units,
    products.product_cost,
    products.product_price,
    products.product_name,
    products.product_category,
    stores.store_name,
    stores.store_city,
    stores.store_location,
    stores.store_open_date
    FROM 
        sales
    JOIN products
    ON sales.product_id = products.product_id
    JOIN stores
    ON sales.store_id = stores.store_id
)
SELECT 
 *
FROM 
    sales_joined


-- JOIN SALES -> PRODUCTS
-- JOIN SALES/PRODUCTS -> STORES