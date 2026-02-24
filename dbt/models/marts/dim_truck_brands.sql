select distinct
    md5(upper(coalesce(truck_brand_name, 'UNKNOWN'))) as truck_brand_id,
    truck_brand_name
from {{ ref('stg_menu') }}
where truck_brand_name is not null
