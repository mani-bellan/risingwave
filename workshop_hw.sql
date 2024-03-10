CREATE MATERIALIZED VIEW highest_average_trip_time AS
select 
puzone.zone as pickup_zone, 
dozone.zone as dropoff_zone,
avg(td.tpep_dropoff_datetime-td.tpep_pickup_datetime) as average_trip_time,
max(td.tpep_dropoff_datetime-td.tpep_pickup_datetime) as max_trip_time
from 
trip_data td
join taxi_zone puzone
on td.PULocationID = puzone.location_id
join taxi_zone dozone
on td.DOLocationID = dozone.location_id
group by puzone.zone,dozone.zone
order by avg(td.tpep_dropoff_datetime-td.tpep_pickup_datetime) desc
limit 10;

CREATE MATERIALIZED VIEW total_trips_highest AS
select 
puzone.zone as pickup_zone,
dozone.zone dropoff_zone,
count(*) as total_trips
from
trip_data td
join taxi_zone puzone
on td.PULocationID = puzone.location_id
join taxi_zone dozone
on td.DOLocationID = dozone.location_id
where puzone.zone = 'Yorkville East' and dozone.zone = 'Steinway'
group by puzone.zone,dozone.zone
limit 10;

CREATE MATERIALIZED VIEW top_three_busiest AS
WITH lpt as
(
SELECT MAX(tpep_pickup_datetime) AS latest_pickup_time
FROM trip_data
)
select puzone.zone as pickup_zone,
count(*) as total_trips
from
lpt,
trip_data td
join taxi_zone puzone
on td.PULocationID = puzone.location_id
where 
td.tpep_pickup_datetime > (lpt.latest_pickup_time - INTERVAL '17' HOUR)
group by puzone.zone 
order by count(*) desc 
limit 5;