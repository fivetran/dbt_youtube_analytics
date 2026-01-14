<!--section="youtube-analytics_transformation_model"-->
# Youtube Analytics dbt Package

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_youtube_analytics/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Youtube Analytics connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 11
- Connector documentation
  - [Youtube Analytics connector documentation](https://fivetran.com/docs/connectors/applications/youtube-analytics)
  - [Youtube Analytics ERD](https://fivetran.com/docs/connectors/applications/youtube-analytics#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_youtube_analytics)
  - [dbt Docs](https://fivetran.github.io/dbt_youtube_analytics/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_youtube_analytics/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_youtube_analytics/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to transform core object tables into analytics-ready models and explore video demographics. It creates enriched models with metrics focused on video performance and demographic insights.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_youtube_analytics
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [youtube__video_report](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__video_report) | Tracks daily video performance metrics including views, watch time, engagement, and revenue to analyze content performance and audience behavior. <br></br>**Example Analytics Questions:**<ul><li>Which videos generate the most views, watch time, and subscriber growth?</li><li>How do engagement rates (likes, comments, shares) vary across different videos?</li><li>What is the average view duration and audience retention by video?</li></ul>|
| [youtube__demographics_report](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__demographics_report) | Breaks down daily video views by audience demographics including gender, age group, and country to understand who is watching your content. <br></br>**Example Analytics Questions:**<ul><li>What percentage of views come from different age groups or gender segments?</li><li>Which countries drive the most video views and watch time?</li><li>How do demographic distributions vary across different videos or content types?</li></ul>|
| [youtube__age_demographics_pivot](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__age_demographics_pivot) | Provides daily video view percentages with age ranges pivoted into separate columns for streamlined demographic analysis and reporting. <br></br>**Example Analytics Questions:**<ul><li>Which age groups have the highest view percentages for each video?</li><li>How do age demographics vary between different content categories?</li><li>What is the age distribution trend over time for popular videos?</li></ul>|
| [youtube__gender_demographics_pivot](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__gender_demographics_pivot) | Shows daily video view percentages with gender segments pivoted into separate columns for quick gender-based audience analysis. <br></br>**Example Analytics Questions:**<ul><li>What is the gender split of viewers for each video?</li><li>How do gender demographics differ across content types or topics?</li><li>Are there gender preference patterns for specific video categories?</li></ul>|
| [youtube__video_metadata](https://fivetran.github.io/dbt_youtube_analytics/#!/model/model.youtube_analytics.youtube__video_metadata) | Provides comprehensive video metadata including titles, descriptions, tags, publication dates, and channel information to enrich video performance analysis. <br></br>**Example Analytics Questions:**<ul><li>Which video tags or categories are associated with the highest-performing content?</li><li>How do video titles or descriptions correlate with view counts and engagement?</li><li>What is the publication date distribution and video count by channel?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Youtube Analytics connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/dbt).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_youtube_analytics/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following Youtube Analytics package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages

```yml
# packages.yml
packages:
  - package: fivetran/youtube_analytics
    version: [">=1.2.0", "<1.3.0"] # we recommend using ranges to capture non-breaking changes automatically
```
> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/youtube_analytics_source` in your `packages.yml` since this package has been deprecated.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables
By default, this package runs using your destination and the `youtube_analytics` schema. If this is not where your Youtube Analytics data is (for example, if your youtube schema is named `youtube_analytics_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    youtube_analytics_schema: your_schema_name
    youtube_analytics_database: your_database_name 
```

### Disabling Demographics Report
This packages assumes you are syncing the YouTube `channel_demographics_a1` report. If you are _not_ syncing this report, you may add the below configuration to your `dbt_project.yml` to disable the `stg_youtube__demographics` model and all downstream references.
```yml
# dbt_project.yml

vars:
  youtube__using_channel_demographics: false # true by default
```

### (Optional) Additional configurations

#### Unioning Multiple Youtube Analytics Connections
If you have multiple Youtube Analytics connections in Fivetran and want to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table(s) into the final models. You will be able to see which source it came from in the `source_relation` column(s) of each model. To use this functionality, you will need to set either (**note that you cannot use both**) the `union_schemas` or `union_databases` variables:

```yml
# dbt_project.yml
vars:
    ##You may set EITHER the schemas variables below
    youtube_analytics_union_schemas: ['youtube_analytics_one','youtube_analytics_two']

    ##Or may set EITHER the databases variables below
    youtube_analytics_union_databases: ['youtube_analytics_one','youtube_analytics_two']
```

#### Change the build schema
By default, this package will build the YouTube Analytics staging models within a schema titled (`<target_schema>` + `_youtube_source`) and the YouTube Analytics final models within a schema titled (`<target_schema>` + `_youtube`) in your target database. If this is not where you would like your modeled YouTube Analytics data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
    youtube_analytics:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_youtube_analytics/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
# dbt_project.yml
vars:
    youtube_analytics_<default_source_table_name>_identifier: your_table_name 
```

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]
    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

<!--section="youtube-analytics_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/youtube_analytics/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_youtube_analytics/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_youtube_analytics/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).