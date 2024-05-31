from cosmos.airflow.task_group import DbtTaskGroup
from cosmos.config import RenderConfig
from cosmos.constants import LoadMode
from airflow.decorators import dag
from dbt_redshift.cosmos_config import *
from dbt_redshift.utils import DAG_DEFAULT_ARGS

# import bash operator
from airflow.operators.bash import BashOperator
from cosmos.operators import DbtDocsS3Operator

AWS_CONN_ID = "aws_default"


# define the DAG
@dag(**DAG_DEFAULT_ARGS)
def sales_forecast() -> DbtTaskGroup:

    redshift_spectrum_external_sources = BashOperator(
        task_id="redshift_spectrum_external_sources",
        bash_command=". activate && cd $PATH_TO_DBT_PROJECT && . stage_external_sources.sh ",
        env={
            "PATH_TO_DBT_PROJECT": PATH_TO_DBT_PROJECT,
            "DBT_EXTERNAL_SOURCES_STM": DBT_EXTERNAL_SOURCES_STM,
            "ext_full_refresh": "false",
        },
        cwd=PATH_TO_VENV,
    )

    snapshot = DbtTaskGroup(
        group_id="snapshot",
        **DBT_PATHCONFIG,
        render_config=RenderConfig(
            load_method=LoadMode.DBT_LS,
            select=["path:snapshots"],
        ),
    )

    general_etl = DbtTaskGroup(
        group_id="general_etl",
        **DBT_PATHCONFIG,
        render_config=RenderConfig(
            load_method=LoadMode.DBT_LS,
            select=["path:models/sales_forecast"],
        ),
    )

    generate_dbt_docs_aws = DbtDocsS3Operator(
        task_id="generate_dbt_docs_aws",
        project_dir=PATH_TO_DBT_PROJECT,
        profile_config=DBT_PROFILE_CONFIG,
        # docs-specific arguments
        connection_id=AWS_CONN_ID,
        bucket_name="ht-general-purpose",
        dbt_cmd_flags=["--static"],
        folder_dir="from_airflow/redshift_demo/dbt_docs",
    )

    redshift_spectrum_external_sources >> snapshot >> general_etl >> generate_dbt_docs_aws


sales_forecast_dag = sales_forecast()
