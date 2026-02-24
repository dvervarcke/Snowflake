select distinct
    menu_id,
    menu_type_id,
    menu_type
from {{ ref('stg_menu') }}
where menu_id is not null

