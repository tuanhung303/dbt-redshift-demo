from datetime import datetime
from airflow.models import DAG
from airflow.providers.amazon.aws.transfers.local_to_s3 import LocalFilesystemToS3Operator
import os, sys, logging

cwd = os.path.dirname(os.path.realpath(__file__))
sub_folder = "dataset"
aws_conn_id = "aws_default"
dest_bucket = "ht-general-purpose"


def local_to_s3_interface(filename, dest_key, cwd=cwd):
    file_path = os.path.join(cwd, sub_folder, filename)
    logging.info(f"file_path: {file_path}")
    return LocalFilesystemToS3Operator(
        task_id=filename,
        filename=file_path,
        dest_key=dest_key,
        dest_bucket=dest_bucket,
        replace=True,
        aws_conn_id=aws_conn_id,
    )


with DAG(
    dag_id=f"copy_{sub_folder}_to_s3",
    schedule=None,
    start_date=datetime(2023, 1, 1),
    max_active_runs=1,
    template_searchpath=f"/usr/local/airflow/dags/transfers_to_s3/{sub_folder}",
    catchup=False,
) as dag:
    # [START howto_operator_local_to_s3_task]
    ds2_feature_dataset_to_s3 = local_to_s3_interface(
        filename="ds2_feature_dataset.csv",
        dest_key=f"{sub_folder}/feature/ds2_feature_dataset.csv",
    )
    # ds2_sales_dataset
    ds2_sales_dataset_to_s3 = local_to_s3_interface(
        filename="ds2_sales_dataset.csv",
        dest_key=f"{sub_folder}/sales/ds2_sales_dataset.csv",
    )

    # ds2_store_dataset
    ds2_store_dataset_to_s3 = local_to_s3_interface(
        filename="ds2_store_dataset.csv",
        dest_key=f"{sub_folder}/store/ds2_store_dataset.csv",
    )
