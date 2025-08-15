with report as (

    select *
    from {{ ref('stg_youtube__channel_basic') }}

),  video_metadata as (
    
    select *
    from {{ ref('youtube__video_metadata') }}

), aggregated as (

    select
        report.date_day, 
        report.video_id,
        report.channel_id, 
        report.source_relation,
        video_metadata.video_title,
        video_metadata.video_description,
        video_metadata.channel_title,
        video_metadata.video_published_at,
        video_metadata.default_thumbnail_url,
        video_metadata.medium_thumbnail_url,
        video_metadata.high_thumbnail_url,
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
    
    left join video_metadata
        on video_metadata.video_id = report.video_id
        and video_metadata.source_relation = report.source_relation

    {{ dbt_utils.group_by(n=11) }}

), additional_features as (

    select 
        *,
        (average_view_duration_seconds / nullif(average_view_duration_percentage,0)) as video_duration_seconds,
        {{ dbt_utils.generate_surrogate_key(['date_day','video_id']) }} as daily_video_id
    from aggregated

)

select *
from additional_features