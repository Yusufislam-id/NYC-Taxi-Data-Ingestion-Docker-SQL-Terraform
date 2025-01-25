-- NO. 3
--Trip Segmentation Count
SELECT COUNT(*)
FROM green_taxi_data
WHERE trip_distance > 1 AND trip_distance <= 3

-- trip_distance <= 1
-- trip_distance > 1 AND trip_distance <= 3
-- trip_distance > 3 AND trip_distance <= 7
-- trip_distance > 7 AND trip_distance <= 10
-- trip_distance > 10

-- or
SELECT 
    CASE
        WHEN trip_distance <= 1 THEN 'Up to 1 mile'
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1-3 miles'
        WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3-7 miles'
        WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7-10 miles'
        ELSE 'More than 10 miles'
    END AS trip_category,
    COUNT(*) AS trip_count
FROM green_taxi_data
GROUP BY 
    CASE
        WHEN trip_distance <= 1 THEN 'Up to 1 mile'
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1-3 miles'
        WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3-7 miles'
        WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7-10 miles'
        ELSE 'More than 10 miles'
    END
ORDER BY trip_count DESC;

-- result
-- "trip_category"	"trip_count"
-- "1-3 miles"	199013
-- "3-7 miles"	109645
-- "Up to 1 mile"	104838
-- "More than 10 miles"	35202
-- "7-10 miles"	27688

-- NO. 4
--Longest trip for each day
SELECT lpep_pickup_datetime, trip_distance
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
AND lpep_pickup_datetime < '2019-11-01'
ORDER BY trip_distance DESC
LIMIT 1

-- or
SELECT lpep_pickup_datetime, trip_distance
FROM green_taxi_data
WHERE trip_distance = (SELECT MAX(trip_distance) FROM green_taxi_data);

-- NO. 5
--Three biggest pickup zones
SELECT taxi_zone_lookup."Zone", SUM(total_amount) AS total_amounts
FROM green_taxi_data
INNER JOIN taxi_zone_lookup
ON green_taxi_data."PULocationID" = taxi_zone_lookup."LocationID"
WHERE green_taxi_data.lpep_pickup_datetime >= ('2019-10-18 00:00:00')
AND green_taxi_data.lpep_pickup_datetime < ('2019-10-19 00:00:00')
GROUP BY "taxi_zone_lookup"."Zone"
ORDER BY total_amounts DESC
LIMIT 3

-- NO. 6
---Largest tip
SELECT t2."Zone" AS DropOffZone, MAX(g.tip_amount) AS LargestTip
FROM green_taxi_data AS g
JOIN taxi_zone_lookup AS t1
ON g."PULocationID" = t1."LocationID"
JOIN taxi_zone_lookup AS t2
ON g."DOLocationID" = t2."LocationID"
WHERE t1."Zone" = 'East Harlem North'
GROUP BY DropOffZone
ORDER BY LargestTip DESC
LIMIT 1;