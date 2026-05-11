import numpy as np 
import pandas as pd 
# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))
import matplotlib.pyplot as plt
import seaborn as sns
#import neccesary packages for the analysis
#upload aisles dataset
aisles = pd.read_csv('/kaggle/input/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset/aisles.csv')
#Upload department dataset 
departments = pd.read_csv('/kaggle/input/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset/departments.csv')
#upload order_products dataset 
order_products  = pd.read_csv('/kaggle/input/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset/order_products__prior.csv')
#upload orders dataset
orders = pd.read_csv('/kaggle/input/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset/orders.csv')
#upload product dataset
products = pd.read_csv ('/kaggle/input/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset/products.csv')

#Exploring each dataset
aisles.head()
departments.head()
#Exploring the most important dataset - orders 
orders.head()
orders.tail()
#Data exploratory 
plt.figure(figsize=(12,5))
sns.countplot(x="order_dow", data=orders, palette="magma")
plt.title("Order by day of the week, 0=Sat, 1=Sun")
# Saturday and Sunday have the most order 
plt.figure(figsize=(12,5))
sns.countplot(x='order_hour_of_day', data=orders,color='skyblue')
plt.title("Order by time of day")
#10-3 p.m peak order > 200 order per hour 
plt.figure(figsize=(12,5))
sns.countplot(x='days_since_prior_order', data=orders, color='skyblue')
plt.xticks(rotation='vertical')
plt.title("Days Since Prior Order")
#peak order in day 7 and day 30 
