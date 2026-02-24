select distinct
    menu_type_id,
    menu_type
from {{ ref('stg_menu') }}
where menu_type_id is not null

