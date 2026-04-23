with source as (
    select * from {{ source('raw', 'sales') }}
),

renamed as (
    select
        sale_id,
        sale_date,
        store_id,
        product_id,
        units
    from source
)

select * from renamed