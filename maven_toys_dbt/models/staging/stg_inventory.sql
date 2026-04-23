with source as (
    select * from {{ source('raw', 'inventory') }}
),

renamed as (
    select
        store_id,
        product_id,
        stock_on_hand
    from source
)

select * from renamed