import pandas as pd
file = pd.read_csv('Sample - Superstore.csv', encoding='latin1')
print(file.columns.tolist())
print(file.head())
print(file.shape)
print(file.dtypes)
print(file.isnull().sum())
print(file.duplicated().sum())