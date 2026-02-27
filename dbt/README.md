# dbt + Snowflake (embedded dbt in Snowsight)

This folder is ready to use as a Snowflake native dbt project (Git-backed in Snowsight).

## 1. Create a dbt project in Snowsight

1. In Snowflake Snowsight, open **Projects** and create a **dbt Project**.
2. Connect it to this Git repository.
3. Set the project root/path to:
   - `/dbt`

## 2. Configure Snowflake project environment

In the Snowsight dbt project environment, set:

- Role: your dbt execution role
- Warehouse: your transformation warehouse
- Database: target database for dbt models
- Schema: source schema for raw data (models are routed by layer/branch)

Source table configuration in this project:

- source name: `source_data`
- table: `menu`
- source database: `target.database` from environment
- source schema: `target.schema` from environment

That means your source should exist as:
- `<target.database>.<target.schema>.MENU`

Model schema behavior:

- `codex/*` branches (or non-prod targets): staging -> `DEV_SILVER`, marts -> `DEV_GOLD`
- `main` branch (or `prod` target): staging -> `PROD_SILVER`, marts -> `PROD_GOLD`

## 3. Run in embedded dbt

In Snowsight dbt worksheet/runner:

```sql
dbt deps
dbt run
dbt test
```

This project does not require external dbt Hub packages. If your environment blocks outbound internet access, you can run:

```sql
dbt run
dbt test
```

## GitHub CI/CD

Workflow: `.github/workflows/snowflake-dbt-cicd.yml`

- PR to `main`: runs deployment pipeline with `dev` target.
- Push to `codex/snowflake-dbt`: deploys stored procedures + runs `dbt build` in `dev`.
- Push to `main`: deploys stored procedures + runs `dbt build` in `prod`.
- Manual run: choose `dev` or `prod` and optional `--full-refresh`.
- Stored procedure schemas are environment-specific:
  - `DEV_ORCHESTRATION` for `dev`
  - `PROD_ORCHESTRATION` for `prod`

Required GitHub secrets:

- `SNOWFLAKE_ACCOUNT`
- `SNOWFLAKE_USER`
- `SNOWFLAKE_PASSWORD`
- `SNOWFLAKE_DATABASE`
- `SNOWFLAKE_SOURCE_SCHEMA`
- `SNOWFLAKE_DEV_ROLE`
- `SNOWFLAKE_DEV_WAREHOUSE`
- `SNOWFLAKE_PROD_ROLE`
- `SNOWFLAKE_PROD_WAREHOUSE`

Optional fallback secrets:

- `SNOWFLAKE_ROLE`
- `SNOWFLAKE_WAREHOUSE`

If your runtime asks for a `profiles.yml`, this project includes one at:

- `dbt/profiles.yml`

Set the password value before running, or provide a runtime secret and update the file to use an environment variable.

## Optional: local CLI use

If you also want local CLI runs, use `profiles/profiles.yml.example` as a template for a local `profiles.yml`, then set:

```bash
export DBT_PROFILES_DIR=$(pwd)
```

## Project layout

- `models/staging/stg_menu.sql`: cleaned staging model from source table.
- `models/marts/dim_menu.sql`: menu dimension.
- `models/marts/dim_menu_types.sql`: menu-type dimension.
- `models/marts/dim_truck_brands.sql`: truck-brand dimension.
- `models/marts/dim_item_categories.sql`: item-category dimension.
- `models/marts/dim_item_subcategories.sql`: item-subcategory dimension.
- `models/marts/fct_menu_items.sql`: item-grain fact model with margin metrics and dimension keys.
- `models/marts/fct_category_sales.sql`: aggregated sales and margin fact by category.
- `models/**.yml`: source docs and tests.
- `sql/create_dbt_run_procedures.sql`: stored procedures to trigger dbt builds from Snowflake SQL.
