-- Create stored procedures to trigger Snowflake Workspace dbt runs.
-- Workspace name is set to "Snowflake".
-- __ORCH_SCHEMA__ placeholder is replaced by CI/CD before deployment.

create or replace procedure SNOWFLAKE_LEARNING_DB.__ORCH_SCHEMA__.RUN_DBT_BUILD_ALL(
  dbt_target string
)
returns variant
language sql
execute as caller
as
$$
declare cmd string;
begin
  cmd := 'EXECUTE DBT PROJECT FROM WORKSPACE "Snowflake" ARGS = ''build --target '
      || replace(dbt_target,'''','''''')
      || '''';

  execute immediate :cmd;

  return object_construct(
    'query_id', last_query_id(),
    'workspace', 'Snowflake',
    'command', 'build',
    'target', dbt_target
  );
end;
$$;

create or replace procedure SNOWFLAKE_LEARNING_DB.__ORCH_SCHEMA__.RUN_DBT_BUILD_SELECT(
  model_selector string,
  dbt_target string
)
returns variant
language sql
execute as caller
as
$$
declare cmd string;
begin
  cmd := 'EXECUTE DBT PROJECT FROM WORKSPACE "Snowflake" ARGS = ''build --select '
      || replace(model_selector,'''','''''')
      || ' --target '
      || replace(dbt_target,'''','''''')
      || '''';

  execute immediate :cmd;

  return object_construct(
    'query_id', last_query_id(),
    'workspace', 'Snowflake',
    'command', 'build --select',
    'selector', model_selector,
    'target', dbt_target
  );
end;
$$;

-- Example calls:
-- call SNOWFLAKE_LEARNING_DB.__ORCH_SCHEMA__.RUN_DBT_BUILD_ALL('dev');
-- call SNOWFLAKE_LEARNING_DB.__ORCH_SCHEMA__.RUN_DBT_BUILD_ALL('prod');
-- call SNOWFLAKE_LEARNING_DB.__ORCH_SCHEMA__.RUN_DBT_BUILD_SELECT('fct_menu_items', 'dev');
