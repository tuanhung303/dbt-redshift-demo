WITH
    cte AS (
        SELECT
            -- create surrogate key
            {{ dbt_utils.generate_surrogate_key(['store', 'dept', 'date']) }} surrogate_key,
            -- calculate store_dept_id by concatenating store_id and dept_id
            dept * 1000000 + store store_dept_id,
            -- get week of the year
            extract(week from date_week) _week,
            store::int store_id,
            dept::int dept_id,
            -- actually the date granularity is weekly
            date_week,
            {{ try_cast('weekly_sales') }},
            case
                when isholiday = 'TRUE' then 1
                else 0
            end isholiday
        FROM {{ ref('sales') }}
        WHERE dbt_valid_to IS NULL
        
    )

SELECT * FROM cte
