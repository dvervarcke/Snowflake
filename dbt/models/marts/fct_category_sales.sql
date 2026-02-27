select
    f.item_category_id,
    c.item_category,
    count(*) as menu_item_count,
    sum(f.sale_price_usd) as total_sales_amount_usd,
    sum(f.cost_of_goods_usd) as total_cost_amount_usd,
    sum(f.gross_margin_usd) as total_gross_margin_usd,
    avg(f.sale_price_usd) as avg_sale_price_usd
from {{ ref('fct_menu_items') }} f
left join {{ ref('dim_item_categories') }} c
    on f.item_category_id = c.item_category_id
group by
    f.item_category_id,
    c.item_category
