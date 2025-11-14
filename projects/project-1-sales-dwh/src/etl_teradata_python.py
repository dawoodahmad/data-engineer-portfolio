import os
import pandas as pd
import teradatasql
import json

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(BASE_DIR, "..", "data", "sample_sales.csv")

with open("config.json") as f:
    config = json.load(f)

host = config["host"]
user = config["user"]
password = config["password"]
database = config["database"]

def load_csv_to_teradata():
    df = pd.read_csv(CSV_PATH)

    with teradatasql.connect(host=host, user=user, password=password) as con:
        cur = con.cursor()
        for _, row in df.iterrows():
            cur.execute("""
                INSERT INTO Sales (order_id, order_date, customer_id, amount)
                VALUES (?, ?, ?, ?)
            """, [int(row.order_id), row.order_date, int(row.customer_id), float(row.amount)])
    print("Loaded data into Teradata")

if __name__ == "__main__":
    load_csv_to_teradata()
