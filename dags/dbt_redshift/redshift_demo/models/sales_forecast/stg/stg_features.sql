WITH
    cte AS (
        SELECT
            store::int store_id,
            -- cast string 06/01/2012 to date
            date_week,
            -- use try cast due to some issues with alpha characters
            {{ try_cast('cpi') }},
            {{ try_cast('unemployment') }},
            {{ try_cast('temperature') }},
            {{ try_cast('fuel_price') }},
            {{ try_cast('markdown1') }},
            {{ try_cast('markdown2') }},
            {{ try_cast('markdown3') }},
            {{ try_cast('markdown4') }},
            {{ try_cast('markdown5') }}
        FROM {{ ref('features') }}
        WHERE dbt_valid_to IS NULL
    )

SELECT * FROM cte
