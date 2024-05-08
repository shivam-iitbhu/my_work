USE homedb;

------------agenda------------------
-- Top 5 Advanced SQL Questions and their Solutions >> Very commonly asked

-- 1. > Top 3 products by sales, Top 3 employees by salaries, within catagory/deptt.

CREATE TABLE homedb.dbo.employee
(emp_id INT,
emp_name CHAR(40),
dept_id INT,
salary INT,
manager_id INT,
emp_age INT);

SELECT * FROM employee;
-- DROP TABLE employee;

INSERT INTO employee VALUES
(1, 'Ankit', 100, 12000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 10000, 4, 37),
(4, 'Rohit', 100, 5000, 2, 16),
(5, 'Mudit', 200, 12000, 6, 55),
(6, 'Agam', 200, 12000, 2, 14),
(7, 'Sanjay', 200, 9000, 2, 13),
(8, 'Ashish', 200, 5000, 2, 12),
(9, 'Mukesh', 300, 6000, 6, 51),
(10, 'Rakesh', 500, 7000, 6, 50),
(11, 'Dummy', 400, 4000, 4, 99);

-- Top 2 highest salaried employees
SELECT TOP 2 * FROM employee
ORDER BY salary DESC;		-- This will give top 2 highest salaried employees on overall basis.

SELECT * FROM employee
ORDER BY dept_id, salary DESC;

SELECT * FROM
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn,
DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn_dense
FROM employee
) a
WHERE a.rn <= 2
-- WHERE a.rn_dense <= 2

-- DROP TABLE orders;

CREATE TABLE orders (
order_id VARCHAR(40),
order_date DATE,
ship_date DATE,
ship_mode VARCHAR(40),
customer_name VARCHAR(40),
segment VARCHAR(40),
state VARCHAR(40),
country VARCHAR(40),
market VARCHAR(40),
region VARCHAR(40),
product_id VARCHAR(40),
category VARCHAR(40),
sub_category VARCHAR(40),
product_name VARCHAR(100),
sales DECIMAL(18, 2),
quantity INT,
discount INT,
profit DECIMAL(18, 2),
shipping_cost DECIMAL(18, 2),
order_priority VARCHAR(40),
year INT);

SELECT YEAR(order_date) AS yr, COUNT(*)
FROM orders
GROUP BY YEAR(order_date);

SELECT order_id, product_id, category, sales
FROM orders;

--- Top 5 products by sales
SELECT TOP 5 product_id, SUM(sales) AS sls
FROM orders
GROUP BY product_id
ORDER BY sls DESC;

--- Top 5 products by sales in each category
WITH cte AS
(
SELECT category, product_id, SUM(sales) AS sls
FROM orders
GROUP BY category, product_id)
, cte2 AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY category ORDER BY sls DESC) AS rn
FROM cte)
SELECT * FROM cte2 WHERE rn <= 5;


--- YoY Growth of the sales
WITH cte AS
(
SELECT YEAR(order_date) AS yr, SUM(sales) AS sls
FROM orders
GROUP BY YEAR(order_date)
--ORDER BY YEAR(order_date)
),
cte2 AS (
SELECT yr, sls, LAG(sls, 1, sls) OVER(ORDER BY yr) AS pysls
FROM cte)
SELECT *, (sls-pysls)*100/pysls AS yoy FROM cte2;



--- YoY Growth of the sales/Category wise
WITH cte AS
(
SELECT category, YEAR(order_date) AS yr, SUM(sales) AS sls
FROM orders
GROUP BY category, YEAR(order_date)
--ORDER BY category, YEAR(order_date)
),
cte2 AS (
SELECT *, LAG(sls, 1, sls) OVER(PARTITION BY category ORDER BY yr) AS pysls
FROM cte)
SELECT *, (sls-pysls)*100/pysls AS yoy FROM cte2;


-- Products with current month sales more than previous month sales
WITH cte AS
(
SELECT product_id, FORMAT(order_date, 'yyyy-MM') AS yrm, SUM(sales) AS sls
FROM orders
GROUP BY product_id, FORMAT(order_date, 'yyyy-MM')
--ORDER BY product_id, FORMAT(order_date, 'yyyy-MM')
),
cte2 AS (
SELECT *, LAG(sls,1,sls) OVER(PARTITION BY product_id ORDER BY yrm) AS pmsls
FROM cte)
SELECT * FROM cte2 WHERE sls > pmsls;


--- Running/Cumulative Sales
WITH cte AS
(
SELECT YEAR(order_date) AS yr, SUM(sales) AS sls
FROM orders
GROUP BY YEAR(order_date)
--ORDER BY YEAR(order_date)
)
SELECT *, SUM(sls) OVER(ORDER BY yr) AS csls
FROM cte;


--- Running/Cumulative Sales category wise
WITH cte AS
(
SELECT category, YEAR(order_date) AS yr, SUM(sales) AS sls
FROM orders
GROUP BY category, YEAR(order_date)
--ORDER BY YEAR(order_date)
)
SELECT *, SUM(sls) OVER(PARTITION BY category ORDER BY yr) AS csls
FROM cte;


--- n months rolling sales (3 months rolling sales, 2 previous months + current month sales)
WITH cte AS
(
SELECT YEAR(order_date) AS yr, MONTH(order_date) AS mnth, SUM(sales) AS sls
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
--ORDER BY YEAR(order_date), MONTH(order_date)
)
--SELECT *, SUM(sls) OVER(PARTITION BY yr ORDER BY yr, mnth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS csls FROM cte;		-- Year Wise
--SELECT *, SUM(sls) OVER(ORDER BY yr, mnth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS csls FROM cte;		-- Overall
SELECT *, SUM(sls) OVER(ORDER BY yr, mnth ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS csls FROM cte;		-- Rolling SUM of past 3 months excluding current month



---Pivoting -- convert rows into columns -- year wise each category sales
SELECT YEAR(order_date) AS yr, category, SUM(sales) AS sls
FROM orders
GROUP BY YEAR(order_date), category
ORDER BY YEAR(order_date), category;

-- rows to columns
SELECT YEAR(order_date) AS yr,
SUM(CASE WHEN category = 'Furniture' THEN sales ELSE 0 END) AS sls_furniture,
SUM(CASE WHEN category = 'Office Supplies' THEN sales ELSE 0 END) AS sls_office_supplies,
SUM(CASE WHEN category = 'Technology' THEN sales ELSE 0 END) AS sls_technology
FROM orders
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);
