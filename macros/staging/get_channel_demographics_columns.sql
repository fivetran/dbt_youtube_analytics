{% macro get_channel_demographics_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "age_group", "datatype": dbt.type_string()},
    {"name": "channel_id", "datatype": dbt.type_string()},
    {"name": "country_code", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "gender", "datatype": dbt.type_string()},
    {"name": "live_or_on_demand", "datatype": dbt.type_string()},
    {"name": "subscribed_status", "datatype": dbt.type_string()},
    {"name": "video_id", "datatype": dbt.type_string()},
    {"name": "views_percentage", "datatype": dbt.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}