with source_menu as (
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
