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
    sale_price_usd - cost_of_goods_usd as gross_margin_usd,
    menu_item_health_metrics_obj
from {{ ref('stg_menu') }}
