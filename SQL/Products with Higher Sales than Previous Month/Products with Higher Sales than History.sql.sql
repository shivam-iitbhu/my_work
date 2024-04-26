-- Product Sales Table
-- Columns: purchase_date, product_id, product_name, category, unit_price, quantity, product_returned

-- Products with higher sales than previous month
WITH cte1 AS
  (
SELECT MONTH(purchase_date) as mnth, product_id, SUM(unit_price * quantity) AS total_sales
FROM sales
GROUP BY MONTH(purchase_date), product_id
  )
SELECT a.product_id, a.total_sales AS sales_a, b.total_sales AS sales_b
FROM (SELECT * FROM cte1 WHERE mnth = MONTH(CURRENT_DATE())) a
JOIN (SELECT * FROM cte1 WHERE mnth = MONTH(CURRENT_DATE()) - 1) b
ON a.product_id = b.product_id
WHERE a.total_sales > b.total_sales;

-- Products with higher sales than previous year
WITH cte1 AS
  (
SELECT YEAR(purchase_date) as yr, product_id, SUM(unit_price * quantity) AS total_sales
FROM sales
GROUP BY YEAR(purchase_date), product_id
  )
SELECT a.product_id, a.total_sales AS sales_a, b.total_sales AS sales_b
FROM (SELECT * FROM cte1 WHERE mnth = YEAR(CURRENT_DATE())) a
JOIN (SELECT * FROM cte1 WHERE mnth = YEAR(CURRENT_DATE()) - 1) b
ON a.product_id = b.product_id
WHERE a.total_sales > b.total_sales;
