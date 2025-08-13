
with base as (

    select * 
    from {{ ref('stg_youtube__channel_basic_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_youtube__channel_basic_tmp')),
                staging_columns=get_channel_basic_columns()
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
        _fivetran_synced, 
        average_view_duration_percentage / 100.0 as average_view_duration_percentage, 
        average_view_duration_seconds, 
        channel_id, 
        comments, 
        dislikes, 
        likes, 
        shares, 
        subscribers_gained, 
        subscribers_lost, 
        video_id, 
        views, 
        watch_time_minutes,
        source_relation
    from fields
)

select * from final
