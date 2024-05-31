from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging

logging.basicConfig(level=logging.INFO)

def get_odbc_drivers():
    import pyodbc
    logging.warning(pyodbc.drivers())

with DAG(
    'pyodbc_check',
    start_date=datetime(2022, 1, 1),
    schedule_interval='@once',
    catchup=False
) as dag:
    hello_task = PythonOperator(
        task_id='pyodbc_check_task',
        python_callable=get_odbc_drivers
    )
