{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with demographics as (
    
    select *
    from {{ var('channel_demographics') }}

{% if var('youtube__using_video_metadata', false) %}

),  video_metadata as (
    
    select *
    from {{ ref('youtube__video_metadata') }}

{% endif %}

), demographics_by_day as (
    
    select
        demographics.date_day,
        demographics.video_id,

        {% if var('youtube__using_video_metadata', false) %}
        video_metadata.title as video_title,
        video_metadata.description as video_desctiption,
        video_metadata.channel_title as channel_title,
        video_metadata.published_at as published_at,
        video_metadata.default_thumbnail_url as default_thumbnail_url,
        video_metadata.medium_thumbnail_url as medium_thumbnail_url,
        video_metadata.high_thumbnail_url as high_thumbnail_url,
        {% endif %}

        demographics.age_group,
        demographics.country_code,
        demographics.gender,
        sum(demographics.views_percentage) as views_percentage
    from demographics

    {% if var('youtube__using_video_metadata', false) %}
    left join video_metadata
        on video_metadata.video_id = demographics.video_id

    {{ dbt_utils.group_by(n=12) }}
    {% else %}

    {{ dbt_utils.group_by(n=5) }}
    {% endif %}
)

select *
from demographics_by_day