{{
    config(
        materialized='ephemeral',
    )
}}
with
features_cte as (
    select * from {{ ref('stg_features' )}}
),
stores_cte as (
    select * from {{ ref('stg_stores' )}}
),
sales_cte as (
    select * from {{ ref('stg_sales' )}}
),
sales_enhanced as (
    select
        *
    from
        sales_cte
        join stores_cte using (store_id)
        left join features_cte using (store_id, date_week)
)
select * from sales_enhanced se

