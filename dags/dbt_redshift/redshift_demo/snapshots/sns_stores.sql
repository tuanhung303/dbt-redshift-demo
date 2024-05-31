{% snapshot stores %}

{{
    config(
      target_schema='snapshots',
      unique_key='store',
      strategy='check',
      check_cols=['surrogate_key'],
      invalidate_hard_deletes=True,
    )
}}

WITH
    cte AS (
        SELECT
            {{ dbt_utils.generate_surrogate_key(['store', 'type', 'size']) }} surrogate_key,
            row_number() over (partition by store, type order by size desc) = 1 as is_first,
            *
        FROM {{ source('sales_forecast', 'ds2_store_dataset') }}
    )

SELECT
    *
FROM cte
WHERE is_first

{% endsnapshot %}