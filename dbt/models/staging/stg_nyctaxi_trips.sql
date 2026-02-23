with source_trips as (
    select
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        fare_amount,
        pickup_zip,
        dropoff_zip
    from {{ source('nyctaxi', 'trips') }}
)

select
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    fare_amount,
    cast(pickup_zip as varchar) as pickup_zip,
    cast(dropoff_zip as varchar) as dropoff_zip
from source_trips
where tpep_pickup_datetime is not null
