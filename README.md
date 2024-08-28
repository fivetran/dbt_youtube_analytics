<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_youtube_analytics/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Youtube Analytics Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_youtube_analytics/))
## What does this dbt package do?
- Produces modeled tables that leverage data in the format described by the [YouTube Channel Report schemas](https://fivetran.com/docs/applications/youtube-analytics#schemainformation) and builds off the output of our [Youtube Analytics source package](https://github.com/fivetran/dbt_youtube_analytics_source).
- Transform the core object tables into analytics-ready models.
- Includes options to explore video demographics and a comprehensive overview of video performance that you could combine with other organic ad platform reports.
- Generates a comprehensive data dictionary of your source and modeled Youtube Analytics data through the [dbt docs site](https://fivetran.github.io/dbt_youtube_analytics/).

<!--section=“youtube_transformation_model"-->

The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_youtube_analytics/#!/overview?g_v=1&g_e=seeds).


| **Table**                 | **Description**                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [youtube__video_report](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__video_report)  | Each record represents the daily aggregation of your YouTube video performance.    |
| [youtube__demographics_report](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__demographics_report)        | Each record represents a daily video view percentage by gender, age, and country.            |
| [youtube__age_demographics_pivot](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__age_demographics_pivot)        | Each record represents a daily video view percentage with the age ranges pivoted out for quicker analysis.            |
| [youtube__gender_demographics_pivot](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__gender_demographics_pivot)        | Each record represents a daily video view percentage with the gender options pivoted out for quicker analysis.            |
| [youtube__video_metadata](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__video_metadata)           | Each record represents an individual video enriched with metadata.          |

<!--section-end-->

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Youtube Analytics connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package
Include the following Youtube Analytics package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages

```yml
# packages.yml
packages:
  - package: fivetran/youtube_analytics
    version: [">=0.4.0", "<0.5.0"] # we recommend using ranges to capture non-breaking changes automatically
```
Do NOT include the `youtube_analytics_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well.

### Step 3: Define database and schema variables
By default, this package runs using your destination and the `youtube_analytics` schema. If this is not where your Youtube Analytics data is (for example, if your youtube schema is named `youtube_analytics_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    youtube_analytics_schema: your_schema_name
    youtube_analytics_database: your_database_name 
```

### Step 4: Disabling Demographics Report
This packages assumes you are syncing the YouTube `channel_demographics_a1` report. If you are _not_ syncing this report, you may add the below configuration to your `dbt_project.yml` to disable the `stg_youtube__demographics` model and all downstream references.
```yml
# dbt_project.yml

vars:
  youtube__using_channel_demographics: false # true by default
```

### (Optional) Step 5: Additional configurations

#### Change the build schema
By default, this package will build the YouTube Analytics staging models within a schema titled (`<target_schema>` + `_youtube_source`) and the YouTube Analytics final models within a schema titled (`<target_schema>` + `_youtube`) in your target database. If this is not where you would like your modeled YouTube Analytics data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
  youtube_analytics:
    +schema: my_new_schema_name # leave blank for just the target_schema
  youtube_analytics_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_youtube_analytics_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
# dbt_project.yml
vars:
    youtube_analytics_<default_source_table_name>_identifier: your_table_name 
```

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/youtube_analytics_source
      version: [">=0.4.0", "<0.5.0"]
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]
    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/youtube_analytics/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_youtube_analytics/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_youtube_analytics/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
