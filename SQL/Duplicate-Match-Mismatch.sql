CREATE TABLE source
(id INT, name VARCHAR(5));

INSERT INTO source
VALUES
(1,'A'), (2,'B'), (3,'C'), (4,'D');

SELECT * FROM source;

CREATE TABLE target
(id INT, name VARCHAR(5));

INSERT INTO target
VALUES
(1,'A'), (2,'B'), (4,'X'), (5,'F');

SELECT * FROM target;

-- Need to query uncommon result

-- Solution-1
WITH cte AS
(SELECT * FROM source
UNION ALL
SELECT * FROM target)
-- SELECT id, name, COUNT(*) AS cnt
SELECT id, name
FROM cte
GROUP BY id, name
HAVING COUNT(*) = 1;

-- Solution-2
SELECT s.*, t.* FROM source s
FULL JOIN target t
ON s.id = t.id
WHERE s.name != t.name OR s.name IS NULL OR t.name IS NULL;

SELECT COALESCE(s.id, t.id) AS id,	-- s.name, t.name,
CASE WHEN t.name IS NULL THEN 'New in Source'
	 WHEN s.name IS NULL THEN 'New in Target'
	 ELSE 'Mismatch' END AS val_comment
FROM source s
FULL JOIN target t
ON s.id = t.id
WHERE s.name != t.name OR s.name IS NULL OR t.name IS NULL;
