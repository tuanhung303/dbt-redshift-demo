{% macro try_cast(_field) -%}
    CASE WHEN {{ _field }} NOT IN ('NA', 'N/A', 'NAN', 'NULL', 'NONE') THEN {{ _field }}::float ELSE NULL END {{ _field }}
{%- endmacro %}

{% macro generate_scaler(_field, _partition) -%}
    case when max({{ _field }}) over (partition by {{ _partition }}) - min({{ _field }}) over (partition by {{ _partition }}) = 0 then 0
    else
        ({{ _field }} - min({{ _field }}) over (partition by {{ _partition }})) / (max({{ _field }}) over (partition by {{ _partition }}) - min({{ _field }}) over (partition by {{ _partition }})) end {{ _field }}_scaled
{%- endmacro %}

{%- macro get_sales_forecast_inputs(exclude_label=False, exclude_scaled=False) %}
    {%- set label_field = 'weekly_sales' %}
    {%- set fields = ['store_dept_id', '_week'] %}
    {%- set scaled_field = ['cpi_avg_scaled', 'temperature_avg_scaled', 'fuel_price_avg_scaled', 'unemployment_avg_scaled', 'holiday_count_scaled', 'type_scaled'] %}
    {{- label_field + ',' if not exclude_label else '' }}
    {{- scaled_field | join(', ') + ',' if not exclude_scaled else '' }}
    {{- fields | join(', ') }}
{%- endmacro %}

{% macro is_function_exist(func_name) %}
    {% if execute %}
        {% set results = run_query("SELECT * FROM pg_proc WHERE proname = '" + func_name + "';") %}
        {% set results_2 = run_query("SELECT * FROM pg_proc WHERE proname = 'func_" + func_name + "';") %}
        {% set results_list = results.columns[0].values() %}
        {% set results_list_2 = results_2.columns[0].values() %}
        {% if results_list or results_list_2 %}
            {% do return(true) %}
        {% else %}
            {% do return(false) %}
        {% endif %}
    {% else %}
        false
    {% endif %}
{% endmacro %}



{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
