with video_metadata as (
    select *
    from {{ ref('stg_youtube__video') }}

), url_parsing as (

    select
        *,
        {{ fivetran_utils.json_parse("video_thumbnails",["default","url"]) }} as default_thumbnail_url,
        {{ fivetran_utils.json_parse("video_thumbnails",["standard","url"]) }} as standard_thumbnail_url,
        {{ fivetran_utils.json_parse("video_thumbnails",["medium","url"]) }} as medium_thumbnail_url,
        {{ fivetran_utils.json_parse("video_thumbnails",["high","url"]) }} as high_thumbnail_url
    from video_metadata
)

select *
from url_parsing