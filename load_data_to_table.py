import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
import pandas as pd

load_dotenv()

DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_USER = os.getenv('DB_USER')
DB_HOST = os.getenv('DB_HOST')
DB_NAME = os.getenv('DB_NAME')
DB_PORT = os.getenv('DB_PORT')

tables = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')
file = pd.read_csv('Sample - Superstore.csv', encoding='latin1', dtype={'Postal Code': str})

file['Order Date'] = pd.to_datetime(file['Order Date'], format='%m/%d/%Y')
file['Ship Date'] = pd.to_datetime(file['Ship Date'], format='%m/%d/%Y')

dim_customer = file[['Customer ID', 'Customer Name', 'Segment', 'Country', 'City', 'State',
                     'Postal Code', 'Region']].drop_duplicates(subset='Customer ID')
dim_customer.columns = ['customer_id', 'customer_name', 'segment', 'country', 'city',
                        'state', 'postal_code', 'region']
dim_customer.to_sql('dim_customer', tables, if_exists='append', index=False)

dim_product = file[['Product ID', 'Category', 'Sub-Category', 'Product Name']].drop_duplicates(subset='Product ID')
dim_product.columns = ['product_id', 'category', 'sub_category', 'product_name']
dim_product.to_sql('dim_product', tables, if_exists='append', index=False)

fact_order = file[['Row ID', 'Order ID', 'Order Date', 'Ship Date', 'Ship Mode',
                    'Customer ID', 'Product ID', 'Sales', 'Quantity', 'Discount', 'Profit']]
fact_order.columns = ['row_id', 'order_id', 'order_date', 'ship_date', 'ship_mode',
                       'customer_id', 'product_id', 'sales', 'quantity', 'discount', 'profit']
fact_order.to_sql('fact_order', tables, if_exists='append', index=False)