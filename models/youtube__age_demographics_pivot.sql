{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with age_pivot as (

    select *
    from {{ ref('int_youtube__age_pivot') }}

), video_metadata as (

    select *
    from {{ ref('youtube__video_metadata') }}

{% set age_columns = dbt_utils.get_column_values(source('youtube_analytics','channel_demographics'), 'age_group') %}
), final as (

    select
        age_pivot.date_day,
        age_pivot.video_id,
        video_metadata.video_title,
        video_metadata.video_description,
        video_metadata.video_published_at,
        video_metadata.channel_title,
        video_metadata.default_thumbnail_url
        
        {% for col in age_columns -%}
            , age_pivot.{% if target.type in ('postgres, redshift') %}"{{ col }}"{% else %}{{ col }}{% endif %} as {{ col }}_view_percentage
        {% endfor -%}
    from age_pivot

    left join video_metadata
        on video_metadata.video_id = age_pivot.video_id
)

select *
from final