{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select 
        date_day,
        video_id,
        channel_id,
        source_relation,
        video_title,
        video_description,
        channel_title,
        video_published_at,
        default_thumbnail_url,
        medium_thumbnail_url,
        high_thumbnail_url,
        round(average_view_duration_percentage, 0) as average_view_duration_percentage,
        round(average_view_duration_seconds, 0) as average_view_duration_seconds,
        round(comments, 0) as comments,
        round(dislikes, 0) as dislikes,
        round(likes, 0) as likes,
        round(shares, 0) as shares,
        round(subscribers_gained, 0) as subscribers_gained,
        round(subscribers_lost, 0) as subscribers_lost,
        round(views, 0) as views,
        round(watch_time_minutes, 0) as watch_time_minutes,
        round(video_duration_seconds, 0) as video_duration_seconds,
        daily_video_id

    from {{ target.schema }}_youtube_analytics_prod.youtube__video_report
),

dev as (
    select 
        date_day,
        video_id,
        channel_id,
        source_relation,
        video_title,
        video_description,
        channel_title,
        video_published_at,
        default_thumbnail_url,
        medium_thumbnail_url,
        high_thumbnail_url,
        round(average_view_duration_percentage, 0) as average_view_duration_percentage,
        round(average_view_duration_seconds, 0) as average_view_duration_seconds,
        round(comments, 0) as comments,
        round(dislikes, 0) as dislikes,
        round(likes, 0) as likes,
        round(shares, 0) as shares,
        round(subscribers_gained, 0) as subscribers_gained,
        round(subscribers_lost, 0) as subscribers_lost,
        round(views, 0) as views,
        round(watch_time_minutes, 0) as watch_time_minutes,
        round(video_duration_seconds, 0) as video_duration_seconds,
        daily_video_id
        
    from {{ target.schema }}_youtube_analytics_dev.youtube__video_report
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final