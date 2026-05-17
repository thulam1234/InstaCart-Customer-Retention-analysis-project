## Instacart analysis project 

###Instacart business analysis (SQL/Python/ Tableau) 

## Executive summary: 
Analyze instacart data from 2017 with more than 3M+ orders to identify purchase pattern and customer purchase behavior

## Objective:
To discern purchasing patterns, we can identify actionable steps to retain customers by optimizing product recommendations, marketing strategies, and promotional techniques.

## Overview:
Instacart, an American grocery technology company and marketplace, facilitates same-day delivery and pickup services from retailers. Its primary objective is to provide delivery options for individuals seeking an efficient and expedited means of obtaining groceries from various grocery stores. Customer retention is paramount for driving business growth and revenue generation. By comprehending customer churn patterns, businesses can identify critical factors that influence customer segmentation and user understanding. This knowledge enables businesses to discern the factors that retain customers and the reasons behind customer attrition. 

## Data overview: 

- order_id : Foreign key linking to each order
- product_id: Foreign key linking to each product
- add_to_cart: sequence in which product was added to card within that order
- reordered: whether or not the customer ordered the product again

# Entity: orders 

- order_id: unique identifier for each order
- user_id: unique identifier for each customer
- eval_set: prior set of data collected
- order_number : sequence count per customer
- order_dow: day of the week the order was placed
- order_hours_of_day: hour of the day the order was purchased
- days_since_prior_order : days since last order

# Entity: product 

- product_id: unique identifier of each product
- product_name : product’s name
- aisle_id : foreign key linking to aisles table
- department_id : foreign key linking to department table

<img width="1011" height="711" alt="Screenshot 2026-04-11 at 1 35 51 PM" src="https://github.com/user-attachments/assets/4ac0f79b-df51-44fb-b473-9c3c23ab25aa" />


## Analysis and busines questions:
#### Exploratory analysis using Python 
  <img width="907" height="399" alt="Screenshot 2026-05-16 at 9 28 58 PM" src="https://github.com/user-attachments/assets/35fa2407-f6da-4c1c-8f81-7519b6967183" />
     There’s a substantial high volume of orders throughout the week, particularly during weekends. Weekdays, on the other hand, have a stable volume of purchases. This can indicate the need for drivers to be more attentive and helpful on weekends to retain customers. Orders peak up to 60,000 on Saturday, which is around 25% more than the weekday average, which requires       roughly around 15%-20% more drivers.
  
  <img width="888" height="414" alt="Screenshot 2026-05-16 at 9 46 28 PM" src="https://github.com/user-attachments/assets/02c348fb-649b-4e83-8b6b-486182a84e0e" />
  
  High volume of purchases occurs around 10 a.m. to 3 p.m. During this time, it’s crucial to allocate sufficient drivers to ensure prompt delivery. Further analysis can involve optimizing driver routes to enhance service efficiency. Additionally, we can introduce an app feature that allows customers to select the preferred drop-off time, considering factors like the number of drivers, costs, and revenue. 60% of the total orders occur around 10 a.m. to 3 p.m. with peak orders at 10 a.m. 
  
  <img width="949" height="409" alt="Screenshot 2026-05-16 at 9 49 33 PM" src="https://github.com/user-attachments/assets/cf0a57e9-1f92-4052-a63c-e039d1dc06d3" />
 The interval between consecutive orders is the number of days between the previous order and the next one. From the graph, we can see that customers tend to place another order after seven days and 14 days. The longest interval between orders is 30 days, which indicates that the application may be experiencing performance issues when the gap between orders is 30 days.

 ### Retention analysis using SQL
 1. What is retention rate by order number?
    <img width="634" height="215" alt="Screenshot 2026-05-16 at 11 13 51 PM" src="https://github.com/user-attachments/assets/e87a2b55-dd71-4ae5-96f0-c0a109713a7e" />
    Retention dropped on average 10% after the fourth order, which suggesting that customer stopped or paused using the service after the fourth may caused by 


 ### Classication and clustering model using Python 

## Key Insights :

## Recommendation: 

## Dashboard:

Limitation:
- The dataset lacks revenue, cost, and profit information, hindering the comprehensive analysis of the current financial health and effectiveness of marketing strategies.
- Furthermore, the dataset does not include customer reviews, which prevents a deeper understanding of the reasons behind customer discontinuation of service usage.
- Conducting a survey would provide valuable insights into the reasons behind customer service discontinuation, including personal reasons and delivery inefficiencies.



Tools used :
- SQL
- Python
- Tableau 

## Table of Contents 
Instacart Analysis 
- Readme.md/final report
- SQL data analysis
- Python statistical analysis
- Tableau 
