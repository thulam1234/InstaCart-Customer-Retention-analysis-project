## Instacart analysis using SQL 

--- checking for nulls and duplicates values 

SELECT *
FROM order_products op 
LIMIT 10;
---this table contains order_id, product_id, add_to_cart_order, reordered 
--- need this to calculate reorder rate per product
--- checking for overall quality for oder_product table 

SELECT COUNT(order_id) AS count_order,
	   COUNT (DISTINCT(product_id))AS count_product_id,
	   COUNT(add_to_cart_order) AS Count_cart_item,
	   COUNT(reordered) AS count_reorder 
FROM order_products op ; ---- N0 missing value 
---- checking nulls values for this one
--- one order can have multiple product 
--- check unique value for these order 

SELECT *
FROM aisles a 
LIMIT 10;
--- this table contains aisle 
--- check which product belongs to which aisle 

SELECT COUNT (aisle_id) AS count_ailse ,
COUNT(aisle) AS ailse_count
FROM aisles a ; --- no duplicate or null values 

SELECT * 
FROM departments d 
LIMIT 10; --- this table contains department 

SELECT COUNT(department_id) AS department_total,
       COUNT (department) As count_department
FROM departments d ;--- 21 departments

SELECT *
FROM products p 
LIMIT 10; 
--- This table contains aisle_id, department_id and product_id 
---Can use this table 

SELECT *
FROM products p 
WHERE department_id = 21;
--- Department 21 is missing department. it contains variety of products.

 
SELECT COUNT(DISTINCT(product_id)) AS total_product,
       COUNT(DISTINCT(product_name)) AS product_name ,
       COUNT(aisle_id) AS total_aisle,
       COUNT(department_id) AS department
FROM products p ;
---- 27249 

SELECT *
FROM orders o 
LIMIT 10; 
--This table contains order_id. Can join to find out reorder rate during specific hour of the day 

SELECT COUNT(days_since_prior_order) AS count_days,
       COUNT(DISTINCT(order_hour_of_day)) AS count_hour,
       COUNT(DISTINCT(order_dow)) AS count_dow,
       COUNT(order_number) AS or_number,
       COUNT(eval_set) AS Count_evaluation,
       COUNT (DISTINcT(user_id)) AS user,
       COUNT(DISTINCT (order_id)) AS count_order ,
       AVG(days_since_prior_order) AS average_day_since_last_order
FROM orders o ;
--- 206209 total customer 
--- 24 hours/day 
--- 10.44~ 10 days since last purchase 

SELECT COUNT(*) AS expected_nulls
FROM orders
WHERE order_number = 1
AND days_since_prior_order IS NULL; --- No nulls found 

SELECT COUNT(*) - COUNT(days_since_prior_order) AS null_count
FROM orders;


SELECT *
FROM train_product tp 
LIMIT 10;
--- This is train dataset from Kaggel which was created for Basket analysis

--- No missing values found throughout all 6 tables 

---Data Explorations 
--- Instacart Traffic Purchase analysis 
---What is the busiest hour of the day?
SELECT  order_hour_of_day ,
COUNT(order_id) AS total_order
FROM orders
GROUP BY order_hour_of_day
ORDER BY COUNT(order_id) DESC; 
---- peak hour of thday with 288,418 order are around 10 a.m. Orders come in more from mid morning to late afternoon .
---Traffic slowing down after 8:00 p.m to 7:00 a.m. Traffic starts to pick up around 8:00 a.m to 8:00 p.m
-- summary:
---- Peak ordering window is 10AM-3PM accounting for
---- the majority of daily orders (288,418 at peak)
---- Lowest traffic is 12AM-6AM
---- Business recommendation: schedule more drivers between 10AM-3PM, reduce overnight staffing

---What are the top 20 order product?
SELECT COUNT(op.order_id ) AS total_order,p.product_name 
FROM order_products op  
INNER JOIN products p   
ON op.product_id   = p.product_id  
GROUP BY product_name
ORDER BY COUNT(op.order_id)DESC 
LIMIT 20;

---What are the top 10 reorderef rate per product?  
SELECT p.product_name  , ROUND(AVG(op.reordered ),2) AS average_reordered_rate 
FROM order_products op 
INNER JOIN products p  
ON op.product_id   = p.product_id  
GROUP BY p.product_name 
HAVING COUNT(op.order_id) > 100
ORDER BY average_reordered_rate DESC
LIMIT 10;

---Q3: What products and departments have the highest reorder rate?
SELECT department, ROUND(AVG(op.reordered),2) as average_reordered , COUNT(order_id) AS toal_order
FROM order_products op 
INNER JOIN products p 
ON op.product_id = p.product_id 
INNER JOIN  departments d 
ON d.department_id = p.department_id 
GROUP BY d.department 
ORDER BY average_reordered DESC;
--- What is the reoder rate during peak hours ?

---- What are the total order and reordered rate during peak hour by product? 

SELECT p.product_name,
       COUNT(op.order_id) AS total_orders,
       ROUND(AVG(op.reordered), 2) AS reorder_rate
FROM order_products op
INNER JOIN products p 
    ON op.product_id = p.product_id
INNER JOIN orders o 
    ON op.order_id = o.order_id
WHERE o.order_hour_of_day BETWEEN 10 AND 15
GROUP BY p.product_name
HAVING COUNT(op.order_id) > 100
ORDER BY reorder_rate DESC
LIMIT 10;
--- Top 3 products : Serenity Ultimate Extreme Overnight Pads, Clean & fresh 124 Loads Laundry and Maca Buttercups


--- how loyal is each customer? 

WITH customer_loyalty AS (SELECT user_id ,
COUNT(order_id) AS total_order ,
ROUND(AVG(days_since_prior_order), 1) AS avg_days_between_orders
FROM orders o 
GROUP BY user_id
)
SELECT user_id,
total_order,
avg_days_between_orders ,
CASE WHEN 
total_order > 50 AND avg_days_between_orders < 10 THEN 'High'
WHEN total_order > 20  AND avg_days_between_orders < 20 THEN 'Medium'
ELSE 'Low'
END AS Loyalty_tier
FROM customer_loyalty
ORDER BY total_order  DESC;

--- categorized customer based on their purchase pattern 

--- categorized customer based on their purchase pattern 
