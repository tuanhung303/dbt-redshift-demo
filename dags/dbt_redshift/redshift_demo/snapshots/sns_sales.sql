{% snapshot sales %}

{{
    config(
      target_schema='snapshots',
      unique_key='surrogate_key',
      strategy='timestamp',
      updated_at='date_week',
      invalidate_hard_deletes=True,
    )
}}

WITH
    cte AS (
        SELECT
            {{ dbt_utils.generate_surrogate_key(['store', 'dept', 'date', 'weekly_sales']) }} surrogate_key,
            row_number() over (partition by store, dept, date order by weekly_sales desc) = 1 as is_first,
            to_date(date, 'DD/MM/YYYY') date_week,
            *
        FROM {{ source('sales_forecast', 'ds2_sales_dataset') }}
    )

SELECT
    *
FROM cte
WHERE is_first

{% endsnapshot %}