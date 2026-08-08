CREATE TABLE dim_customer (
	customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(40),
    segment VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    region VARCHAR(20)
);

CREATE TABLE dim_product (
	product_id VARCHAR(20) PRIMARY KEY,
	category VARCHAR(30),
	sub_category VARCHAR(30),
	product_name VARCHAR (160)
);

CREATE TABLE fact_order (
	row_id INTEGER PRIMARY KEY,
	order_id VARCHAR(20),
	order_date DATE,
	ship_date DATE,
	ship_mode VARCHAR(20),
	customer_id VARCHAR(10) REFERENCES dim_customer(customer_id),
	product_id VARCHAR(20) REFERENCES dim_product(product_id),
	sales NUMERIC(10,4),
	quantity INTEGER,
	discount NUMERIC(4,2),
	profit NUMERIC(10,4)
);