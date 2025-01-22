# NYC Taxi Data Ingestion and Analysis

## Overview

This project involves setting up a Dockerized PostgreSQL database for NYC taxi data, creating a data pipeline, performing analysis, and deploying infrastructure using Terraform. The README provides step-by-step instructions and queries for various tasks.

### docker run container taxi_ingest for green_trip_data

```
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"

docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_data \
    --url=${URL}
```

Dockerfile

```
FROM python:3.12.8

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app

COPY ingest_data.py ingest_data.py

ENTRYPOINT [ "python", "ingest_data.py" ]
```

### docker run container taxi_ingest for taxi_zone_lookup

```
docker build -t taxi_ingest:v002 .

```

```
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

docker run -it \
  --network=nyc-taxi-data-ingestion-docker-sql-terraform_pg-network \
  taxi_ingest:v002 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=taxi_zone_lookup \
    --url=${URL}
```

note: change network if you use docker-compose with apropriate network, use docker network ls to look up. i.e nyc-taxi-data-ingestion-docker-sql-terraform_pg-network

Dockerfile

```
FROM python:3.12.8

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app

COPY ingest_taxi_zone.py ingest_taxi_zone.py

ENTRYPOINT [ "python", "ingest_taxi_zone.py" ]
```
