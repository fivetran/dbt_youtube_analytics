{% macro get_channel_basic_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "annotation_click_through_rate", "datatype": dbt.type_float()},
    {"name": "annotation_clickable_impressions", "datatype": dbt.type_int()},
    {"name": "annotation_clicks", "datatype": dbt.type_int()},
    {"name": "annotation_closable_impressions", "datatype": dbt.type_int()},
    {"name": "annotation_close_rate", "datatype": dbt.type_float()},
    {"name": "annotation_closes", "datatype": dbt.type_int()},
    {"name": "annotation_impressions", "datatype": dbt.type_int()},
    {"name": "average_view_duration_percentage", "datatype": dbt.type_float()},
    {"name": "average_view_duration_seconds", "datatype": dbt.type_float()},
    {"name": "card_click_rate", "datatype": dbt.type_float()},
    {"name": "card_clicks", "datatype": dbt.type_int()},
    {"name": "card_impressions", "datatype": dbt.type_int()},
    {"name": "card_teaser_click_rate", "datatype": dbt.type_float()},
    {"name": "card_teaser_clicks", "datatype": dbt.type_int()},
    {"name": "card_teaser_impressions", "datatype": dbt.type_int()},
    {"name": "channel_id", "datatype": dbt.type_string()},
    {"name": "comments", "datatype": dbt.type_int()},
    {"name": "country_code", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "dislikes", "datatype": dbt.type_int()},
    {"name": "likes", "datatype": dbt.type_int()},
    {"name": "live_or_on_demand", "datatype": dbt.type_string()},
    {"name": "red_views", "datatype": dbt.type_int()},
    {"name": "red_watch_time_minutes", "datatype": dbt.type_float()},
    {"name": "shares", "datatype": dbt.type_int()},
    {"name": "subscribed_status", "datatype": dbt.type_string()},
    {"name": "subscribers_gained", "datatype": dbt.type_int()},
    {"name": "subscribers_lost", "datatype": dbt.type_int()},
    {"name": "video_id", "datatype": dbt.type_string()},
    {"name": "videos_added_to_playlists", "datatype": dbt.type_int()},
    {"name": "videos_removed_from_playlists", "datatype": dbt.type_int()},
    {"name": "views", "datatype": dbt.type_int()},
    {"name": "watch_time_minutes", "datatype": dbt.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}
