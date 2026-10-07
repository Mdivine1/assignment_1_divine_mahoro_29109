-- Q1: INNER JOIN orders + customers
SELECT o.order_id, c.customer_name, c.city, o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- Q2: JOIN order_items + products
SELECT oi.order_item_id, o.order_id, p.product_name, p.category, p.price, oi.quantity, (p.price * oi.quantity) AS line_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id;

-- Q3: LEFT JOIN customers + orders (including customers with no orders)
SELECT c.customer_id, c.customer_name, c.city, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Q4: CTE - Customers above average spend
WITH customer_totals AS (
  SELECT c.customer_id, c.customer_name, SUM(oi.quantity * p.price) AS total_spent
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  GROUP BY c.customer_id, c.customer_name
),
average_spend AS (
  SELECT AVG(total_spent) AS avg_spent FROM customer_totals
)
SELECT ct.* , (SELECT avg_spent FROM average_spend) AS average_of_all
FROM customer_totals ct
WHERE ct.total_spent > (SELECT avg_spent FROM average_spend);

-- Q5: Rank customers by total spent
WITH customer_totals AS (
  SELECT c.customer_id, c.customer_name, SUM(oi.quantity * p.price) AS total_spent
  FROM customers c JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spend_rank,
       DENSE_RANK() OVER (ORDER BY total_spent DESC) AS dense_rank
FROM customer_totals;

-- Q6: Number each customer's orders in order they were placed
SELECT customer_id, order_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number_for_customer
FROM orders;

-- Q7: Running total of revenue over time
WITH daily_revenue AS (
  SELECT o.order_date, SUM(oi.quantity * p.price) AS day_rev
  FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  GROUP BY o.order_date
)
SELECT order_date, day_rev,
       SUM(day_rev) OVER (ORDER BY order_date) AS running_total_revenue
FROM daily_revenue
ORDER BY order_date;

-- Q8: Days between orders for customers with >1 order
SELECT customer_id, order_id, order_date,
       LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
       order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS days_between
FROM orders;