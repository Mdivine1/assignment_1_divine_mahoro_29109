# Sunrise Supermarket - Assignment 1
- Student Name: Divine Mahoro
- Student ID: 29109
- Group: D (submits Wed 23rd 11:59)
- DBMS Used: Oracle Database 21c / Oracle LiveSQL
- Repo Name: assignment_1_divine_mahoro_29109

## Business Scenario Summary
Sunrise Supermarket sells products to customers who place orders containing one or more items. Management wants to understand who their customers are, what they buy, who are top customers, and how sales trend over time. The database has 4 tables: customers, products, orders, order_items with relationships Customer 1--* Order 1--* Order_Item *--1 Product.

## How to Run
1. Go to livesql.oracle.com and login
2. Copy/paste schema.sql and Run - creates tables
3. Copy/paste insert_data.sql and Run - inserts sample data
4. Copy/paste queries.sql and Run each query one by one to see results

## Queries Explained
Q1: List every order with customer's name and city, and order date. INNER JOIN orders + customers.
Q2: List every order item with product name, category, price, quantity. JOIN order_items + products + orders to show what was bought.
Q3: List all customers and their orders including customers who never ordered. LEFT JOIN customers + orders - shows Grace Uwase with NULL order.
Q4: Customers who spent above average. CTE customer_totals calculates total per customer, average_spend calculates average, then filter above average.
Q5: Rank customers by total spent. Uses RANK() OVER (ORDER BY total_spent DESC) - shows VIP customers.
Q6: Number each customer's orders in order they were placed. Uses ROW_NUMBER() PARTITION BY customer_id - shows 1st, 2nd, 3rd order.
Q7: Show running total of revenue over time. Uses CTE daily_revenue + SUM() OVER (ORDER BY order_date) - shows sales trend.
Q8: For each customer with more than one order, show days between current and previous order. Uses LAG() OVER (PARTITION BY customer_id).

## Screenshots
Screenshots are in /screenshots folder:
- Q1.png - INNER JOIN result
- Q2.png - order items with products
- Q3.png - LEFT JOIN showing NULL for Grace
- Q4.png - above average spenders
- Q5.png - rank
- Q6.png - row number per customer
- Q7.png - running total
- Q8.png - days between orders with LAG

## Business Interpretation
- Top Customer: Divine Mahoro from Kigali spent the highest (~28,000 RWF) across 4 orders - rank 1 VIP.
- Inactive Customer: Grace Uwase from Rubavu never placed an order - opportunity for re-engagement coupon.
- Popular Categories: Dairy (Milk 1L) and Groceries (Rice, Oil) generate highest revenue.
- Sales Trend: Running total shows revenue increasing from January to April, peak on 2025-04-20.
- Repeat Behavior: Average gap between orders is 25-35 days. Kigali customers return faster (~25 days). Management should send reminder after 30 days.
- Recommendation: Stock more Milk, Rice, Cooking Oil. Create loyalty for customers with >2 orders. Target Rubavu with promotion.

## Challenges Encountered and How Resolved
1. Oracle DATE format error - fixed by using ANSI DATE '2025-01-05' format which Oracle accepts.
2. Foreign Key error when creating tables - fixed by creating customers and products before orders and order_items.
3. LEFT JOIN returned NULLs and I thought data was missing - realized NULL is expected to show customers who never ordered.
4. Running total was double counting - fixed by first grouping revenue per day in CTE daily_revenue then using window SUM.
5. LAG for first order returns NULL previous date - this is normal behavior, filtered in final report.

## Repo Structure
- README.md
- schema.sql
- insert_data.sql
- queries.sql
- screenshots/ (Q1.png to Q8.png)