DESCRIBE step;
DESCRIBE user;
-- Question 1:
SELECT step.title, CONCAT(user.first_name,' ', user.last_name) AS full_name
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
WHERE step_taken.when_finished IS NULL;

-- without join:
select title, first_name, last_name
from step, step_taken, user
where
step.stepID = step_taken.step_id
and
step_taken.user_id = user.userID
and
step_taken.when_finished is null;

SELECT title, CONCAT(first_name,' ', last_name) AS full_name
FROM step, step_taken, user
WHERE step.stepID = step_taken.step_id AND step_taken.user_id = user.userID 
AND step_taken.when_finished is null; 

-- Question 2:
SELECT theme.name, COUNT(DISTINCT step_id) AS count_steps
FROM theme LEFT JOIN step_theme ON theme.themeID = step_theme.theme_id
GROUP BY name
ORDER BY count_steps DESC;

-- Question 3:
SELECT step.title, step.stepID, FORMAT(AVG(step_taken.rating), 2) AS avg_rating
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY step_id
ORDER BY AVG_RATING
LIMIT 1;

-- Question 4:
SELECT stepID, title AS step_title, COUNT(*) AS COUNT_OF_TIME
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
GROUP BY stepID, step_title
ORDER BY COUNT_OF_TIME DESC
LIMIT 2;
-- HAVING COUNT_OF_TIME = MAX(COUNT_OF_TIME)


SELECT step.stepID, step.title, COUNT(*) AS count_of_time
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY stepID
HAVING count_of_time = (SELECT COUNT(*) AS count_of_time
FROM step_taken
GROUP BY step_id
ORDER BY count_of_time DESC LIMIT 1);


-- Question 5:
SELECT TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS age, first_name, last_name
FROM user INNER JOIN user_follow ON user.userID = user_follow.followed_user_id
WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) >= 15 
AND TIMESTAMPDIFF(YEAR, DOB, CURDATE()) <= 18;
-- GROUP BY first_name, last_name;

SELECT DOB, first_name, last_name, COUNT(*) AS NUM_FOLLOWERS
FROM user INNER JOIN user_follow ON user.userID = user_follow.followed_user_id
GROUP BY first_name, last_name, DOB
ORDER BY NUM_FOLLOWERS DESC
LIMIT 1;


SELECT FORMAT(TIMESTAMPDIFF(YEAR, DOB, CURDATE()), 0) AS age, 
user.first_name, user.last_name, COUNT(*) AS num_followers
FROM user INNER JOIN user_follow ON user.userID = user_follow.followed_user_id
GROUP BY first_name, last_name, age
HAVING age >= 15 AND age <= 18
ORDER BY num_followers DESC
LIMIT 1;

-- Question 6:
SELECT stepID, title, COUNT(stepID) AS TIMES_TAKEN
FROM step LEFT OUTER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY stepID, title
HAVING TIMES_TAKEN = 0 OR TIMES_TAKEN = 1;

SELECT stepID
FROM step;

SELECT step_id, count(*)
FROM step_taken
GROUP BY step_id;

-- Question 6 (actually work)
SELECT stepID, step.title, SUM(IF(step_taken.id IS NULL, 0, 1)) AS times_taken
FROM step LEFT OUTER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY stepID, title
HAVING times_taken = 0 OR times_taken = 1;


-- Question 7:
SELECT userID, title, when_started, when_finished
FROM step AS step_panic 
INNER JOIN step_taken AS step_taken_panic
ON step_panic.stepID = step_taken_panic.step_id
INNER JOIN user 
ON step_taken_panic.user_id = user.userID
INNER JOIN step_taken AS step_taken_doing 
ON user.userID = step_taken_doing.step_id
INNER JOIN step AS step_doing
ON step_taken_doing_step_id = step_doing.stepID

WHERE title = 'Doing and being' OR (title = 'Panic' AND when_finished IS NULL);

-- Question 7 (actually work!)
SELECT DISTINCT user.userID, user.first_name, user.last_name 
FROM user INNER JOIN
(SELECT user_id, when_started, when_finished
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
WHERE step.title = 'Panic') AS step_panic
ON user.userID = step_panic.user_id
INNER JOIN
(SELECT user_id, when_started
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
WHERE step.title = 'Doing and being') AS step_doing
ON step_panic.user_id = step_doing.user_id
WHERE timestampdiff(SECOND, step_panic.when_started, step_doing.when_started) > 0
AND NOT EXISTS (SELECT 1 FROM step_taken 
INNER JOIN step ON step_taken.step_id = step.stepID
WHERE step_taken.when_finished IS NOT NULL
AND step.title = 'Panic'
AND step_taken.user_id = user.userID);

