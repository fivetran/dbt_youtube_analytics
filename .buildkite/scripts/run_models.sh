#!/bin/bash

set -euo pipefail

apt-get update
apt-get install libsasl2-dev

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip setuptools
pip install -r integration_tests/requirements.txt
mkdir -p ~/.dbt
cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml

db=$1
echo `pwd`
cd integration_tests
dbt deps

if [ "$db" = "databricks-sql" ]; then
dbt seed --vars '{youtube_analytics_schema: youtube_analytics_sqlw_tests_4}' --target "$db" --full-refresh
dbt source freshness --vars '{youtube_analytics_schema: youtube_analytics_sqlw_tests_4}' --target "$db" || echo "...Only verifying freshness runs…"
dbt compile --vars '{youtube_analytics_schema: youtube_analytics_sqlw_tests_4}' --target "$db"
dbt run --vars '{youtube_analytics_schema: youtube_analytics_sqlw_tests_4}' --target "$db" --full-refresh
dbt test --vars '{youtube_analytics_schema: youtube_analytics_sqlw_tests_4}' --target "$db"
dbt run --vars '{youtube_analytics_schema: youtube_analytics_sqlw_tests_4, youtube__using_channel_demographics: true}' --target "$db"
else
fi

dbt seed --target "$db" --full-refresh
dbt run --target "$db" --full-refresh
dbt test --target "$db"
## UPDATE FOR VARS HERE, IF NO VARS, PLEASE REMOVE
dbt run --vars '{youtube__using_video_metadata: False, youtube__using_channel_demographics: False}' --target "$db" --full-refresh
dbt test --target "$db"
### END VARS CHUNK, REMOVE IF NOT USING
dbt run-operation fivetran_utils.drop_schemas_automation --target "$db"
