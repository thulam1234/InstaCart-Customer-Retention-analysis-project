Instacart analysis project 

#Instacart business analysis (SQL/Python/ Tableau) 

Executive summary: 

Objective:
To identify purchase pattern throughout the day to adjust driver scheduling 

Objective:
Analyze isntacart data from 2017 with more than 3M+ orders to indentify purchase patterna and customer purchase behavior

Business overview: 
Instacart is an American grocery technology company and marketplace that facilitates same-day delivery and pickup services from retailers. 

Data overview: 

Entity : aisle 

- aisle_id : unique identifier for each aisle
- aisle: name of the aisle category

Entity : Department 

- department_id: unique identifier for each department
- department : Name of department

Entity: order_product

- order_id : Foreign key linking to each order
- product_id: Foreign key linking to each product
- add_to_cart: sequence in which product was added to card within that order
- reordered: whether or not the customer ordered the product again

Entity: orders 

- order_id: unique identifier for each order
- user_id: unique identifier for each customer
- eval_set: prior set is data collated
- order_number : sequence count per customer
- order_dow: day of week the order was placed
- order_hours_of_day: hour of the day the order were purchased
- days_since_prior_order : days since last order

Entity: product 

- product_id: unique identifier of each product
- product_name : product’s name
- aisle_id : foreign key linking to aisles table
- department_id : foreign key linking to department table

<img width="1011" height="711" alt="Screenshot 2026-04-11 at 1 35 51 PM" src="https://github.com/user-attachments/assets/4ac0f79b-df51-44fb-b473-9c3c23ab25aa" />


Analysis and findings:

Key Insights :

Recommendation: 

Dashboard:

Limitation:
- Dataser does not include revenue, cost and profit to further analyze the current fianncial health and effectiveness of marketing stretegies



Dashboard:

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
