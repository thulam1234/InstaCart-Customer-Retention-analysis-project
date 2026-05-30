# Instacart Analysis Project

**Tools:** SQL · Python · Tableau

---

## Executive Summary

Analysis of Instacart's 2017 dataset (3M+ orders) to identify purchase patterns and customer behavior, with the goal of improving retention through optimized product recommendations, marketing strategies, and promotional techniques.

## Objective

To discern purchasing patterns, we can identify actionable steps to retain customers by optimizing product recommendations, marketing strategies, and promotional techniques.

## Overview

Instacart is an American grocery technology company that facilitates same-day delivery and pickup from retailers. Customer retention is paramount for driving business growth — by understanding churn patterns, businesses can identify what keeps customers engaged and why others leave.

---

## Data Overview

**Entity: order_products**

| Column | Description |
|--------|-------------|
| `order_id` | Foreign key linking to each order |
| `product_id` | Foreign key linking to each product |
| `add_to_cart` | Sequence in which product was added to cart |
| `reordered` | Whether or not the customer ordered the product again |

**Entity: orders**

| Column | Description |
|--------|-------------|
| `order_id` | Unique identifier for each order |
| `user_id` | Unique identifier for each customer |
| `eval_set` | Prior set of data collected |
| `order_number` | Sequence count per customer |
| `order_dow` | Day of the week the order was placed |
| `order_hour_of_day` | Hour of the day the order was purchased |
| `days_since_prior_order` | Days since last order |

**Entity: products**

| Column | Description |
|--------|-------------|
| `product_id` | Unique identifier of each product |
| `product_name` | Product name |
| `aisle_id` | Foreign key linking to aisles table |
| `department_id` | Foreign key linking to department table |

<img width="800" alt="Entity relationship diagram" src="https://github.com/user-attachments/assets/4ac0f79b-df51-44fb-b473-9c3c23ab25aa" />

---

## Analysis and Business Questions

### Exploratory Analysis (Python)

<img width="800" alt="Orders by day of week" src="https://github.com/user-attachments/assets/35fa2407-f6da-4c1c-8f81-7519b6967183" />

There's a substantial high volume of orders throughout the week, particularly during weekends. Weekdays have a stable volume of purchases. Orders peak up to 60,000 on Saturday — around 25% more than the weekday average — requiring roughly 15–20% more drivers.

<img width="800" alt="Orders by hour of day" src="https://github.com/user-attachments/assets/02c348fb-649b-4e83-8b6b-486182a84e0e" />

High volume of purchases occurs around 10 a.m. to 3 p.m. During this time, it's crucial to allocate sufficient drivers to ensure prompt delivery. Further analysis can involve optimizing driver routes to enhance service efficiency. Additionally, we can introduce an app feature that allows customers to select a preferred drop-off time. 60% of total orders occur between 10 a.m. and 3 p.m., with peak orders at 10 a.m.

<img width="800" alt="Days between orders" src="https://github.com/user-attachments/assets/cf0a57e9-1f92-4052-a63c-e039d1dc06d3" />

The interval between consecutive orders is the number of days between the previous and next order. Customers tend to place another order after 7 and 14 days. The longest interval is 30 days, which may indicate application performance issues when the gap between orders is that long.

---

### Retention Analysis (SQL)

**1. What is the retention rate by order number?**

<img width="700" alt="Retention rate by order number" src="https://github.com/user-attachments/assets/e87a2b55-dd71-4ae5-96f0-c0a109713a7e" />

Retention dropped by an average of 10% after the fourth order, indicating that customers stopped or paused using the service at that point. This could be attributed to a lack of need for the app, delayed deliveries, or increased costs.

**2. What are the differences between loyal and churned customers?**

<img width="700" alt="Loyal vs churned customers" src="https://github.com/user-attachments/assets/649346ea-301c-47d4-b6a6-4c4a3634deb9" />

Roughly 20% of customers churned compared to 80% who stayed. Customers who stayed tend to have a basket size 20% larger than churned customers, suggesting that higher purchase volume correlates with retention.

**3. What are the differences in purchase frequency between loyal and churned customers?**

<img width="700" alt="Purchase frequency comparison" src="https://github.com/user-attachments/assets/2af45ac3-6ab8-44b8-9ba1-9121e20a548d" />

On average, customers who stayed reorder every 13–14 days compared to churned customers who reordered every 19–20 days, meaning they don't find the need to use Instacart as frequently.

**4. What are customers who have multiple orders but no reordered items?**

<img width="700" alt="Customers with no reordered items" src="https://github.com/user-attachments/assets/32b8ae7a-e432-4465-9535-ea7c51f35485" />

Out of 260K+ customers, 930 placed 4–10 orders without any reordered items, while 1,185 customers placed 2–3 orders without any reordered items.

**5. What's the conversion rate between the first and second, and first and fifth orders?**

<img width="700" alt="Conversion rate by order" src="https://github.com/user-attachments/assets/446e662f-52fb-415a-b240-7e3526b617d0" />

Conversion dropped by 12% from the first to the fifth order, resulting in a decrease in revenue.

**6. What percentage of churned customers dropped off after previous orders?**

<img width="700" alt="Churn percentage by order" src="https://github.com/user-attachments/assets/0dd29196-e6c4-4071-8ec7-abbb66cb134f" />

Roughly 10% of customers churned after the fourth order and continued to drop by 10% at each subsequent order.

**7. What are the highest reorder rate and purchase volume by department?**

<img width="700" alt="Reorder rate and volume by department" src="https://github.com/user-attachments/assets/2e15029c-4988-4578-9f55-b1a74f09f044" />

The top 3 departments by order volume and reorder rate are **dairy & eggs**, **beverages**, and **produce**, indicating that customers focus on purchasing high-volume daily essentials.

---

## Recommendations

- **Personalized recommendations:** Use purchase history to surface reorder suggestions and complementary products, boosting engagement and basket size.
- **Delivery schedule optimization:** Allocate drivers strategically around peak hours (10 a.m.–3 p.m.) and peak days (weekends) to reduce wait times.
- **Drop-off time selection:** Introduce an in-app feature for customers to choose preferred delivery windows based on driver availability, cost, and demand.
- **Re-engagement campaigns:** Target customers likely to churn after the fourth order with promotions or incentives before that threshold is reached.

---

## Limitations

- **No financial data:** The dataset lacks revenue, cost, and profit figures, limiting assessment of marketing effectiveness.
- **No customer reviews:** Absence of qualitative feedback prevents deeper analysis of churn reasons. A follow-up survey is recommended.
- **No full timestamps:** Only day-of-week and hour-of-day are available — full date timestamps would enable month-level trend analysis and more precise churn detection.

---

## Table of Contents

- `README.md` — Final report
- `sql/` — Retention analysis queries
- `python/` — Exploratory statistical analysis
- `tableau/` — Dashboards and visualizations
