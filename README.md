[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# YouTube Analytics

This package models YouTube Analytics data from [Fivetran's connector](https://fivetran.com/docs/applications/youtube-analytics#youtubeanalytics). It uses data in the format described by the [YouTube Channel Report schemas](https://fivetran.com/docs/applications/youtube-analytics#schemainformation).

The main focus of the package is to transform the core object tables into analytics-ready models. It includes options to explore video demographics and a comprehensive overview of video performance that you could combine with other organic ad platform reports.

## Models
This package contains transformation models, designed to work simultaneously with our [YouTube Analytics source package](https://github.com/fivetran/dbt_youtube_analytics_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                 | **description**                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [youtube__video_report](models/youtube__video_report.sql)  | Each record represents the daily aggregation of your YouTube video performance.    |
| [youtube__demographics_report](models/youtube__demographics_report.sql)        | Each record represents a daily video view percentage by gender, age, and country.            |
| [youtube__age_demographics_pivot](models/youtube__age_demographics_pivot.sql)        | Each record represents a daily video view percentage with the age ranges pivoted out for quicker analysis.            |
| [youtube__gender_demographics_pivot](models/youtube__gender_demographics_pivot.sql)        | Each record represents a daily video view percentage with the gender options pivoted out for quicker analysis.            |
| [youtube__video_metadata](models/youtube__gender_demographics_pivot.sql)           | Each record represents an individual video enriched with metadata. This model is disabled by default. Read our [YouTube Video Metadata Cloud Function Write Up](https://resources.fivetran.com/datasheets/youtube-metadata-cloud-function-guide-2) or our [YouTube Analytics source package README](https://github.com/fivetran/dbt_youtube_analytics_source) to learn how to generate this model.          |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/youtube_analytics
    version: [">=0.2.0", "<0.3.0"]
```

## Configuration
## Required YouTube Channel Reports
To use this package, you need to pull the following YouTube Analytics reports through Fivetran:
- [channel_basic_a2](https://developers.google.com/youtube/reporting/v1/reports/channel_reports#video-user-activity) (required)
- [channel_demographics_a1](https://developers.google.com/youtube/reporting/v1/reports/channel_reports#video-viewer-demographics) (optional)
- [videos metadata table](https://resources.fivetran.com/datasheets/youtube-metadata-cloud-function-guide-2) (optional)

### Schema Configuration
By default, this package will look for your YouTube Analytics data in the `youtube_analytics` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your YouTube Analytics data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    youtube_analytics_database: your_database_name
    youtube_analytics_schema: your_schema_name
```

## YouTube Video Metadata
The Fivetran YouTube Analytics connector currently does not support video metadata. Consequently, it may be difficult to analyze individual video data without knowing which video belongs to which record. 

As a workaround, you can create a [Functions connector](https://fivetran.com/docs/functions) that syncs your YouTube video metadata into a table in your destination. This dbt package can then use the `VIDEOS` metadata table to enrich your YouTube Analytics reporting data. To learn more about creating a Functions connector, read our [YouTube Analytics Video Metadata Cloud Function article](https://resources.fivetran.com/datasheets/youtube-metadata-cloud-function-guide-2). It provides code and detailed steps on how to configure the function. 

### Enable Video Metadata

By default, the video metadata functionality within this package is disabled. If you have [configured a cloud function to sync your video metadata into a `VIDEOS` table](https://github.com/fivetran/dbt_youtube_analytics/blob/main/README.md#enable-video-metadata), you must enable the package to incorporate the metadata into your package. You may use the variable configuration below in your `dbt_project.yml` to enable this functionality:

```yml
vars:
  youtube__using_video_metadata: true # false by default
```

### Video Metadata Schema Configuration

By default, this package will look for your `VIDEOS` YouTube Analytics metadata table in the `youtube_metadata_schema` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your YouTube Analytics metadata table is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    youtube_metadata_schema: your_schema_name
    youtube_analytics_database: your_database_name 
```
### Disable Demographics Report
This packages assumes you are syncing the YouTube `channel_demographics_a1` report. If you are not syncing this report, you may add the below configuration to your `dbt_project.yml` to disable the `stg_youtube__demographics` model and all downstream references.
```yml
# dbt_project.yml

...
vars:
  youtube__using_channel_demographics: false # true by default
```

### Specifying Source Table Names

This package assumes that the `channel_basic_a_2` and `channel_demographics_a_1` reports are named accordingly. If these reports have different names in your destination, enter the correct names in the `channel_basic_table_name` and/or `channel_demographics_table_name` variables in your `dbt_project.yml` so that the package can find them:

```yml
# dbt_project.yml

...
vars:
  youtube__channel_basic_table:         "my_channel_basic_table_name"
  youtube__channel_demographics_table:  "demographics_youtube_report"
```

### Changing the Build Schema

By default, this package will build the YouTube Analytics staging models within a schema titled (`<target_schema>` + `_stg_youtube`) and the YouTube Analytics final models within a schema titled (`<target_schema>` + `_youtube`) in your target database. If this is not where you would like your modeled YouTube Analytics data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  youtube_analytics:
    +schema: my_new_schema_name # leave blank for just the target_schema
  youtube_analytics_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```

For additional configurations for the source models, visit the [YouTube Analytics source package](https://github.com/fivetran/dbt_youtube_analytics_source).

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Database support
This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
