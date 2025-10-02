{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select 
        date_day,
        video_id,
        source_relation,
        video_title,
        video_description,
        video_published_at,
        channel_title,
        default_thumbnail_url,
        round(age_25_34_view_percentage, 0) as age_25_34_view_percentage,
        round(age_18_24_view_percentage, 0) as age_18_24_view_percentage,
        round(age_35_44_view_percentage, 0) as age_35_44_view_percentage,
        round(age_45_54_view_percentage, 0) as age_45_54_view_percentage,
        round(age_55_64_view_percentage, 0) as age_55_64_view_percentage,
        round(age_65__view_percentage, 0) as age_65__view_percentage,
        round(age_13_17_view_percentage, 0) as age_13_17_view_percentage

    from {{ target.schema }}_youtube_analytics_prod.youtube__age_demographics_pivot
),

dev as (
    select 
        date_day,
        video_id,
        source_relation,
        video_title,
        video_description,
        video_published_at,
        channel_title,
        default_thumbnail_url,
        round(age_25_34_view_percentage, 0) as age_25_34_view_percentage,
        round(age_18_24_view_percentage, 0) as age_18_24_view_percentage,
        round(age_35_44_view_percentage, 0) as age_35_44_view_percentage,
        round(age_45_54_view_percentage, 0) as age_45_54_view_percentage,
        round(age_55_64_view_percentage, 0) as age_55_64_view_percentage,
        round(age_65__view_percentage, 0) as age_65__view_percentage,
        round(age_13_17_view_percentage, 0) as age_13_17_view_percentage
        
    from {{ target.schema }}_youtube_analytics_dev.youtube__age_demographics_pivot
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