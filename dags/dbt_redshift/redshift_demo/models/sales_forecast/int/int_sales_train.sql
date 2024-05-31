select
   {{ get_sales_forecast_inputs() }}
from {{ ref('int_sales_enhanced') }}
left join {{ ref('int_feature_store') }} using (store_dept_id, _week)
where extract(year from date_week) in ({{ var('train_years') }})
and store_id in ({{ var('train_stores') }})
and dept_id in ({{ var('train_depts') }})