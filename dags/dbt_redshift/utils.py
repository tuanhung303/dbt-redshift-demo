from datetime import timedelta
from datetime import datetime

args = {
    'owner': 'airflow',
    'retries': 3,
    'retry_delay': timedelta(seconds=3),
    'tags': ['sales_forecast']
}

DAG_DEFAULT_ARGS = {
    'default_args': args,
    'catchup': False,
    'max_active_runs': 1,
    'schedule_interval': None,
    'start_date': datetime(2023, 12, 12),
}