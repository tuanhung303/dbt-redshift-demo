{{
    config(
        materialized='incremental',
        unique_key='surrogate_key',
        incremental_strategy='merge',
        on_schema_change='append_new_columns'
    )
}}
with
int_sales_enhanced_prepare as (
    select * from {{ ref('int_sales_enhanced_prepare' )}}
)
select
    *
from int_sales_enhanced_prepare se
-- incremental load, but with -7 padding for late arriving data
{% if is_incremental() %}
    where se.date_week >= (select dateadd(day, -7, max(t.date_week)) from {{ this }} t)
{% endif %}
