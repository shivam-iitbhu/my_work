CREATE TABLE dbo.prices
(product_id INT,
start_date DATE,
end_date DATE,
price INT);

INSERT INTO dbo.prices
VALUES
(1, '2019-02-17', '2019-02-28', 5),
(1, '2019-03-01', '2019-03-22', 20),
(2, '2019-02-01', '2019-02-20', 15),
(2, '2019-02-21', '2019-03-31', 30),
(3, '2019-02-21', '2019-03-31', 30);

SELECT * FROM dbo.prices;

CREATE TABLE dbo.unitsSold
(product_id INT,
purchase_date DATE,
units INT);

INSERT INTO dbo.unitsSold
VALUES
(1, '2019-02-25', 100),
(1, '2019-03-01', 15),
(2, '2019-02-10', 200),
(2, '2019-03-22', 30);

SELECT * FROM dbo.unitsSold;

-- Problem Statement
-- Write a solution to find the average selling price for
-- each product. average_price should be rounded to 2 
-- decimal places.

-- Solution : 1
SELECT a.product_id, ISNULL(ROUND(SUM(a.price * b.units)/SUM(units), 4), 0) AS average_price
FROM prices a LEFT JOIN unitsSold b ON a.product_id = b.product_id
AND b.purchase_date BETWEEN a.start_date AND a.end_date
GROUP BY a.product_id;

-- Solution : 2
SELECT a.product_id, ISNULL(SUM(a.price * b.units)/SUM(units), 0) AS average_price
FROM prices a LEFT JOIN unitsSold b ON a.product_id = b.product_id
AND b.purchase_date BETWEEN a.start_date AND a.end_date
GROUP BY a.product_id;