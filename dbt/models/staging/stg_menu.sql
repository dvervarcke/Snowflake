with source_menu as (
    select
        menu_id::number as menu_id,
        menu_type_id::number as menu_type_id,
        trim(menu_type)::varchar as menu_type,
        trim(truck_brand_name)::varchar as truck_brand_name,
        menu_item_id::number as menu_item_id,
        trim(menu_item_name)::varchar as menu_item_name,
        trim(item_category)::varchar as item_category,
        trim(item_subcategory)::varchar as item_subcategory,
        cost_of_goods_usd::number(10,2) as cost_of_goods_usd,
        sale_price_usd::number(10,2) as sale_price_usd,
        menu_item_health_metrics_obj
    from {{ source('source_data', 'menu') }}
)

select
    menu_id,
    menu_type_id,
    menu_type,
    truck_brand_name,
    menu_item_id,
    menu_item_name,
    item_category,
    item_subcategory,
    cost_of_goods_usd,
    sale_price_usd,
    menu_item_health_metrics_obj
from source_menu
where menu_item_id is not null
