SELECT
    cal_date AS date_day
FROM {{ source('raw', 'calendar') }}