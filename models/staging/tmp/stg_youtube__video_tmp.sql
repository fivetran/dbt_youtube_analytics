{% if var('youtube_analytics_union_schemas', []) | length > 0 or var('youtube_analytics_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='video', 
        database_variable='youtube_analytics_database', 
        schema_variable='youtube_analytics_schema', 
        default_database=target.database,
        default_schema='youtube_analytics',
        default_variable='video',
        union_schema_variable='youtube_analytics_union_schemas',
        union_database_variable='youtube_analytics_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='youtube_analytics_sources',
        single_source_name='youtube_analytics',
        single_table_name='video'
    )
}}

{% endif %}