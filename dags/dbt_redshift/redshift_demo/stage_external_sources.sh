#!/bin/bash
. move_profiles.sh
if [ -z "$ext_full_refresh" ]; then
  ext_full_refresh=false
fi
dbt run-operation stage_external_sources --args "select: sales_forecast" --vars "ext_full_refresh: $ext_full_refresh" --profiles-dir /home/airflow/.dbt
