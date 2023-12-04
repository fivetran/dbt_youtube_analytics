{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with demographics as (
    
    select *
    from {{ var('channel_demographics') }}

),  video_metadata as (
    
    select *
    from {{ ref('youtube__video_metadata') }}

), demographics_by_day as (
    
    select
        demographics.date_day,
        demographics.video_id,
        video_metadata.video_title,
        video_metadata.video_description,
        video_metadata.channel_title,
        video_metadata.video_published_at,
        video_metadata.default_thumbnail_url,
        video_metadata.medium_thumbnail_url,
        video_metadata.high_thumbnail_url,
        demographics.age_group,
        demographics.country_code,
        demographics.gender,
        sum(demographics.views_percentage) as views_percentage
    from demographics

    left join video_metadata
        on video_metadata.video_id = demographics.video_id

    {{ dbt_utils.group_by(n=12) }}
)

select *
from demographics_by_day