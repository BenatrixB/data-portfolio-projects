-- Preperation for data load with python script.
/* Tables must be created in schema:
1. products
2. stores
3. calendar
4. inventory
5. sales
*/
-- Product table creation in schema
CREATE TABLE raw.products(
product_id INTEGER PRIMARY KEY,
product_name VARCHAR (100) NOT NULL,
product_category VARCHAR (100) NOT NULL,
product_cost NUMERIC (8,2) NOT NULL,
product_price NUMERIC (8,2) NOT NULL
);

-- Store table creation in schema
CREATE TABLE raw.stores(
store_id INTEGER PRIMARY KEY,
store_name VARCHAR (100) NOT NULL,
store_city VARCHAR (100) NOT NULL,
store_location VARCHAR (100) NOT NULL,
store_open_date DATE NOT NULL
);

-- calendar table creation in schema
CREATE TABLE raw.calendar(
cal_date DATE PRIMARY KEY
);

-- inventory table creation in schema
CREATE TABLE raw.inventory(
store_id INTEGER NOT NULL,
product_id INTEGER NOT NULL,
stock_on_hand INTEGER NOT NULL,
PRIMARY KEY(store_id, product_id)
);

-- sales fact table creation in schema
CREATE TABLE raw.sales(
sale_id INTEGER PRIMARY KEY,
sale_date DATE NOT NULL,
store_id INTEGER NOT NULL REFERENCES raw.stores(store_id),
product_id INTEGER NOT NULL REFERENCES raw.products(product_id),
units INTEGER NOT NULL
);


