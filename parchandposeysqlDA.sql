-- QUESTION 1: CURRENT STATE OF THE COMPANY	

-- A. This query displays the size of the customer base.
SELECT count(DISTINCT account_id) AS customer_base 
FROM orders AS o;
-- Total of 350 customers


-- B. This query looks at the number of sales representatives.
SELECT count(*) AS no_sales_reps
FROM sales_reps AS sr;
-- Total of 52 sales representatives


-- C. This query displays the number of regions
SELECT COUNT(DISTINCT name) AS no_regions 
FROM region AS r;
-- Total of 7 regions


-- D. This query displays the web channels.
SELECT COUNT(DISTINCT channel) AS no_channels
FROM web_events AS we;
-- Total of 6 web channels




-- QUESTION 2: REVENUE STREAMS

-- A. These queries investigate the percentage of the quantity of each product compared to the total quantity of orders.

SELECT 100.0 * SUM(standard_qty) / SUM(total) AS percentage_standard_qty 
FROM orders;

SELECT 100.0 * SUM(gloss_qty) / SUM(total) AS percentage_gloss_qty 
FROM orders;

SELECT 100.0 * SUM(poster_qty) / SUM(total) AS percentage_poster_qty 
FROM orders;
-- The resulting percentages were 52.73% for standard, 27.58% for gloss, and 19.67% for poster paper.


-- B. These queries investigate the percentage of the prices of each product order compared to the total prices of orders.
SELECT 100.0 * SUM(standard_amt_usd) / SUM(total_amt_usd) AS percentage_standard_amt_usd 
FROM orders;

SELECT 100.0 * SUM(gloss_amt_usd) / SUM(total_amt_usd) AS percentage_gloss_amt_usd 
FROM orders;

SELECT 100.0 * SUM(poster_amt_usd) / SUM(total_amt_usd) AS percentage_poster_amt_usd 
FROM orders;
-- The resulting percentages were 41.80% for standard, 32.82% for gloss, and 25.39% for poster paper.


-- C. These queries calculate the average unit price for each type of paper.
SELECT 1.0 * SUM(standard_amt_usd) / SUM(standard_qty) AS average_standard_unitprice 
FROM orders;

SELECT 1.0 * SUM(gloss_amt_usd) / SUM(gloss_qty) AS average_gloss_unitprice 
FROM orders;

SELECT 1.0 * SUM(poster_amt_usd) / SUM(poster_qty) AS average_poster_unitprice 
FROM orders;
-- The resulting prices were $4.99 for standard, $7.49 for gloss, and $8.12 for poster paper.


-- D. These queries calculate the total revenue for each type of paper.
SELECT SUM(standard_amt_usd) 
FROM orders;

SELECT SUM(gloss_amt_usd) 
FROM orders;

SELECT SUM(poster_amt_usd) 
FROM orders;
-- The resulting revenues were $9,672,346.54 for standard, $7,593,159.77 for gloss, and $5,876,005.52 for poster paper.




-- QUESTION 3: BUSINESS GROWTH

-- A. This query calculates the annual revenues.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       SUM(total_amt_usd) AS annual_revenue 
FROM orders 
GROUP BY EXTRACT(YEAR FROM occurred_at)
ORDER BY year;
-- Annual Revenues: The annual revenue grew significantly from $377,331 in 2013 to $12,864,917.92 in 2016 but dropped sharply to $78,151.43 in 2017.


-- B. This query calculates the annual total quantities sold.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       SUM(total) AS total_quantity_sold 
FROM orders 
GROUP BY EXTRACT(YEAR FROM occurred_at) 
ORDER BY year;
-- Annual Total Quantities Sold: Total quantities sold increased from 58,310 in 2013 to 2,041,600 in 2016, with a sharp decline to 11,987 in 2017.


-- C. This query calculates the number of accounts per year.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       COUNT(DISTINCT account_id) AS no_accounts 
FROM orders 
GROUP BY EXTRACT(YEAR FROM occurred_at)
ORDER BY year;
-- Number of Accounts per Year: The number of accounts grew steadily from 61 in 2013 to a peak of 317 in 2016, before declining to 37 in 2017.


-- D. This query calculates the number of sales representatives per year.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       COUNT(DISTINCT sr.id) AS no_sales_reps 
FROM orders o 
JOIN accounts a ON o.account_id = a.id 
JOIN sales_reps sr ON a.sales_rep_id = sr.id 
GROUP BY EXTRACT(YEAR FROM occurred_at) 
ORDER BY year;
-- Number of Sales Representatives per Year: The number of sales representatives increased steadily from 35 in 2013 to 50 in 2016 but dropped slightly to 13 in 2017.


