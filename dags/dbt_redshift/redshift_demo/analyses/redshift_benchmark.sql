with feature as (

    SELECT
            {{ dbt_utils.generate_surrogate_key(['store', 'date']) }} surrogate_key,
            row_number() over (partition by store, date) = 1 as is_first,
            to_date(date, 'DD/MM/YYYY') date_week,
            *
    FROM {{ source('sales_forecast', 'ds2_feature_dataset') }}
),
sales as (
    SELECT
            {{ dbt_utils.generate_surrogate_key(['store', 'dept', 'date', 'weekly_sales']) }} surrogate_key,
            row_number() over (partition by store, dept, date order by weekly_sales desc) = 1 as is_first,
            to_date(date, 'DD/MM/YYYY') date_week,
            *
    FROM {{ source('sales_forecast', 'ds2_sales_dataset') }}
    LIMIT 5000
),
store as (
    SELECT
            {{ dbt_utils.generate_surrogate_key(['store', 'type', 'size']) }} surrogate_key,
            row_number() over (partition by store, type, size) = 1 as is_first,
            *
    FROM {{ source('sales_forecast', 'ds2_store_dataset') }}
)
select
    *
from sales
left join feature using (store, date_week)
left join store using (store)
