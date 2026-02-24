select distinct
    md5(upper(coalesce(item_subcategory, 'UNKNOWN'))) as item_subcategory_id,
    md5(upper(coalesce(item_category, 'UNKNOWN'))) as item_category_id,
    item_subcategory
from {{ ref('stg_menu') }}
where item_subcategory is not null

