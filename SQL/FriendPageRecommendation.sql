---- Page Recommendations
-- You are given two tables, 'friends' and 'likes'. You need to give page recommendations to social media users based
-- on the pages that have been liked by their friends but are not yet liked by them.

---- Task
-- Determine the user_ids, and the corresponding page_ids of the pages that have been liked by their friends already, 
-- but have not been liked by them. Arrange the final result in the increasing order of the uder_id.
-- Note: All the pages that are liked by the user's friends are generally recommended to the user based on the social 
-- media algorithm.

---- Table Description
-- friends:
-- 	Columns: user_id, friend_id
-- likes:
-- 	Columns: user_id, page_ids
	

-- Create friends tables
CREATE TABLE dbo.friends
(user_id VARCHAR(10),
friend_id VARCHAR(10));

INSERT INTO dbo.friends
VALUES
('1', '2'),
('1', '3'),
('1', '4'),
('2', '1'),
('3', '1'),
('3', '4'),
('4', '1'),
('4', '3');

SELECT * FROM dbo.friends;

-- Create likes tables
CREATE TABLE dbo.likes
(user_id VARCHAR(10),
page_id VARCHAR(10));

INSERT INTO dbo.likes
VALUES
('1', 'A'),
('1', 'B'),
('1', 'C'),
('2', 'A'),
('3', 'B'),
('3', 'C'),
('4', 'B');

SELECT * FROM dbo.friends;
SELECT * FROM dbo.likes;

-- Solution-1
WITH cte1 AS (
SELECT a.user_id, b.page_id
FROM dbo.friends a 
JOIN dbo.likes b ON a.friend_id = b.user_id)
SELECT DISTINCT * FROM cte1
WHERE CONCAT(user_id, page_id) NOT IN 
(SELECT CONCAT(user_id, page_id) FROM dbo.likes)
ORDER BY user_id;

-- Solution-2
WITH cte1 AS (
SELECT DISTINCT a.user_id, b.page_id
FROM dbo.friends a 
JOIN dbo.likes b ON a.friend_id = b.user_id)
SELECT * FROM cte1
EXCEPT
(SELECT * FROM dbo.likes)
ORDER BY user_id;

-- Solution-3
WITH user_pages AS (
    SELECT DISTINCT f.user_id, l.page_id
    FROM friends f INNER JOIN likes l 
    ON f.user_id = l.user_id
),
friends_pages AS (
    SELECT f.user_id, f.friend_id, l.page_id
    FROM friends f INNER JOIN likes l
    ON f.friend_id = l.user_id
)
SELECT DISTINCT fp.user_id, fp.page_id FROM friends_pages fp 
LEFT JOIN user_pages up 
ON fp.user_id = up.user_id AND fp.page_id = up.page_id
WHERE up.user_id IS NULL;