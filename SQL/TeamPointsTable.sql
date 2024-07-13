-- Question:
-- You have a table called 'matched' with the following columns:
-- TeamA, TeamB, Result

-- Task:
-- Create a complete football score table with the following columns:
-- Team_Name, Matches_Played, Won, Lost, Draw, Points

-- POint System:
-- Won: 3 Points, Lost: 0 Point, Draw: 1 Point

CREATE TABLE Matches_Played
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    TeamA VARCHAR(50),
    TeamB VARCHAR(50),
    Result VARCHAR(10)
);

INSERT INTO matches
VALUES
('Team 1', 'Team 2', 'win'),
('Team 1', 'Team 3', 'lose'),
('Team 1', 'Team 4', 'draw'),
('Team 1', 'Team 5', 'win'),
('Team 1', 'Team 6', 'lose'),
('Team 1', 'Team 7', 'win'),
('Team 2', 'Team 3', 'draw'),
('Team 2', 'Team 4', 'win'),
('Team 2', 'Team 5', 'lose'),
('Team 2', 'Team 6', 'win'),
('Team 2', 'Team 7', 'draw'),
('Team 3', 'Team 4', 'lose'),
('Team 3', 'Team 5', 'win'),
('Team 3', 'Team 6', 'draw'),
('Team 3', 'Team 7', 'lose'),
('Team 4', 'Team 5', 'win'),
('Team 4', 'Team 6', 'lose'),
('Team 4', 'Team 7', 'draw'),
('Team 5', 'Team 6', 'win'),
('Team 5', 'Team 7', 'lose'),
('Team 6', 'Team 7', 'win'),
('Team 7', 'Team 1', 'lose'),
('Team 6', 'Team 2', 'draw'),
('Team 5', 'Team 3', 'win'),
('Team 4', 'Team 1', 'draw');

