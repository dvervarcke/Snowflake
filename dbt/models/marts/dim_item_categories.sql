select distinct
    md5(upper(coalesce(item_category, 'UNKNOWN'))) as item_category_id,
    item_category
from {{ ref('stg_menu') }}
where item_category is not null

