-- For an airline company, following are the ticket data points:
-- flight_number, origin, destination, oneway_round, ticket_count
-- oneway_round: 'O' -> One Way Trip
-- oneway_round: 'R' -> Round Trip
-- Note: DEL -> BOM is a different route from BOM -> DEL

-- Write a SQL statement to identify the busiest route based on the total number of ticket count for each route.

-- Table Creation (DDL)
CREATE TABLE tickets (
	airline_number VARCHAR(10),
	origin VARCHAR(3),
	destination VARCHAR(3),
	oneway_round CHAR(1),
	ticket_count INT
);

-- Inserting values to the table
INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count)
VALUES
	('DEF456', 'BOM', 'DEL', 'O', 150),
	('GHI789', 'DEL', 'BOM', 'R', 50),
	('JKL012', 'BOM', 'DEL', 'R', 75),
	('MNO345', 'DEL', 'NYC', 'O', 200),
	('PQR678', 'NYC', 'DEL', 'O', 180),
	('STU901', 'NYC', 'DEL', 'R', 60),
	('ABC123', 'DEL', 'BOM', 'O', 100),
	('VWX234', 'DEL', 'NYC', 'R', 90);


-- Expected Output
-- origin, destination, ticket_count
-- DEL, NYC, 350

-- Query to find the busiest route
WITH cte1 AS 
  (
    SELECT origin, destination, SUM(ticket_count) AS ticket_count
    FROM tickets
    GROUP BY origin, destination
  ),
cte2 AS 
  (
    SELECT destination AS origin, origin AS destination, SUM(ticket_count) AS ticket_count
    FROM tickets
    WHERE oneway_round = 'R'
    GROUP BY destination, origin
  )
SELECT TOP 1 a.origin, 
             a.destination, 
             (a.ticket_count + b.ticket_count) AS ticket_count
FROM cte1 AS a 
  JOIN cte2 AS b ON a.origin = b.origin AND a.destination = b.destination
ORDER BY (a.ticket_count + b.ticket_count) DESC;
