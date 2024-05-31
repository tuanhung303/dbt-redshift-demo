{{
  config(
    pre_hook={
      "sql": get_sales_forecast_model(model_name = 'sales_forecast',
                            model_type = 'xgboost',
                            label = 'weekly_sales',
                            train_table_name = ref('int_sales_train'),
                            objectrive = 'mse',
                            auto = 'OFF' ),
      "transaction": False
    },
    group="Data scientists"
  )
}}
select
'CREATE MODEL {{ model_name }} FROM {{ train_table_name }} TARGET {{ label }} FUNCTION func_{{ model_name }} IAM_ROLE \'arn:aws:iam::621074188511:role/service-role/AmazonRedshift-CommandsAccessRole-20231219T223742\' AUTO {{ auto }} MODEL_TYPE {{ model_type }} OBJECTIVE \'mse\' PREPROCESSORS \'none\' HYPERPARAMETERS DEFAULT EXCEPT(NUM_ROUND \'100\') SETTINGS(S3_BUCKET \'ht-general-purpose\')' as model_definition
