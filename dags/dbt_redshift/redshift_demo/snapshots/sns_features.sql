{% snapshot features %}

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
            {{ dbt_utils.generate_surrogate_key(['store', 'date']) }} surrogate_key,
            row_number() over (partition by store, date) = 1 as is_first,
            to_date(date, 'DD/MM/YYYY') date_week,
            *
        FROM {{ source('sales_forecast', 'ds2_feature_dataset') }}
    )

SELECT
    *
FROM cte
WHERE is_first

{% endsnapshot %}