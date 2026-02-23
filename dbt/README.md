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
- Schema: target schema for dbt models (for example `TAXI_DW_DBT_DEV`)

Source table configuration in this project:

- source name: `source_data`
- table: `menu`
- source database: `target.database` from environment
- source schema: `target.schema` from environment

That means your source should exist as:
- `<target.database>.<target.schema>.MENU`

## 3. Run in embedded dbt

In Snowsight dbt worksheet/runner:

```sql
dbt deps
dbt run
dbt test
```

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
- `models/marts/fct_menu_items.sql`: mart model with gross margin.
- `models/**.yml`: source docs and tests.
