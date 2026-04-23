with source as (
    select * from {{ source('raw', 'products') }}
),

renamed as (
    select
        product_id,
        product_name,
        product_category,
        product_cost,
        product_price
    from source
)

select * from renamed