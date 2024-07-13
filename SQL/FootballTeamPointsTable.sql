-- Question:
-- You have a table called 'matched' with the following columns:
-- TeamA, TeamB, Result

-- Task:
-- Create a complete football score table with the following columns:
-- Team_Name, Matches_Played, Won, Lost, Draw, Points

-- POint System:
-- Won: 3 Points, Lost: 0 Point, Draw: 1 Point

CREATE TABLE matches
(
    id INT PRIMARY KEY,
    TeamA VARCHAR(50),
    TeamB VARCHAR(50),
    Result VARCHAR(10)
);

INSERT INTO matches
VALUES
(1, 'Team 1', 'Team 2', 'win'),
(2, 'Team 1', 'Team 3', 'lose'),
(3, 'Team 1', 'Team 4', 'draw'),
(4, 'Team 1', 'Team 5', 'win'),
(5, 'Team 1', 'Team 6', 'lose'),
(6, 'Team 1', 'Team 7', 'win'),
(7, 'Team 2', 'Team 3', 'draw'),
(8, 'Team 2', 'Team 4', 'win'),
(9, 'Team 2', 'Team 5', 'lose'),
(10, 'Team 2', 'Team 6', 'win'),
(11, 'Team 2', 'Team 7', 'draw'),
(12, 'Team 3', 'Team 4', 'lose'),
(13, 'Team 3', 'Team 5', 'win'),
(14, 'Team 3', 'Team 6', 'draw'),
(15, 'Team 3', 'Team 7', 'lose'),
(16, 'Team 4', 'Team 5', 'win'),
(17, 'Team 4', 'Team 6', 'lose'),
(18, 'Team 4', 'Team 7', 'draw'),
(19, 'Team 5', 'Team 6', 'win'),
(20, 'Team 5', 'Team 7', 'lose'),
(21, 'Team 6', 'Team 7', 'win'),
(22, 'Team 7', 'Team 1', 'lose'),
(23, 'Team 6', 'Team 2', 'draw'),
(24, 'Team 5', 'Team 3', 'win'),
(25, 'Team 4', 'Team 1', 'draw');

SELECT * FROM matches ORDER BY id;

WITH cte1 AS
(
SELECT id,
TeamA,
TeamB,
CASE WHEN Result = 'win' THEN 3
	WHEN Result = 'lose' THEN 0
	WHEN Result = 'draw' THEN 1
END AS TeamApoints,
CASE WHEN Result = 'win' THEN 0
	WHEN Result = 'lose' THEN 3
	WHEN Result = 'draw' THEN 1
END AS TeamBpoints
FROM matches
),
cte2 AS
(SELECT TeamA AS TeamName, TeamApoints AS points FROM cte1
UNION ALL
SELECT TeamB AS TeamName, TeamBpoints AS points FROM cte1)
--SELECT * FROM cte2;
SELECT TeamName,
	   COUNT(*) AS MatchesPlayed,
	   SUM(CASE WHEN points = 3 THEN 1 ELSE 0 END) AS MatchesWon,
	   SUM(CASE WHEN points = 0 THEN 1 ELSE 0 END) AS MatchesLost,
	   SUM(CASE WHEN points = 1 THEN 1 ELSE 0 END) AS MatchesDraw,
	   SUM(points) AS TotalPoints
FROM cte2
GROUP BY TeamName
ORDER BY TotalPoints DESC;