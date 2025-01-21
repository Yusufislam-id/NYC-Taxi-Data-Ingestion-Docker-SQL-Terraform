-- NO. 3

SELECT
     COUNT(*) AS trip_count
 FROM
     green_taxi
 WHERE
     lpep_pickup_datetime >= '2019-10-01' AND
     lpep_pickup_datetime < '2019-11-01' AND trip_distance <= 1

SELECT
    SUM(trip_count) AS total_trip_count
FROM (
    SELECT
        DATE(lpep_pickup_datetime) AS pickup_date,
        COUNT(*) AS trip_count
    FROM
        green_taxi
    WHERE
        lpep_pickup_datetime >= '2019-10-01' AND
        lpep_pickup_datetime < '2019-11-01' AND
        trip_distance <= 1
    GROUP BY
        DATE(lpep_pickup_datetime)
) AS daily_trip_counts;


-- NO. 4


-- NO. 5

SELECT Zone, SUM(total_amount) AS total_amounts
FROM `ny_taxi.green_tripdata_2019-10`
INNER JOIN `ny_taxi.taxi_zone_lookup`
ON PULocationID = LocationID
WHERE lpep_pickup_datetime >= ('2019-10-18 00:00:00')
AND lpep_pickup_datetime < ('2019-10-19 00:00:00')
GROUP BY Zone
ORDER BY total_amounts DESC

-- NO. 6

SELECT 
  t2.Zone AS DropOffZone,
  MAX(g.tip_amount) AS LargestTip
FROM 
  `ny_taxi.green_tripdata_2019-10` AS g
JOIN 
  `ny_taxi.taxi_zone_lookup` AS t1
  ON g.PULocationID = t1.LocationID
JOIN 
  `ny_taxi.taxi_zone_lookup` AS t2
  ON g.DOLocationID = t2.LocationID
WHERE 
  t1.Zone = 'East Harlem North'
GROUP BY 
  DropOffZone
ORDER BY 
  LargestTip DESC
LIMIT 1;