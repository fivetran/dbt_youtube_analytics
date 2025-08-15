{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with base as (

    select * 
    from {{ ref('stg_youtube__channel_demographics_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_youtube__channel_demographics_tmp')),
                staging_columns=get_channel_demographics_columns()
            )
        }}
        
        {{ fivetran_utils.source_relation(
            union_schema_variable='youtube_analytics_union_schemas', 
            union_database_variable='youtube_analytics_union_databases') 
        }}
        
    from base
),

final as (
    
    select 
        _fivetran_id,
        date as date_day,
        video_id,
        channel_id,
        age_group,
        country_code,
        gender,
        live_or_on_demand,
        subscribed_status,
        views_percentage / 100.0 as views_percentage,
        _fivetran_synced,
        source_relation
    from fields
)

select * 
from final
