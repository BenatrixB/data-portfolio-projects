from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'benas',
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='maven_toys_pipeline',
    default_args=default_args,
    description='Maven Toys end-to-end data pipeline',
    schedule_interval='@daily',
    start_date=datetime(2026, 1, 1),
    catchup=False
) as dag:

    task_loader = DockerOperator(
        task_id='run_loader',
        image='maven_toys_analytics-loader',
        container_name='airflow_loader',
        auto_remove=True,
        docker_url='unix://var/run/docker.sock',
        network_mode='maven_toys_analytics_default'
    )

    task_dbt_run = DockerOperator(
        task_id='run_dbt_run',
        image='maven_toys_analytics-dbt',
        container_name='airflow_dbt_run',
        auto_remove=True,
        docker_url='unix://var/run/docker.sock',
        network_mode='maven_toys_analytics_default',
        command='dbt run'
    )

    task_dbt_test = DockerOperator(
        task_id='run_dbt_test',
        image='maven_toys_analytics-dbt',
        container_name='airflow_dbt_test',
        auto_remove=True,
        docker_url='unix://var/run/docker.sock',
        network_mode='maven_toys_analytics_default',
        command='dbt test'
    )

    task_loader >> task_dbt_run >> task_dbt_test