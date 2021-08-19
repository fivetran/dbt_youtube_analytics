with report as (

    select *
    from {{ var('channel_basic') }}

{% if var('youtube__using_video_metadata', false) %}

),  video_metadata as (
    
    select *
    from {{ ref('youtube__video_metadata') }}

{% endif %}

), aggregated as (

    select
        report.date_day, 
        report.video_id,
        report.channel_id, 

        {% if var('youtube__using_video_metadata', false) %}
        video_metadata.title as video_title,
        video_metadata.description as video_description,
        video_metadata.channel_title as channel_title,
        video_metadata.published_at as published_at,
        video_metadata.default_thumbnail_url as default_thumbnail_url,
        video_metadata.medium_thumbnail_url as medium_thumbnail_url,
        video_metadata.high_thumbnail_url as high_thumbnail_url,
        {% endif %}

        sum(report.average_view_duration_percentage * report.views) / nullif(sum(report.views),0) as average_view_duration_percentage, 
        sum(report.average_view_duration_seconds * report.views) / nullif(sum(report.views),0) as average_view_duration_seconds, 
        sum(report.comments) as comments, 
        sum(report.dislikes) as dislikes, 
        sum(report.likes) as likes, 
        sum(report.shares) as shares, 
        sum(report.subscribers_gained) as subscribers_gained, 
        sum(report.subscribers_lost) as subscribers_lost, 
        sum(report.views) as views, 
        sum(report.watch_time_minutes) as watch_time_minutes
    from report
    
    {% if var('youtube__using_video_metadata', false) %}
    
    left join video_metadata
        on video_metadata.video_id = report.video_id

    {{ dbt_utils.group_by(n=10) }}

    {% else %}

    {{ dbt_utils.group_by(n=3) }}

    {% endif %}

), additional_features as (

    select 
        *,
        (average_view_duration_seconds / nullif(average_view_duration_percentage,0)) as video_duration_seconds,
        {{ dbt_utils.surrogate_key(['date_day','video_id']) }} as daily_video_id
    from aggregated

)

select *
from additional_features