-- Acies global interview question
-- We have a swipe table which keeps track of the employee login and logout timings.
-- 1. Find out the time employee person spent in office in a particular day (office hours = last logout time - first login time)
-- 2. Find out how productive he was at office on a particular day. (He might have done many swipes per day. I need to find the actual time spent at office)

DROP TABLE IF EXISTS dbo.employee_checkin;

CREATE TABLE dbo.employee_checkin
(employee_id INT,
activity_type VARCHAR(20),
activity_time DATETIME);

INSERT INTO dbo.employee_checkin
VALUES
(1, 'login', '2024-07-23 08:00:00.000'),
(1, 'logout', '2024-07-23 12:00:00.000'),
(1, 'login', '2024-07-23 13:00:00.000'),
(1, 'logout', '2024-07-23 17:00:00.000'),
(2, 'login', '2024-07-23 09:00:00.000'),
(2, 'logout', '2024-07-23 11:00:00.000'),
(2, 'login', '2024-07-23 12:00:00.000'),
(2, 'logout', '2024-07-23 15:00:00.000'),
(1, 'login', '2024-07-24 08:30:00.000'),
(1, 'logout', '2024-07-24 12:30:00.000'),
(2, 'login', '2024-07-24 09:30:00.000'),
(2, 'logout', '2024-07-24 10:30:00.000');

SELECT * FROM dbo.employee_checkin;

-- Solution Way - 1
WITH cte1 AS (
SELECT employee_id, ROW_NUMBER() OVER(ORDER BY employee_id, activity_time) AS rn1, activity_type AS type_login, activity_time
FROM dbo.employee_checkin WHERE activity_type = 'login'),
cte2 AS (
SELECT employee_id, ROW_NUMBER() OVER(ORDER BY employee_id, activity_time) AS rn2, activity_type AS type_logout, activity_time
FROM dbo.employee_checkin WHERE activity_type = 'logout'),
cte3 AS (
SELECT a.employee_id, CAST(a.activity_time AS DATE) AS daily_date,
a.activity_time AS login_time, b.activity_time AS logout_time,
DATEDIFF(HOUR, a.activity_time, b.activity_time) AS timediff
FROM cte1 a INNER JOIN cte2 b ON CONCAT(a.employee_id, a.rn1) = CONCAT(b.employee_id, b.rn2))
SELECT employee_id, daily_date, DATEDIFF(HOUR, MIN(login_time), MAX(logout_time)) AS office_hours,
SUM(timediff) AS working_hours
FROM cte3 GROUP BY employee_id, daily_date;


-- Solution Way - 2
WITH cte1 AS (
SELECT *, CAST(activity_time AS DATE) AS activity_date,
LEAD(activity_time, 1) OVER(PARTITION BY employee_id, CAST(activity_time AS DATE) ORDER BY activity_time) AS logout_time
FROM dbo.employee_checkin),
cte2 AS (
SELECT employee_id, activity_date, activity_time AS login_time, logout_time,
DATEDIFF(HOUR, activity_time, logout_time) AS working_schedule
FROM cte1 WHERE activity_type = 'login')
SELECT employee_id, activity_date, DATEDIFF(HOUR, MIN(login_time), MAX(logout_time)) AS office_hours,
SUM(working_schedule) AS working_hours
FROM cte2 GROUP BY employee_id, activity_date;