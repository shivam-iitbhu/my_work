-- Several friends at a cinema ticket office would like to reserve consecutive available seats.
-- Can you help to query all the consecutive available seats order by the seat_id using the following the cinema table?

-- | seat_id | free |
-- | 1		  | 1    |
-- | 2		  | 0    |
-- | 3		  | 1    |
-- | 4		  | 1    |
-- | 5		  | 1    |

-- Your query should return the following result for the saple case above:

-- | seat_id |
-- |---------|
-- |    3    |
-- |    4    |
-- |    5    |

-- Note:
-- The seat_id is an auto increment INT, and free is BOOL ('1' means free, and '0' means occupied).
-- Consecutive available seats are more than 2 (inclusive) seats consecutively available.

CREATE TABLE cinema
(
seat_id INT PRIMARY_KEY,
free INT
);

DELETE FROM cinema;

INSERT INTO cinema (seat_id, free) VALUES (1, 1);
INSERT INTO cinema (seat_id, free) VALUES (2, 0);
INSERT INTO cinema (seat_id, free) VALUES (3, 1);
INSERT INTO cinema (seat_id, free) VALUES (4, 1);
INSERT INTO cinema (seat_id, free) VALUES (5, 1);
INSERT INTO cinema (seat_id, free) VALUES (6, 0);
INSERT INTO cinema (seat_id, free) VALUES (7, 1);
INSERT INTO cinema (seat_id, free) VALUES (8, 1);
INSERT INTO cinema (seat_id, free) VALUES (9, 0);
INSERT INTO cinema (seat_id, free) VALUES (10, 1);
INSERT INTO cinema (seat_id, free) VALUES (11, 0);
INSERT INTO cinema (seat_id, free) VALUES (12, 1);
INSERT INTO cinema (seat_id, free) VALUES (13, 0);
INSERT INTO cinema (seat_id, free) VALUES (14, 1);
INSERT INTO cinema (seat_id, free) VALUES (15, 1);
INSERT INTO cinema (seat_id, free) VALUES (16, 0);
INSERT INTO cinema (seat_id, free) VALUES (17, 1);
INSERT INTO cinema (seat_id, free) VALUES (18, 1);
INSERT INTO cinema (seat_id, free) VALUES (19, 1);
INSERT INTO cinema (seat_id, free) VALUES (20, 1);


SELECT * FROM cinema
ORDER BY seat_id;

-- Solution: 1
WITH cte1 AS
(SELECT seat_id, free, LAG(free,1,998) OVER(ORDER BY seat_id) AS free_lag, LEAD(free,1,999) OVER(ORDER BY seat_id) AS free_lead
FROM cinema)
SELECT seat_id FROM cte1 WHERE (free = 1 AND free_lag = 1) OR (free = 1 AND free_lead = 1);

-- Solution: 2
WITH cte1 AS
(SELECT seat_id, free, ROW_NUMBER() OVER(ORDER BY seat_id) AS rn, (seat_id - ROW_NUMBER() OVER(ORDER BY seat_id)) AS rnd
FROM cinema
WHERE free = 1),
cte2 AS
(SELECT rnd, COUNT(*) AS cnt FROM cte1 GROUP BY rnd HAVING COUNT(*) >= 2)
SELECT * FROM cte1 WHERE rnd in (SELECT rnd FROM cte2);

-- Solution: 3
WITH cte1 AS
(SELECT c1.seat_id AS s1, c2.seat_id AS s2
FROM cinema c1 INNER JOIN cinema c2 ON c1.seat_id + 1 = c2.seat_id
WHERE c1.free = 1 AND c2.free = 1)
SELECT s1 FROM cte1
UNION
SELECT s2 FROM cte1;
