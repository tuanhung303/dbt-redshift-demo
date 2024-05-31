with cte as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2010-01-01' as date)",
        end_date="cast('2016-12-31' as date)")
    }}
),
week as (
    select distinct
        date_trunc('week', date_day) as date_week
    from cte
),
store_list as (
    select distinct
        store_id, dept_id, store_dept_id
    from {{ ref('stg_sales') }}
    where store_id in ({{ var('train_stores') }})
        and dept_id in ({{ var('train_depts') }})
),
prepare as (
    select
        date_week,
        extract(day from date_week) as _dom,
        extract(dow from date_week) as _dow,
        extract(week from date_week) as _week,
        extract(month from date_week) as _month,
        extract(year from date_week) as _year,
        store_id,
        dept_id,
        store_dept_id
    from week, store_list
)
select
    store_id,
    dept_id,
    date_week,
    _year,
    {{ get_sales_forecast_inputs(exclude_label=True, exclude_scaled=True) }}
from prepare