SELECT * 
FROM step_taken 
INNER JOIN step ON step_taken.step_id = step.stepID
WHERE step_taken.when_finished IS NOT NULL
AND step.title = 'Panic';

-- Question 8
SELECT step.stepID, step.title, SUM(IF(user.first_name = 'Alice', 1, 0)) AS alice_counts, 
SUM(IF(user.first_name = 'Bob', 1, 0)) AS bob_counts
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
WHERE (user.first_name = 'Alice' OR user.first_name = 'Bob') AND step_taken.when_finished IS NOT NULL
GROUP BY stepID
HAVING alice_counts > 0 AND bob_counts > 0;


-- Question 9
SELECT first_name, last_name, COUNT(interestID)
FROM user INNER JOIN user_interest ON user.userID = user_interest.user_id
INNER JOIN interest ON user_interest.interest_id = interest.interestID
GROUP BY first_name, last_name
ORDER BY COUNT(interestID) DESC
LIMIT 2;

SELECT title, user_id
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
INNER JOIN
(SELECT userID, first_name, last_name
FROM user INNER JOIN user_interest ON user.userID = user_interest.user_id
INNER JOIN interest ON user_interest.interest_id = interest.interestID) AS user_and_interest
ON step_taken.user_id = user_and_interest.userID;

SELECT step.stepID, step.title, SUM(IF(user.first_name = 'Alice', 1, 0)) AS alice_counts, 
SUM(IF(user.first_name = 'Bob', 1, 0)) AS bob_counts
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
WHERE (user.first_name = 'Alice' OR user.first_name = 'Bob') AND step_taken.when_finished IS NOT NULL
GROUP BY stepID
HAVING alice_counts > 0 AND bob_counts > 0;

SELECT * FROM (SELECT userID
FROM user INNER JOIN user_interest ON user.userID = user_interest.user_id
INNER JOIN interest ON user_interest.interest_id = interest.interestID
GROUP BY userID
ORDER BY COUNT(interestID) DESC
LIMIT 1) AS most_interests;

SELECT * FROM (SELECT userID
FROM user INNER JOIN user_interest ON user.userID = user_interest.user_id
INNER JOIN interest ON user_interest.interest_id = interest.interestID
GROUP BY userID
ORDER BY COUNT(interestID) DESC
LIMIT 1 OFFSET 1) AS second_most_interests;

-- actual working (Qs9!!!)
SELECT step.title, 
SUM(IF(most_interests.user_id IS NOT NULL, 1, 0)) AS most_interests_count, 
SUM(IF(second_most_interests.user_id IS NOT NULL, 1, 0)) AS second_most_interests_count
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
LEFT OUTER JOIN 
(SELECT user_id
FROM user_interest
GROUP BY user_id
ORDER BY COUNT(*) DESC
LIMIT 1) AS most_interests
ON step_taken.user_id = most_interests.user_id
LEFT OUTER JOIN
(SELECT user_id
FROM user_interest
GROUP BY user_id
ORDER BY COUNT(*) DESC
LIMIT 1 OFFSET 1) AS second_most_interests
ON step_taken.user_id = second_most_interests.user_id
GROUP BY step.stepID
HAVING most_interests_count > 0 AND second_most_interests_count > 0;

-- shortcut: join step_taken itself by step_id instead of user_id
select a.step_id, a.user_id, b.user_id from 
step_taken a
inner join
step_taken b
on a.step_id = b.step_id
where a.user_id = 16 and b.user_id = 20;


-- Question 10:
SELECT step_id, COUNT(user_id)
FROM step_taken 
GROUP BY step_id
HAVING COUNT(user_id) >= 5;

SELECT DISTINCT a.user_id AS user_A, a.step_id, COUNT(DISTINCT b.user_id) AS count_user_B
-- COUNT(b.user_id) AS count_user_B 
FROM step INNER JOIN step_taken a ON step.stepID = a.step_id 
INNER JOIN step_taken b ON a.step_id = b.step_id
-- INNER JOIN step ON step.stepID = step_taken.step_id
GROUP BY step_id, user_A, title
HAVING (count_user_B-1) >= 5;


SELECT DISTINCT step_taken_A.user_id AS userID, 
title AS step_title, COUNT(DISTINCT step_taken_B.user_id) AS count_other_users
FROM step INNER JOIN step_taken AS step_taken_A ON step.stepID = step_taken_A.step_id 
INNER JOIN step_taken AS step_taken_B ON step_taken_A.step_id = step_taken_B.step_id
GROUP BY userID, step_title
HAVING (count_other_users-1) >= 5;

