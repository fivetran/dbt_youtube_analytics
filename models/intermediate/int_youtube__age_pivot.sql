{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with demographics as (
    
    select *
    from {{ ref('stg_youtube__channel_demographics') }}

), age_pivot as (
    
    select
        date_day,
        video_id,
        source_relation,
        {{ dbt_utils.pivot(column='age_group', values=dbt_utils.get_column_values(ref('stg_youtube__channel_demographics'), 'age_group'),then_value='views_percentage') }}
    from demographics

    {{ dbt_utils.group_by(n=3) }}
)

select *
from age_pivot