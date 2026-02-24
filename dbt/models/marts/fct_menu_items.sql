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
        md5(upper(coalesce(item_category, 'UNKNOWN'))) as item_category_id,
        md5(
            upper(coalesce(item_category, 'UNKNOWN')) || '|' ||
            upper(coalesce(item_subcategory, 'UNKNOWN'))
        ) as item_subcategory_id,
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

select *
from source_menu
