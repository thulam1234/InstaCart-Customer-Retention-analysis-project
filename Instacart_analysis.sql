--- Instacart analysis using SQL - Customer retention and reroder behavior analysis 

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
FROM order_products op ; -- N0 missing value 
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
--- this table contains ailse 

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
--- days_since_prior_order contains null values on every first purchase, there is no reorder in the first purchase 

SELECT COUNT(*) AS expected_nulls
FROM orders
WHERE order_number = 1
AND days_since_prior_order IS NULL; --- No nulls found 

SELECT COUNT(*) - COUNT(days_since_prior_order) AS null_count
FROM orders;



--- No missing values found throughout all 6 tables 
--- General data exploration 
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
---What are the top 10 reordered rate per product?  

SELECT 
    p.product_name, 
    ROUND(AVG(op.reordered), 2) AS average_reordered_rate,  
    COUNT(op.order_id) AS total_orders,
    RANK() OVER (ORDER BY AVG(op.reordered) DESC) AS reorder_rank
FROM order_products op 
INNER JOIN products p ON op.product_id = p.product_id  
GROUP BY p.product_name 
HAVING COUNT(op.order_id) > 100
ORDER BY average_reordered_rate DESC 
LIMIT 10; 
--- most of the top orders are organic products or daily use products which suggesting that consumer might be busy people who is lookign ways to stay healthy 
--- it's critical to segment and provide appropriate recommendation to retain customers---> we can explore basket size from the top users 
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
---Loyalty analysis 

SELECT 
    order_number,
    COUNT(DISTINCT user_id) AS customers_at_this_order
FROM orders
WHERE order_number <= 20
GROUP BY order_number
ORDER BY order_number; --- Instacart loses ~10% of customers after the 4th order. Why, and how do we stop it 

WITH customer_max AS (
    SELECT user_id, MAX(order_number) AS last_order
    FROM orders
    GROUP BY user_id
),
customer_type AS (
    SELECT o.user_id,
           CASE WHEN cm.last_order >= 6 THEN 'Stayed' 
                ELSE 'Dropped' END AS status,
           COUNT(DISTINCT p.department_id) AS dept_count,
           COUNT(op.product_id) AS cart_size,
           ROUND(AVG(op.reordered), 2) AS reorder_rate
    FROM orders o
    INNER JOIN customer_max cm ON o.user_id = cm.user_id
    INNER JOIN order_products op ON o.order_id = op.order_id
    INNER JOIN products p ON op.product_id = p.product_id
    WHERE o.order_number <= 4
    GROUP BY o.user_id, status
)
SELECT status,
       COUNT(*) AS customers,
       ROUND(AVG(dept_count), 1) AS avg_departments,
       ROUND(AVG(cart_size), 1) AS avg_cart_size,
       ROUND(AVG(reorder_rate), 2) AS avg_reorder_rate
FROM customer_type
GROUP BY status;
--- customers who stayed order 22% more than custoemr who dropped, which indicates that customer who is loyal to instacart te
---tends to be people who order in bulk 

