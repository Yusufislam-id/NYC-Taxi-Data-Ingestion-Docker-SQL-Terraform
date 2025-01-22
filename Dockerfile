FROM python:3.12.8

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app

COPY ingest_taxi_zone.py ingest_taxi_zone.py

ENTRYPOINT [ "python", "ingest_taxi_zone.py" ]