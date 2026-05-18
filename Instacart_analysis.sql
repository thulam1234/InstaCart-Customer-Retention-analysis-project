--- Instacart analysis using SQL - Customer retention and reroder behavior analysis 

# Instacart analysis using SQL 

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
--- Traffic slowing down after 8:00 p.m to 7:00 a.m. Traffic starts to pick up around 8:00 a.m to 8:00 p.m
-- summary:
---- Peak ordering window is 10AM-3PM accounting for
---- the majority of daily orders (288,418 at peak)
---- Lowest traffic is 12AM-6AM
---- Business recommendation: schedule more drivers between 10AM-3PM, reduce overnight staffing


---What are the top 10 reordered rate per product?  
SELECT
    p.product_name,
    COUNT(op.order_id) AS total_orders,
    ROUND(AVG(op.reordered), 2) AS reorder_rate,
    -- Composite score: combines volume and reorder rate
    ROUND(COUNT(op.order_id) * AVG(op.reordered), 2) AS power_score
FROM order_products op
INNER JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name
HAVING COUNT(op.order_id) > 100  -- Filter for statistical significance
ORDER BY power_score DESC  -- Rank by combined impact
LIMIT 30;
---Q3: What products and departments have the highest reorder rate?
SELECT department, ROUND(AVG(op.reordered),2) as average_reordered , COUNT(order_id) AS total_order
FROM order_products op 
INNER JOIN products p 
ON op.product_id = p.product_id 
INNER JOIN  departments d 
ON d.department_id = p.department_id 
GROUP BY d.department 
ORDER BY average_reordered DESC
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
--- customers who stayed order 22% more than customer who dropped, which indicates that customer who is loyal to instacart te
---tends to be people who order in bulk 

SELECT 
    CASE WHEN cm.last_order >= 6 THEN 'Stayed' ELSE 'Dropped' END AS status,
    o.order_number,
    AVG(o.days_since_prior_order) AS avg_days_gap
FROM orders o
INNER JOIN (SELECT user_id, MAX(order_number) AS last_order 
            FROM orders GROUP BY user_id) cm 
    ON o.user_id = cm.user_id
WHERE o.order_number BETWEEN 2 AND 5
GROUP BY status, o.order_number
ORDER BY status, o.order_number;

--- those who stayed takes less time to reorder compare to those who churned 
-- Reorder rate by order number for stayed vs dropped
SELECT 
    CASE WHEN cm.last_order >= 6 THEN 'Stayed' ELSE 'Dropped' END AS status,
    o.order_number,
    AVG(op.reordered) AS avg_reorder_rate,
    COUNT(DISTINCT o.user_id) AS customers
FROM orders o
INNER JOIN (SELECT user_id, MAX(order_number) AS last_order 
            FROM orders GROUP BY user_id) cm 
    ON o.user_id = cm.user_id
INNER JOIN order_products op ON o.order_id = op.order_id
WHERE o.order_number <= 5
GROUP BY status, o.order_number;
--- Those who stayed are more likely to reordered the items compared to those who don't 
--- What % of customers only order once? 
-- Find customers who have NEVER reordered any product
-- Calculate % of customers with no reorders

WITH customer_reorder_status AS (
    SELECT 
        o.user_id,
        SUM(op.reordered) AS total_reordered_items,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    INNER JOIN order_products op ON o.order_id = op.order_id
    GROUP BY o.user_id
)SELECT 
    COUNT(CASE WHEN total_reordered_items = 0 THEN 1 END) AS customers_no_reorders,
    COUNT(*) AS total_customers,
    ROUND(COUNT(CASE WHEN total_reordered_items = 0 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS pct_no_reorders
FROM customer_reorder_status;

--- 3046 out of 206209 customers have not reorderd. About 1.46 have not reordered since their last purchase 
---Which products drive both loyalty and revenue 
-- Products with high reorder rate AND high volume
SELECT
    p.product_name,
    COUNT(op.order_id) AS total_orders,
    ROUND(AVG(op.reordered), 2) AS reorder_rate,
    ROUND(COUNT(op.order_id) * AVG(op.reordered), 2) AS power_score
FROM order_products op
INNER JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name
HAVING COUNT(op.order_id) > 100
ORDER BY power_score DESC
LIMIT 20;

--- our power products are mostly organic fresh produce and healhty choices , which has high volume of order and high reorder rate 

-- segment into different churn risk
WITH customer_reorder_status AS(
    SELECT 
        o.user_id,
        SUM(op.reordered) AS total_reordered_items,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    INNER JOIN order_products op ON o.order_id = op.order_id
    GROUP BY o.user_id
)
SELECT 
    CASE 
        WHEN total_orders = 1 THEN '1 order (one-time)'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 orders'
        WHEN total_orders BETWEEN 4 AND 10 THEN '4-10 orders'
        ELSE '10+ orders'
    END AS order_group,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_reordered_items), 2) AS avg_reordered_items
FROM customer_reorder_status
WHERE total_reordered_items = 0  -- Only customers with no reorders
GROUP BY order_group
ORDER BY MIN(total_orders);

---2115 people customer ordered 2-3 times with no reorder items in their repeated purchase 
--- 930 customers ordered 4-10 times but no reordered 

---What is the conversion rate from one order to the next?

SELECT 
    SUM(CASE WHEN max_order >= 1 THEN 1 ELSE 0 END) AS placed_order_1,
    SUM(CASE WHEN max_order >= 2 THEN 1 ELSE 0 END) AS placed_order_2,
    SUM(CASE WHEN max_order >= 5 THEN 1 ELSE 0 END) AS placed_order_5,
    ROUND(SUM(CASE WHEN max_order >= 2 THEN 1 ELSE 0 END) * 100.0 / 
          SUM(CASE WHEN max_order >= 1 THEN 1 ELSE 0 END), 2) AS conversion_1_to_2,
    ROUND(SUM(CASE WHEN max_order >= 5 THEN 1 ELSE 0 END) * 100.0 / 
          SUM(CASE WHEN max_order >= 1 THEN 1 ELSE 0 END), 2) AS conversion_1_to_5
FROM (
    SELECT user_id, MAX(order_number) AS max_order
    FROM orders
    GROUP BY user_id
) customer_lifetime;

--- conversation dropped by 2% from the first to fifth purchase. 

-- Calculate retention rate by order number
WITH retention AS (
    SELECT 
        order_number,
        COUNT(DISTINCT user_id) AS customers,
        LAG(COUNT(DISTINCT user_id)) OVER (ORDER BY order_number) AS prev_customers
    FROM orders
    WHERE order_number <= 10
    GROUP BY order_number
)
SELECT 
    order_number,
    customers,
    prev_customers,
    ROUND(100.0 * (prev_customers - customers) / prev_customers, 2) AS churn_rate_pct
FROM retention
WHERE order_number > 1
ORDER BY order_number;

-- Which departments have highest reorder rates?
SELECT 
    d.department,
    COUNT(DISTINCT op.order_id) AS total_orders,
    ROUND(AVG(op.reordered), 2) AS avg_reorder_rate
FROM order_products op
INNER JOIN products p ON op.product_id = p.product_id
INNER JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department
HAVING COUNT(DISTINCT op.order_id) > 1000
ORDER BY avg_reorder_rate DESC
LIMIT 10; --- Highest reorder rate is products that we use everyday such as dairy eggs, beverages and produce 
