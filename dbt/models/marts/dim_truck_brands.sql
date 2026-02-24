select distinct
    truck_brand_name
from {{ ref('stg_menu') }}
where truck_brand_name is not null

