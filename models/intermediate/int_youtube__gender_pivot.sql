{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

{%- set gender_values = (dbt_utils.get_column_values(table=ref('stg_youtube__channel_demographics'), column='gender') or []) if execute and flags.WHICH in ('run', 'build') else [] -%}

with demographics as (
    
    select *
    from {{ ref('stg_youtube__channel_demographics') }}

), gender_pivot as (
    
    select
        date_day,
        video_id,
        source_relation
        {% if gender_values | length > 0 %}
        , {{ dbt_utils.pivot(column='gender', values=gender_values,then_value='views_percentage') }}
        {% endif %}
    from demographics

    {{ dbt_utils.group_by(n=3) }}
)

select *
from gender_pivot