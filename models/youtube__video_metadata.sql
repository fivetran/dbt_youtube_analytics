{{ config(enabled=var('youtube__using_video_metadata', false)) }}

with video_metadata as (
    select *
    from {{ var('video_metadata')}}

), url_parsing as (

    select
        video_id,
        title,
        description,
        published_at,
        channel_title,
        {{ fivetran_utils.json_parse("thumbnails",["default","url"]) }} as default_thumbnail_url,
        {{ fivetran_utils.json_parse("thumbnails",["medium","url"]) }} as medium_thumbnail_url,
        {{ fivetran_utils.json_parse("thumbnails",["high","url"]) }} as high_thumbnail_url
    from video_metadata
)

select *
from url_parsing