from airflow import DAG
from airflow.models import Variable
from airflow.operators.python import PythonOperator
import datetime, subprocess, logging

def run_cmd():
    cmd = Variable.get("remote_cmd")
    proc = subprocess.Popen(
        cmd,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
    )

    logging.error(f"--------- cmd output start ----------")
    while True:
        line = proc.stdout.readline()
        if not line:
            break
        logging.error(line.rstrip())
    logging.error(f"--------- cmd output end ----------")

with DAG(
    dag_id="remote_cmd",
    schedule_interval=None,
    start_date=datetime.datetime(2024, 1, 1),
    catchup=False,
    tags=["OPS_TEAM", "DATUM"],
):
    PythonOperator(
        task_id="template_type",
        python_callable=run_cmd,
    )
