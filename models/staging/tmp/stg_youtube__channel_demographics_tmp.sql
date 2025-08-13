{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

{{
    fivetran_utils.union_data(
        table_identifier='channel_demographics_a_1', 
        database_variable='youtube_analytics_database', 
        schema_variable='youtube_analytics_schema', 
        default_database=target.database,
        default_schema='youtube_analytics',
        default_variable='channel_demographics',
        union_schema_variable='youtube_analytics_union_schemas',
        union_database_variable='youtube_analytics_union_databases'
    )
}}