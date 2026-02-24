{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set branch_name = env_var('DBT_GIT_BRANCH', env_var('GIT_BRANCH', env_var('BRANCH_NAME', ''))) | lower -%}
    {%- set target_name = target.name | lower -%}

    {%- if branch_name == 'main' or target_name in ['prod', 'production'] -%}
        {%- set schema_prefix = 'prod' -%}
    {%- else -%}
        {%- set schema_prefix = 'dev' -%}
    {%- endif -%}

    {%- if custom_schema_name is none -%}
        {{ schema_prefix }}
    {%- else -%}
        {{ schema_prefix ~ '_' ~ (custom_schema_name | trim | lower) }}
    {%- endif -%}
{%- endmacro %}

