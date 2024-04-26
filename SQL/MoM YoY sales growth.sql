-- Product Sales Table
-- Columns: purchase_date, product_id, product_name, category, unit_price, quantity, product_returned

--1. MoM Calculation
WITH cte1 AS 
  (
SELECT YEAR(purchase_date) AS yr,
       MONTH(purchase_date) AS mnth,
       SUM(unit_price * quantity) AS sales
FROM sales_table
GROUP BY YEAR(purchase_date), MONTH(purchase_date)
  ),
cte2 AS 
  (
SELECT yr, mnth, LAG(sales, 1, sales) AS prev_mnth_sales, sales AS curr_mnth_sales
FROM cte1 ORDER BY yr, mnth)
SELECT yr, mnth, prev_mnth_sales, curr_mnth_sales, ((curr_mnth_sales/prev_mnth_sales) - 1) * 100 AS mom_pct
FROM cte2;

--1. YoY Calculation
WITH cte1 AS 
  (
SELECT YEAR(purchase_date) AS yr,
       SUM(unit_price * quantity) AS sales
FROM sales_table
GROUP BY YEAR(purchase_date)
  ),
cte2 AS 
  (
SELECT yr, LAG(sales, 1, sales) AS py_sales, sales AS cy_sales
FROM cte1 ORDER BY yr)
SELECT yr, py_sales, cy_sales, ((cy_sales/py_sales) - 1) * 100 AS yoy_pct
FROM cte2;
