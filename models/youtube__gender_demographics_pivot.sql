{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with gender_pivot as (

    select *
    from {{ ref('int_youtube__gender_pivot') }}

), video_metadata as (

    select *
    from {{ ref('youtube__video_metadata') }}

{% set gender_columns = dbt_utils.get_column_values(source('youtube_analytics','channel_demographics'), 'gender') %}
), final as (

    select
        gender_pivot.date_day,
        gender_pivot.video_id,
        gender_pivot.source_relation,
        video_metadata.video_title,
        video_metadata.video_description,
        video_metadata.video_published_at,
        video_metadata.channel_title,
        video_metadata.default_thumbnail_url
        
        {% for col in gender_columns -%}
            , gender_pivot.{% if target.type in ('postgres, redshift') %}"{{ col }}"{% else %}{{ col }}{% endif %} as {{ col }}_view_percentage
        {% endfor -%}
    from gender_pivot

    left join video_metadata
        on video_metadata.video_id = gender_pivot.video_id
        and video_metadata.source_relation = gender_pivot.source_relation

)

select *
from final