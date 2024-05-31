from cosmos.config import ProfileConfig, ProjectConfig
from pathlib import Path
AIRFLOW_HOME = '/opt/airflow'
PATH_TO_DBT_PROJECT = f'{AIRFLOW_HOME}/dags/dbt_redshift/redshift_demo'
PATH_TO_VENV = f'{AIRFLOW_HOME}/dbt_venv/bin'
DBT_EXTERNAL_SOURCES_STM = 'dbt run-operation stage_external_sources --args "select: sales_forecast" --profiles-dir /home/airflow/.dbt'

DBT_PROFILE_CONFIG = ProfileConfig(
    profile_name='redshift_demo',
    target_name='dev',
    profiles_yml_filepath=Path(f'{PATH_TO_DBT_PROJECT}/.dbt/profiles.yml')
)

DBT_PROJECT_CONFIG = ProjectConfig(
    dbt_project_path=Path(PATH_TO_DBT_PROJECT),
)

DBT_PATHCONFIG = {
    'project_config': DBT_PROJECT_CONFIG,
    'profile_config': DBT_PROFILE_CONFIG,
}