SELECT DISTINCT step_taken.user_id, 
step.title, COUNT(DISTINCT step_taken_other.user_id)-1 AS count_other_users
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id 
INNER JOIN step_taken AS step_taken_other ON step_taken.step_id = step_taken_other.step_id
GROUP BY user_id, title	
HAVING (count_other_users) >= 5;



-- FINAL TESTING BEFORE SUBMITTING:
SELECT step.title, CONCAT(user.first_name, ' ', user.last_name) AS full_name
FROM step 
INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
WHERE step_taken.when_finished IS NULL;


SELECT theme.name, COUNT(DISTINCT step_id) AS count_steps
FROM theme 
LEFT JOIN step_theme ON theme.themeID = step_theme.theme_id
GROUP BY name
ORDER BY count_steps DESC;

SELECT step.title, step.stepID, FORMAT(AVG(step_taken.rating), 2) AS avg_rating
FROM step 
INNER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY step_id
ORDER BY avg_rating
LIMIT 1;

SELECT step.stepID, step.title, COUNT(*) AS count_of_time
FROM step 
INNER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY stepID
HAVING count_of_time = (SELECT COUNT(*) AS count_of_time
         FROM step_taken
                       GROUP BY step_id
                                                    ORDER BY count_of_time DESC 
         LIMIT 1);


SELECT FORMAT(TIMESTAMPDIFF(YEAR, DOB, CURDATE()), 0) AS age, 
user.first_name, user.last_name, COUNT(*) AS num_followers
FROM user
INNER JOIN user_follow ON user.userID = user_follow.followed_user_id
GROUP BY first_name, last_name, age
HAVING age >= 15 AND age <= 18
ORDER BY num_followers DESC
LIMIT 1;

SELECT stepID, step.title, SUM(IF(step_taken.id IS NULL, 0, 1)) AS times_taken
FROM step LEFT OUTER JOIN step_taken ON step.stepID = step_taken.step_id
GROUP BY stepID, title
HAVING times_taken = 0 OR times_taken = 1;

SELECT DISTINCT user.userID, user.first_name, user.last_name 
FROM user INNER JOIN
(SELECT user_id, when_started, when_finished
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
WHERE step.title = 'Panic') AS step_panic
ON user.userID = step_panic.user_id
INNER JOIN
(SELECT user_id, when_started
FROM step INNER JOIN step_taken ON step.stepID = step_taken.step_id
WHERE step.title = 'Doing and being') AS step_doing
ON step_panic.user_id = step_doing.user_id
WHERE timestampdiff(SECOND, step_panic.when_started, step_doing.when_started) > 0
AND NOT EXISTS (SELECT 1 FROM step_taken 
  INNER JOIN step ON step_taken.step_id = step.stepID
  WHERE step_taken.when_finished IS NOT NULL
  AND step.title = 'Panic'
  AND step_taken.user_id = user.userID);

SELECT step.stepID, step.title, 
SUM(IF(user.first_name = 'Alice', 1, 0)) AS alice_counts, 
SUM(IF(user.first_name = 'Bob', 1, 0)) AS bob_counts
FROM step 
INNER JOIN step_taken ON step.stepID = step_taken.step_id
INNER JOIN user ON step_taken.user_id = user.userID
WHERE (user.first_name = 'Alice' OR user.first_name = 'Bob') 
AND step_taken.when_finished IS NOT NULL
GROUP BY stepID
HAVING alice_counts > 0 AND bob_counts > 0;

SELECT step.title, 
SUM(IF(most_interests.user_id IS NOT NULL, 1, 0)) AS most_interests_count, 
SUM(IF(second_most_interests.user_id IS NOT NULL, 1, 0)) AS second_most_interests_count
FROM step 
INNER JOIN step_taken ON step.stepID = step_taken.step_id
LEFT OUTER JOIN 
(SELECT user_id 
FROM user_interest
GROUP BY user_id
ORDER BY COUNT(*) DESC
LIMIT 1) 
AS most_interests
ON step_taken.user_id = most_interests.user_id
LEFT OUTER JOIN
(SELECT user_id
FROM user_interest
GROUP BY user_id
ORDER BY COUNT(*) DESC
LIMIT 1 OFFSET 1) 
AS second_most_interests
ON step_taken.user_id = second_most_interests.user_id
GROUP BY step.stepID
HAVING most_interests_count > 0 AND second_most_interests_count > 0;

SELECT DISTINCT step_taken.user_id, step.title, 
COUNT(DISTINCT step_taken_other.user_id)-1 AS count_other_users
FROM step 
INNER JOIN step_taken 
ON step.stepID = step_taken.step_id 
INNER JOIN step_taken AS step_taken_other  
ON step_taken.step_id = step_taken_other.step_id
GROUP BY user_id, title	
HAVING (count_other_users) >= 5;

