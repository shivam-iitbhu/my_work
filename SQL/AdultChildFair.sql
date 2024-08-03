-- The input table "persons" contains two columns 'name' (name of the person) and 'type' (adult or child)
-- They are going to a fair and they have to ride some Jhoola. One adult should go with one child and the 
-- last adult should go alone. 

DROP TABLE IF EXISTS dbo.persons;

CREATE TABLE dbo.persons
(person VARCHAR(10),
type VARCHAR(10),
age INT);

-- INsert values into the table
INSERT INTO dbo.persons
VALUES
('A1', 'Adult', 54),
('A2', 'Adult', 53),
('A3', 'Adult', 52),
('A4', 'Adult', 58),
('A5', 'Adult', 54),
('C1', 'Child', 20),
('C2', 'Child', 19),
('C3', 'Child', 22),
('C4', 'Child', 15);

SELECT * FROM dbo.persons;

-- Solution - 1 (no use of their age)
WITH cte1 AS
(SELECT *, ROW_NUMBER() OVER(PARTITION BY type ORDER BY person) AS rn 
FROM dbo.persons)
SELECT a.person AS adult_person, b.person AS child_person
FROM (SELECT * FROM cte1 WHERE type = 'Adult') a
LEFT JOIN (SELECT * FROM cte1 WHERE type = 'Child') b
ON a.rn = b.rn;

-- Solution - 2 (eldest adult should go with youngest child)
WITH cte_adult AS
(SELECT *, ROW_NUMBER() OVER(ORDER BY age DESC) AS rn 
FROM dbo.persons WHERE type = 'Adult'),
cte_child AS
(SELECT *, ROW_NUMBER() OVER(ORDER BY age) AS rn 
FROM dbo.persons WHERE type = 'Child')
SELECT a.person AS adult_person, b.person AS child_person
FROM cte_adult a LEFT JOIN cte_child b ON a.rn = b.rn;