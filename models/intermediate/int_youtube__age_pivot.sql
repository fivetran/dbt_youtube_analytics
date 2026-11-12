{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

{%- set age_values = (dbt_utils.get_column_values(table=ref('stg_youtube__channel_demographics'), column='age_group') or []) if execute and flags.WHICH in ('run', 'build') else [] -%}

with demographics as (
    
    select *
    from {{ ref('stg_youtube__channel_demographics') }}

), age_pivot as (
    
    select
        date_day,
        video_id,
        source_relation
        {% if age_values | length > 0 %}
        , {{ dbt_utils.pivot(column='age_group', values=age_values,then_value='views_percentage') }}
        {% endif %}
    from demographics

    {{ dbt_utils.group_by(n=3) }}
)

select *
from age_pivot