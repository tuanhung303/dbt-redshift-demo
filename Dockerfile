FROM apache/airflow:latest

# install libpq-dev python3-dev
USER root
RUN apt-get update && apt-get install -y libpq-dev python3-dev gcc
# enable gcc for airflow user
RUN echo "export CFLAGS=\"-I/usr/include/python3.6m\"" >> /home/airflow/.bashrc

USER airflow
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV PIP_USER=false
RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-redshift && deactivate
ENV PIP_USER=true
