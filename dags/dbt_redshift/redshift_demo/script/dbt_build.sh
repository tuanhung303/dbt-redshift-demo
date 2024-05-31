#!/bin/bash
echo "dbt build!"
dbt build --vars '{"_REFRESH_LOOKBACK_RANGE": -4, "_REFRESH_LOOKBACK_RANGE_QUALIFY": -2}' --profiles-dir .dbt
