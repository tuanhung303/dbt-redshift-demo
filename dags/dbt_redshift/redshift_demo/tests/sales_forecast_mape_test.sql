-- depends_on: {{ ref('int_create_ml_model') }}

{{
    config(
        severity='WARN',
        warn_if='> 3',
        store_failures=True)
}}

with cte as (
    select
        fl.weekly_sales_forecast,
        fl.weekly_sales,
        fl.store_id,
        fl.date_week
    from {{ ref('mart_fact_sales') }} fl
    join {{ ref('int_sales_test') }} st using (store_dept_id, _week) -- get test data for evaluation only
    where not extract(year from date_week) in ({{ var('train_years') }})
)
-- get all the events with mape > 25%
select
    store_id,
    date_week,
    weekly_sales_forecast,
    weekly_sales,
    case when weekly_sales = 0 then 0 else abs(weekly_sales_forecast - weekly_sales) / weekly_sales end as mape
from cte
where case when weekly_sales = 0 then 0 else abs(weekly_sales_forecast - weekly_sales) / weekly_sales end > 0.25
order by mape desc
