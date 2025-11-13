import pandas as pd
from sqlalchemy import create_engine
import os

def load_csv_to_postgres(csv_path, table_name):
    db_url = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost:5432/de_portfolio")
    engine = create_engine(db_url)
    df = pd.read_csv(csv_path)
    df.to_sql(table_name, engine, if_exists="replace", index=False)
    print(f"Loaded {len(df)} rows into {table_name}")

if __name__ == "__main__":
    load_csv_to_postgres("../../data/sample_sales.csv", "sales")
