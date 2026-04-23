import pandas as pd
from sqlalchemy import create_engine, text
import os

PG_CONN = os.getenv(
    "PG_CONN",
    "postgresql://postgres:postgres@localhost:5433/maven_toys"
)
engine = create_engine(PG_CONN)
# Connection check
#with engine.connect() as conn:
#    result = conn.execute(text("SELECT current_database()"))
#    print(result.fetchone())

df = pd.read_csv("data/products.csv")

#Csv read check
#print(df.head())
#print(df.dtypes)

#products table normalization
df["Product_Cost"] = df["Product_Cost"].str.replace("$", "", regex=False).str.strip().astype(float)
df["Product_Price"] = df["Product_Price"].str.replace("$", "", regex=False).str.strip().astype(float)
df.columns = [c.lower() for c in df.columns]
#print(df.dtypes)

#products table loader
with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE raw.products RESTART IDENTITY CASCADE"))
df.to_sql(
    "products",
    engine,
    schema="raw",
    if_exists="append",
    index=False,
)

#stores table read and check
df = pd.read_csv("data/stores.csv")
#read check
#print(df.head())
#print(df.dtypes)
df["Store_Open_Date"] = pd.to_datetime(df["Store_Open_Date"]).dt.date
df.columns = [c.lower() for c in df.columns]

with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE raw.stores RESTART IDENTITY CASCADE"))
df.to_sql(
    "stores",
    engine,
    schema="raw",
    if_exists="append",
    index=False,
)

# Calendar
df = pd.read_csv("data/calendar.csv")
#read check
#print(df.head())
#print(df.dtypes)
df["Date"]=pd.to_datetime(df["Date"], format="%m/%d/%Y").dt.date
df = df.rename(columns = {"Date": "cal_date"})
# calendar load
with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE raw.calendar RESTART IDENTITY CASCADE"))
df.to_sql(
    "calendar",
    engine,
    schema="raw",
    if_exists="append",
    index=False,
)

#inventory table 
df = pd.read_csv("data/inventory.csv")
#read check
#print(df.head())
#print(df.dtypes)
df.columns = [c.lower() for c in df.columns]

#inventory table load
with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE raw.inventory RESTART IDENTITY CASCADE"))
df.to_sql(
    "inventory",
    engine,
    schema="raw",
    if_exists="append",
    index=False,
)

# Sales table
df = pd.read_csv("data/sales.csv")
# read check
# print(df.head())
# print(df.dtypes)
df["Date"] = pd.to_datetime(df["Date"]).dt.date
df = df.rename(columns = {"Date": "sale_date"})
df.columns = [c.lower() for c in df.columns]

# sale table chucksize load
with engine.begin() as conn:
    conn.execute(text("TRUNCATE TABLE raw.sales RESTART IDENTITY CASCADE"))
df.to_sql(
    "sales",
    engine,
    schema="raw",
    if_exists="append",
    index=False,
    chunksize=50_000
)