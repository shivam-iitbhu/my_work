-- Gaming SQL problem asked by a Gaming Company (Ludo King)
-- Q3. In the last 7 days, get a distribution of games (% of total games) based on the social interaction
-- that is happening during the games. Please consider the following as the categories for getting the distribution:
-- 1. No Social Interaction (no messages, emojis or gifts sent during the game)
-- 2. One sided interaction (messages, emojis or gifts sent during the game by only one player)
-- 3. Both sided interaction without custom-typed messages
-- 4. Both sided interaction with custom-typed messages from at least one player

-- Context: During a game, the users have the ability to socially interact with each other by sending custom_typed_messages, pre-loaded quick messages, emojis, or game gifts. The sample entries for one of the games is provided below:

-- Table Name : game_actions


CREATE TABLE user_interactions (
    user_id varchar(10),
    event varchar(15),
    event_date DATE,
    interaction_type varchar(15),
    game_id varchar(10),
    event_time TIME
);

SELECT * FROM user_interactions;

INSERT INTO user_interactions 
VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');


-- Case:1 - No Social Interaction (no messages, emojis or gifts sent during the game)
WITH tb1 AS
(
SELECT COUNT(*) AS cnt_f, 'jk' AS cj FROM
(
SELECT game_id, COUNT(interaction_type) AS cnt
FROM user_interactions
GROUP BY game_id
HAVING COUNT(interaction_type) = 0
) a),
tb2 AS (
SELECT COUNT(DISTINCT game_id) AS cnt_t, 'jk' AS cj FROM user_interactions)
SELECT tb1.cnt_f, tb2.cnt_t, tb1.cnt_f*100/tb2.cnt_t AS perc FROM tb1 JOIN tb2 ON tb1.cj = tb2.cj;

-- Alternate Solution
WITH cte AS
(
SELECT game_id, CASE WHEN COUNT(interaction_type) = 0 THEN 'No Social Interaction'
					 WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 1 THEN 'One Sided Interaction'
					 WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 2
						AND COUNT(DISTINCT CASE WHEN interaction_type = 'custom_typed' THEN user_id END) = 0 THEN 'Both Sided Interaction without Custom Typed'
					WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 2
						AND COUNT(DISTINCT CASE WHEN interaction_type = 'custom_typed' THEN user_id END) > 0 THEN 'Both Sided Interaction with Custom Typed'
					 END AS g_type
FROM user_interactions
GROUP BY game_id
)
SELECT g_type, COUNT(*) * 1.0/COUNT(*) OVER() AS perc FROM cte GROUP BY g_type;
