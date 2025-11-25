# dbt_youtube_analytics v1.1.0

[PR #30](https://github.com/fivetran/dbt_youtube_analytics/pull/30) includes the following updates:

## Features
  - Increases the required dbt version upper limit to v3.0.0

# dbt_youtube_analytics v1.0.2

This release includes the following updates:

## Bug Fixes
- Changed `snippet_published_at` and `status_publish_at` from datetime to timestamp datatype to fix compatibility issues with Databricks SQL Warehouses ([PR #29](https://github.com/fivetran/dbt_youtube_analytics/pull/29))

## Under the Hood
- Added integration testing step for Databricks SQL Warehouse.

# dbt_youtube_analytics v1.0.1

This release includes the following updates:

## Bug Fixes
- Fixed mixed-case column names in `youtube__age_demographics_pivot` and `youtube__gender_demographics_pivot` models that were causing issues with Snowflake's `persist_docs` functionality. Column names are now consistently lowercase (e.g., `age_25_34_view_percentage` instead of `AGE_25_34_view_percentage`). ([PR #26](https://github.com/fivetran/dbt_youtube_analytics/pull/26))

## Documentation
- Added documentation for the `user_specified_view_percentage` field in the `youtube__gender_demographics_pivot` model. 
> `USER_SPECIFIED` has replaced `GENDER_OTHER` as a demographic in the [YouTube Analytics Reporting API](https://developers.google.com/youtube/analytics/dimensions#gender), but the model will continue to have both the `user_specified_view_percentage` and `gender_other_view_percentage` fields.

## Under the Hood
- (Maintainers only) Added consistency validation tests for the `youtube__age_demographics_pivot` and `youtube__gender_demographics_pivot` models. ([PR #27](https://github.com/fivetran/dbt_youtube_analytics/pull/27))

## Contributors
- [@oeraker](https://github.com/oeraker) ([PR #26](https://github.com/fivetran/dbt_youtube_analytics/pull/26))

# dbt_youtube_analytics v1.0.0

[PR #23](https://github.com/fivetran/dbt_youtube_analytics/pull/23) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/youtube_analytics_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/youtube_analytics_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/youtube_analytics_source` package will also need to be removed or updated to reference this package.
  - Update any youtube_analytics_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_youtube_analytics/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_youtube_analytics.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_youtube_analytics v0.5.0
[PR #19](https://github.com/fivetran/dbt_youtube_analytics/pull/19) includes the following updates:

## Feature Updates
- Introduced the ability to union multiple schemas or databases. For more information on how to leverage this feature, refer to the [README](https://github.com/fivetran/dbt_youtube_analytics/blob/main/README.md#unioning-multiple-youtube-analytics-connections).

## Breaking Changes:
- Following the unioning functionality, we have added a new field `source_relation` to every model. This identifies the source of each record.
- Updated the `source.name` for the following tables in order to execute the union macro successfully. The source `names` are now aligned with their `identifiers` as they appear in the warehouse, rather than shortening the table names.
  - The source node for the `channel_basic_a_2` table has been updated from `channel_basic` to `channel_basic_a_2`. If you are directly referencing this source, update your references to `{{ source('youtube_analytics', 'channel_basic_a_2') }}`.
  - The source node for the `channel_demographics_a_1` table has been updated from `channel_demographics` to `channel_demographics_a_1`. If you are directly referencing this source, update your references to `{{ source('youtube_analytics', 'channel_demographics_a_1') }}`.

## Documentation
- Added Quickstart model counts to README. ([#18](https://github.com/fivetran/dbt_youtube_analytics/pull/18))
- Corrected references to connectors and connections in the README. ([#18](https://github.com/fivetran/dbt_youtube_analytics/pull/18))

## Under the Hood
- Updated the uniqueness tests to include `source_relation`.
- Updated Copyright and README format.
- Added validation tests for `youtube__video_report`.

# dbt_youtube_analytics v0.4.0

The following changes were all made as a result of the [latest updates to the Fivetran YouTube Analytics connector](https://fivetran.com/docs/applications/youtube-analytics/changelog#june2023).
## 🚨 Breaking Changes 🚨 (within the upstream [dbt_youtube_analytics_source v0.4.0 release](https://github.com/fivetran/dbt_youtube_analytics_source/releases/tag/v0.4.0)):
- Removed support for the `video_metadata` Cloud Function generated source table and downstream models. This also means the following variables are no longer used or necessary within the package: ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))
  - `youtube__using_video_metadata`
  - `youtube_metadata_schema`
  - `youtube_analytics_database`
- The field `published_at` has been renamed to `video_published_at` within the following end models due to changes within the upstream source package: ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))
  - `youtube__video_report`
  - `youtube__video_metadata`
  - `youtube__demographics_report`
- To be consistent with our other packages, the identifier variables have been updated. Please see the following changes to the identifier variables used in this package. ([PR #12](https://github.com/fivetran/dbt_youtube_analytics_source/pull/12))

| **old identifier name** | **new identifier name** |
| ------------------------|-------------------------|
| `youtube__channel_basic_table` | `youtube_analytics_channel_basic_a_2_identifier` |
| `youtube__channel_demographics_table` | `youtube_analytics_channel_demographics_a_1_identifier` |

## Feature Updates:
- Following the latest update to **all** Fivetran YouTube Analytics connectors, the `video` metadata is now synced as part of the connector by default. Therefore, the `video` source and staging models along with the following downstream models have been updated to reference the `video` source table which is synced by default: ([PR #13](https://github.com/fivetran/dbt_youtube_analytics/pull/13))
  - `youtube__video_metadata`
  - `youtube__video_report`
  - `youtube__age_demographics_pivot`
  - `youtube__demographics_report`
  - `youtube__gender_demographics_pivot`

## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#11](https://github.com/fivetran/dbt_youtube_analytics/pull/11))
- Updated the pull request [templates](/.github). ([#11](https://github.com/fivetran/dbt_youtube_analytics/pull/11))
- Included auto-releaser GitHub Actions workflow to automate future releases. ([PR #13](https://github.com/fivetran/dbt_youtube_analytics/pull/13))

# dbt_youtube_analytics v0.3.0

## 🚨 Breaking Changes 🚨:
[PR #9](https://github.com/fivetran/dbt_youtube_analytics/pull/9) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `dbt_utils.surrogate_key` has also been updated to `dbt_utils.generate_surrogate_key`. Since the method for creating surrogate keys differ, we suggest all users do a `full-refresh` for the most accurate data. For more information, please refer to dbt-utils [release notes](https://github.com/dbt-labs/dbt-utils/releases) for this update.
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
- Previously, Youtube Analytics staging models were by default built within a schema titled (`<target_schema>` + `_stg_youtube`) in your destination. Now, they are by default written to a schema entitled (`<target_schema>` + `youtube_source`) in your destination. Refer to the README for instructions on how to configure this further. 

# dbt_youtube_analytics v0.2.1
- Updated the default schema reference for video metadata
# dbt_youtube_analytics v0.2.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_youtube_analytics_source`. Additionally, the latest `dbt_youtube_analytics_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_youtube_analytics v0.1.0 
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
