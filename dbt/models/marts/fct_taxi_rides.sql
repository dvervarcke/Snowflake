select
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    fare_amount,
    pickup_zip,
    dropoff_zip,
    datediff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) as trip_minutes
from {{ ref('stg_nyctaxi_trips') }}
where tpep_dropoff_datetime is not null

