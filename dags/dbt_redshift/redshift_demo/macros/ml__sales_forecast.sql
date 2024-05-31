
{% macro get_sales_forecast_model(model_name, model_type, label, train_table_name, objectrive, auto) -%}
    {# temporarily setup this to avoid bugs #}
    {% if execute and not is_function_exist(model_name) %}
        {{ get_sales_forecast_stm(model_name, model_type, label, train_table_name, objectrive, auto) }}
    {% endif %}
{%- endmacro %}

{% macro get_drop_model_stm(model_name) -%}
    {% set drop_model_stm %}
        DROP MODEL IF EXISTS {{ model_name }};
    {% endset %}
    {% do run_query(drop_model_stm) %}
{%- endmacro %}

{% macro get_sales_forecast_stm(model_name, model_type, label, train_table_name, objectrive, auto) -%}
    {% set get_sales_forecast_stm %}
        CREATE MODEL {{ model_name }}
        FROM {{ train_table_name }}
        TARGET {{ label }} 
        FUNCTION func_{{ model_name }}
        IAM_ROLE 'arn:aws:iam::621074188511:role/service-role/AmazonRedshift-CommandsAccessRole-20231219T223742' 
        AUTO {{ auto }}
        MODEL_TYPE {{ model_type }}
        OBJECTIVE 'mse' 
        PREPROCESSORS 'none' 
        HYPERPARAMETERS DEFAULT EXCEPT(NUM_ROUND '100') 
        SETTINGS(S3_BUCKET 'ht-general-purpose')
    {% endset %}
    {% do run_query(get_sales_forecast_stm) %}
{%- endmacro %}
