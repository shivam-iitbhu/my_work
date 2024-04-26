-- Product Sales Table
-- Columns: purchase_date, product_id, product_name, category, unit_price, quantity, product_returned

-- 1. Top 3 Products by Sales (Till Now)
SELECT product_id, product_name, SUM(unit_price * quantity) AS total_sales
FROM sales_table
WHERE YEAR(purchase_date) >= DATEADD(YEAR, -3, CURRENT_DATE()) -- only if we want to see last 3 years data
GROUP BY product_id, product_name
LIMIT 3;

-- 2. Top 3 Products in each category
SELECT category, product_id, product_name, SUM(unit_price * quantity) AS total_sales,
  ROW_NUMBER() OVER(PARTITION BY category ORDER BY SUM(unit_price * quantity) DESC) AS rn
FROM sales_table
WHERE YEAR(purchase_date) >= DATEADD(YEAR, -3, CURRENT_DATE()) -- only if we want to see last 3 years data
GROUP BY category, product_id, product_name
HAVING rn <= 3;

