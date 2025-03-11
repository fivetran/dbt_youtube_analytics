{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with staging as (

    select 
        video_id, 
        source_relation,
        sum(comments) as comments,
        sum(dislikes) as dislikes,
        sum(likes) as likes,
        sum(shares) as shares,
        sum(subscribers_gained) as subscribers_gained,
        sum(subscribers_lost) as subscribers_lost,
        sum(views) as views,
        sum(watch_time_minutes) as watch_time_minutes
    from {{ ref('stg_youtube__channel_basic') }}
    group by 1, 2
),

report as (

    select 
        video_id, 
        source_relation,
        sum(comments) as comments,
        sum(dislikes) as dislikes,
        sum(likes) as likes,
        sum(shares) as shares,
        sum(subscribers_gained) as subscribers_gained,
        sum(subscribers_lost) as subscribers_lost,
        sum(views) as views,
        sum(watch_time_minutes) as watch_time_minutes
    from {{ ref('youtube__video_report') }}
    group by 1, 2
)

select * 
from staging
full outer join report 
    on staging.video_id = report.video_id
    and staging.source_relation = report.source_relation
where 
    staging.comments != report.comments
    and staging.dislikes != report.dislikes
    and staging.likes != report.likes
    and staging.shares != report.shares
    and staging.subscribers_gained != report.subscribers_gained
    and staging.subscribers_lost != report.subscribers_lost
    and staging.views != report.views
    and staging.watch_time_minutes != report.watch_time_minutes