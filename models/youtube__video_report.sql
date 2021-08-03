with report as (

    select *
    from {{ ref('stg_youtube__channel_basic') }}

), aggregated as (

    select
        date_day, 
        video_id,
        channel_id, 
        sum(average_view_duration_percentage * views) / nullif(sum(views),0) as average_view_duration_percentage, 
        sum(average_view_duration_seconds * views) / nullif(sum(views),0) as average_view_duration_seconds, 
        sum(comments) as comments, 
        sum(dislikes) as dislikes, 
        sum(likes) as likes, 
        sum(shares) as shares, 
        sum(subscribers_gained) as subscribers_gained, 
        sum(subscribers_lost) as subscribers_lost, 
        sum(views) as views, 
        sum(watch_time_minutes) as watch_time_minutes
    from report
    group by 1,2,3

), additional_features as (

    select 
        *,
        average_view_duration_seconds / (average_view_duration_percentage) as video_duration_seconds,
        {{ dbt_utils.surrogate_key(['date_day','video_id']) }} as daily_video_id
    from aggregated

)

select *
from additional_features