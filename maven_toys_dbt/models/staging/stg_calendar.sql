with source as (
    select * from {{ source('raw', 'calendar') }}
),

renamed as (
    select
        cal_date
    from source
)

select * from renamed