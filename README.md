## Instacart analysis project 

#Instacart business analysis (SQL/Python/ Tableau) 

## Executive summary: 
Analyze instacart data from 2017 with more than 3M+ orders to indentify purchase pattern and customer purchase behavior

## Objective:
To identify purchase pattern throughout the day to adjust driver scheduling 

## Business overview: 
Instacart is an American grocery technology company and marketplace that facilitates same-day delivery and pickup services from retailers. 

## Data overview: 

#Entity : aisle 

- aisle_id : unique identifier for each aisle
- aisle: name of the aisle category

#Entity : Department 

- department_id: unique identifier for each department
- department : Name of department

#Entity: order_product

- order_id : Foreign key linking to each order
- product_id: Foreign key linking to each product
- add_to_cart: sequence in which product was added to card within that order
- reordered: whether or not the customer ordered the product again

#Entity: orders 

- order_id: unique identifier for each order
- user_id: unique identifier for each customer
- eval_set: prior set is data collected
- order_number : sequence count per customer
- order_dow: day of week the order was placed
- order_hours_of_day: hour of the day the order were purchased
- days_since_prior_order : days since last order

#Entity: product 

- product_id: unique identifier of each product
- product_name : product’s name
- aisle_id : foreign key linking to aisles table
- department_id : foreign key linking to department table

<img width="1011" height="711" alt="Screenshot 2026-04-11 at 1 35 51 PM" src="https://github.com/user-attachments/assets/4ac0f79b-df51-44fb-b473-9c3c23ab25aa" />


## Analysis and findings:
#### Exploratory analysis using Python 
  <img width="907" height="399" alt="Screenshot 2026-05-16 at 9 28 58 PM" src="https://github.com/user-attachments/assets/35fa2407-f6da-4c1c-8f81-7519b6967183" />
     There’s a substantial high volume of orders throughout the week, particularly during weekends. Weekdays, on the other hand, have a stable volume of purchases. This can indicate the need for drivers to be more attentive and helpful on weekends to retain customers. Orders peak up to 60,000 on Saturday, which is around 25% more than weekday average, which requires       roughly around 15%-20% more drivers.
  
  <img width="888" height="414" alt="Screenshot 2026-05-16 at 9 46 28 PM" src="https://github.com/user-attachments/assets/02c348fb-649b-4e83-8b6b-486182a84e0e" />
  
  High volume of purchases occurs around 10 a.m. to 3 p.m. During this time, it’s crucial to allocate sufficient drivers to ensure prompt delivery. Further analysis can involve optimizing driver routes to enhance service efficiency. Additionally, we can introduce an app feature that allows customers to select the preferred drop-off time, considering factors like the number of drivers, costs, and revenue. 60% of the total order is around 10 a.m. to 3 p.m. with peak order at 10 a.m. 
  
  <img width="949" height="409" alt="Screenshot 2026-05-16 at 9 49 33 PM" src="https://github.com/user-attachments/assets/cf0a57e9-1f92-4052-a63c-e039d1dc06d3" />
 The interval between consecutive orders is the number of days between the previous order and the next one. From the graph, we can see that customers tend to place another order after seven day and 14 days days. The longest interval between orders is 30 days, which indicates that the application may be experiencing performance issues when the gap between orders is 30 days.

## Key Insights :

## Recommendation: 

## Dashboard:

Limitation:
- Dataset does not include revenue, cost and profit to further analyze the current fianncial health and effectiveness of marketing stretegies




Tools used :
- SQL
- Pyhthon
- Tableau 

## Table of content 
instacart analysis 
- Readme.md/final report
- SQL data analysis
- Python statiscal analysis
- Tableau 
