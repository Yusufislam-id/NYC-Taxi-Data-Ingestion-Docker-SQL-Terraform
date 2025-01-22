import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    # Extract the file name from the URL
    csv_name = url.split('/')[-1]

    # Download the file using wget
    os.system(f"wget {url}")

    # Create a connection to the PostgreSQL database
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Read the CSV file in chunks
    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=1000)

    # Process the first chunk to create the table structure
    df = next(df_iter)
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    # Insert the first chunk
    df.to_sql(name=table_name, con=engine, if_exists='append')

    # Process the remaining chunks
    while True:
        try:
            t_start = time()
            df = next(df_iter)
            df.to_sql(name=table_name, con=engine, if_exists='append')
            t_end = time()
            print('Inserted another chunk, took %.3f seconds' % (t_end - t_start))
        except StopIteration:
            print("All data has been processed.")
            break


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='db name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will write the results to')
    parser.add_argument('--url', help='url of the csv file')

    args = parser.parse_args()

    main(args)
