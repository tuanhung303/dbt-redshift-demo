{{
    config(materialized='table')
}}
with
feature_prepare_cpi as (
select
    store_dept_id,
    _week,
    type,
    -- measure average cpi, temperature, size and count of holidays
    avg(size) size_avg,
    avg(cpi) cpi_avg,
    avg(temperature) temperature_avg,
    avg(fuel_price) fuel_price_avg,
    sum(isholiday)::float holiday_count,
    avg(unemployment) unemployment_avg
from {{ ref('int_sales_enhanced_prepare') }}
group by 1, 2, 3),
-- scale the avg. cpi, temperature, size and count of holidays
feature_prepare_scaled as (
select
    store_dept_id,
    _week,
    size_avg,
    {{ generate_scaler('type', '1') }},
    -- scale the avg. cpi, temperature, size and count of holidays
    -- handle divide by zero
    {{ generate_scaler('cpi_avg', '1') }},
    {{ generate_scaler('temperature_avg', '1') }},
    {{ generate_scaler('fuel_price_avg', '1') }},
    {{ generate_scaler('holiday_count', '1') }},
    {{ generate_scaler('unemployment_avg', '1') }}
from
    feature_prepare_cpi
)
select * from feature_prepare_scaled
