{{ config(
    materialized='incremental',
    unique_key='menu_item_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

with source_menu as (
    select
        menu_item_id,
        menu_id,
        menu_type_id,
        md5(upper(coalesce(truck_brand_name, 'UNKNOWN'))) as truck_brand_id,
        truck_brand_name,
        menu_item_name,
        item_category,
        item_subcategory,
        cost_of_goods_usd,
        sale_price_usd,
        sale_price_usd - cost_of_goods_usd as gross_margin_usd,
        case
            when sale_price_usd > 0 then round((sale_price_usd - cost_of_goods_usd) / sale_price_usd, 4)
            else null
        end as gross_margin_pct,
        menu_item_health_metrics_obj
    from {{ ref('stg_menu') }}
)

{% if is_incremental() %}
, existing as (
    select
        menu_item_id,
        menu_id,
        menu_type_id,
        truck_brand_id,
        truck_brand_name,
        menu_item_name,
        item_category,
        item_subcategory,
        cost_of_goods_usd,
        sale_price_usd,
        gross_margin_usd,
        gross_margin_pct,
        menu_item_health_metrics_obj
    from {{ this }}
)
{% endif %}

select s.*
from source_menu s
{% if is_incremental() %}
left join existing e
    on s.menu_item_id = e.menu_item_id
where e.menu_item_id is null
    or s.menu_id is distinct from e.menu_id
    or s.menu_type_id is distinct from e.menu_type_id
    or s.truck_brand_id is distinct from e.truck_brand_id
    or s.truck_brand_name is distinct from e.truck_brand_name
    or s.menu_item_name is distinct from e.menu_item_name
    or s.item_category is distinct from e.item_category
    or s.item_subcategory is distinct from e.item_subcategory
    or s.cost_of_goods_usd is distinct from e.cost_of_goods_usd
    or s.sale_price_usd is distinct from e.sale_price_usd
    or s.gross_margin_usd is distinct from e.gross_margin_usd
    or s.gross_margin_pct is distinct from e.gross_margin_pct
    or to_varchar(s.menu_item_health_metrics_obj) is distinct from to_varchar(e.menu_item_health_metrics_obj)
{% endif %}