-- E. This query calculates the quarterly revenues.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       EXTRACT(QUARTER FROM occurred_at) AS quarter, 
       SUM(total_amt_usd) AS quarterly_revenue 
FROM orders 
GROUP BY EXTRACT(YEAR FROM occurred_at), EXTRACT(QUARTER FROM occurred_at) 
ORDER BY year, quarter;
-- Quarterly Revenues: Quarterly revenues grew consistently from $377,331 in Q4 2013 to $4,534,309.81 in Q4 2016, with a significant drop to $78,151.43 in 2017.


-- F. This query displays the number of accounts per quarter.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       EXTRACT(QUARTER FROM occurred_at) AS quarter, 
       SUM(total) AS total_quantity_sold 
FROM orders 
GROUP BY EXTRACT(YEAR FROM occurred_at), EXTRACT(QUARTER FROM occurred_at) 
ORDER BY year, quarter;
-- Number of Accounts per Quarter: The number of accounts increased steadily from 61 in Q4 2013 to a peak of 290 in Q3 2016, followed by a sharp decline to 14 in Q1 2017.


-- G. This query shows the number of sales representatives per quarter.
SELECT EXTRACT(YEAR FROM occurred_at) AS year, 
       EXTRACT(QUARTER FROM occurred_at) AS quarter, 
       COUNT(DISTINCT sr.id) AS no_sales_reps 
FROM orders o 
JOIN accounts a ON o.account_id = a.id 
JOIN sales_reps sr ON a.sales_rep_id = sr.id 
GROUP BY EXTRACT(YEAR FROM occurred_at), EXTRACT(QUARTER FROM occurred_at) 
ORDER BY year, quarter;
-- Number of Sales Representatives per Quarter: The number of sales representatives grew from 35 in Q4 2013 to 50 by Q4 2016, but dropped drastically to 13 in Q1 2017.




-- QUESTION 4: INCREASING SALES EFFICIENCY

-- A. This query displays the total orders, sales, and sales representatives by region.
SELECT r.name AS region_name, 
       COUNT(DISTINCT sr.id) AS num_sales_reps, 
       COUNT(o.id) AS total_num_orders, 
       ROUND(SUM(o.total_amt_usd)) AS total_sales, 
       COUNT(DISTINCT a.name) AS number_of_accounts, 
       COUNT(DISTINCT a.name) / COUNT(DISTINCT sr.id) * 1.0 AS accounts_to_salesreps, 
       COUNT(o.id) / COUNT(DISTINCT sr.id) * 1.0 AS orders_to_salesreps, 
       ROUND(SUM(o.total_amt_usd) / COUNT(DISTINCT sr.id)) AS sales_to_salesreps 
FROM region AS r 
LEFT JOIN sales_reps AS sr ON sr.region_id = r.id 
LEFT JOIN accounts AS a ON a.sales_rep_id = sr.id 
LEFT JOIN orders AS o ON o.account_id = a.id 
GROUP BY r.name 
HAVING COUNT(o.id) > 0 
ORDER BY total_sales DESC;




-- QUESTION 5: MARKETING STRATEGIES

-- A. This query identifies the number of companies within each category, the total order amount in that category, the quantity of each product, and the number of orders.
SELECT 'health' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%health%'
UNION ALL
SELECT 'financial/bank' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%financial%' OR a.name ILIKE '%bank%'
UNION ALL
SELECT 'energy' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%energy%'
UNION ALL
SELECT 'holding' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%holding%'
UNION ALL
SELECT 'food' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%food%'
UNION ALL
SELECT 'international' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%international%'
UNION ALL
SELECT 'insurance' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%insurance%'
UNION ALL
SELECT 'tech' AS category, 
       COUNT(DISTINCT a.name) AS client_count, 
       ROUND(SUM(o.total_amt_usd)) AS total_amt_usd, 
       SUM(o.standard_qty) AS standard_qty, 
       SUM(o.poster_qty) AS poster_qty, 
       SUM(o.gloss_qty) AS gloss_qty, 
       SUM(o.total) AS total_qty, 
       COUNT(o.total) AS total_orders 
FROM accounts a 
JOIN orders o ON a.id = o.account_id 
WHERE a.name ILIKE '%tech%' 
ORDER BY total_amt_usd DESC, client_count DESC;








