WITH
    cte AS (
        SELECT
            store::int store_id,
            case
                when type = 'A' then 1
                when type = 'B' then 2
                when type = 'C' then 3
                else -1
            end as type,
            size::int size
        FROM {{ ref('stores') }}
        WHERE dbt_valid_to IS NULL
    )

SELECT * FROM cte
WHERE store_id in ({{ var('train_stores') }})
