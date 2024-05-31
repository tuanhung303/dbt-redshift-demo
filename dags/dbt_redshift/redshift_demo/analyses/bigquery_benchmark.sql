with feature as (

    SELECT
            md5(cast(coalesce(cast(store as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(date as STRING), '_dbt_utils_surrogate_key_null_') as STRING)) surrogate_key,
            row_number() over (partition by store, date) = 1 as is_first,
            date date_week,
            *
    FROM source.ds2_feature_dataset
),
sales as (
    SELECT
            md5(cast(coalesce(cast(store as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dept as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(date as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(weekly_sales as STRING), '_dbt_utils_surrogate_key_null_') as STRING)) surrogate_key,
            row_number() over (partition by store, dept, date order by weekly_sales desc) = 1 as is_first,
            date date_week,
            *
    FROM source.ds2_sales_dataset
    LIMIT 5000
),
store_cte as (
    SELECT
            md5(cast(coalesce(cast(store as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(type as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(size as STRING), '_dbt_utils_surrogate_key_null_') as STRING)) surrogate_key,
            row_number() over (partition by store, type, size) = 1 as is_first,
            *
    FROM source.ds2_store_dataset
)
select
    *,
    1317 as benchmark_id
from sales
left join feature using (store, date_week)
left join store_cte using (store)