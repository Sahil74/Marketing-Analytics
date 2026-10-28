import psycopg
import pandas as pd
"""
with psycopg.connect(
    host="localhost",
    port=,
    dbname="",
    user="",
    password=""
) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM customers LIMIT 5;")
        for row in cur.fetchall():
            print(row)

"""

def get_connection():
    return psycopg.connect(
        host="localhost",
        port=,
        dbname="",
        user="",
        password=""
    )
