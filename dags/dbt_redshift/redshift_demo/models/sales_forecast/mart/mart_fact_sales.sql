with sales as (
   select
      *,
      extract(year from date_week) as _year

   from {{ ref('int_sales_enhanced') }}
)
select
   store_id,
   dept_id,
   coalesce(sales.date_week, ds.date_week) date_week,
   sales.cpi,
   sales.temperature,
   sales.fuel_price,
   sales.unemployment,
   sales.isholiday,
   sales.type,
   sales.size,
   sales.weekly_sales,
   func_sales_forecast({{ get_sales_forecast_inputs(exclude_label=True) }}) as weekly_sales_forecast,
   sales._week,
   sales.store_dept_id
from sales
full join {{ ref('stg_date_spine') }} ds using (_year, store_id, dept_id, {{ get_sales_forecast_inputs(exclude_label=true, exclude_scaled=true) }})
left join {{ ref('int_feature_store') }} using (store_dept_id, _week)