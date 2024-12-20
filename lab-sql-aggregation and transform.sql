-- Challenge 1
-- 1You need to use SQL built-in functions to gain insights relating to the duration of movies:
--  1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT	MIN(sf.length) as min_duration, 
		MAX(sf.length) as max_duration
FROM sakila.film as sf;

--  1.2. Express the average movie duration in hours and minutes. Don't use decimals.
--  Hint: Look for floor and round functions.

SELECT 
	CONCAT(
    FLOOR(AVG(sf.length) / 60), ":",
    ROUND(AVG(sf.length) % 60)
    ) AS Promedio_duracion
FROM sakila.film AS sf;

-- 2 You need to gain insights related to rental dates:
--  2.1 Calculate the number of days that the company has been operating.
--  Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT datediff(max(sr.rental_date), min(sr.rental_date)) as operating_days
FROM sakila.rental as sr;

--  2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT sr.* , 
		DATE_FORMAT(sr.rental_date, '%m') AS month,
        DATE_FORMAT(sr.rental_date, '%W') AS weekday
FROM sakila.rental as sr
LIMIT 20;

--  2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
SELECT * ,
       CASE
           WHEN WEEKDAY(rental_date) IN (6, 7) THEN 'weekend'
           ELSE 'workday'
       END AS DAY_TYPE
FROM sakila.rental as sr;

-- 3 You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.
SELECT sf.title as título,
		IFNULL(sf.rental_duration, "NOT AVAILABLE") as duracion_alquiler
FROM sakila.film as sf
ORDER BY sf.title ASC;

-- 4 Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.
SELECT 
    CONCAT(scu.first_name, ' ', scu.last_name) AS full_name, 
    LEFT(email, 3) AS email_prefix
FROM sakila.customer as scu
ORDER BY last_name ASC;

-- Challenge 2
-- 1 Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
--  1.1 The total number of films that have been released.
SELECT COUNT(film_id)
FROM sakila.film as sf;

--  1.2 The number of films for each rating.
SELECT sf.rating, COUNT(*) as total_por_rating
FROM sakila.film as sf
GROUP BY sf.rating;

--  1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
SELECT rating, COUNT(film_id) as total_por_rating
FROM sakila.film as sf
GROUP BY rating
ORDER BY total_por_rating DESC;

-- 2 Using the film table, determine:
--  2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
SELECT sf.rating, ROUND(AVG(sf.lenght),2) as mean_duration
FROM sakila.film as sf
GROUP BY rating
ORDER BY mean_duration DESC;

--  2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
SELECT sf.rating, ROUND(AVG(sf.lenght)/60,2) as mean_duration
FROM sakila.film as sf
GROUP BY rating
HAVING mean_duration >=2
ORDER BY mean_duration DESC;
-- 3 Bonus: determine which last names are not repeated in the table actor.
SELECT sac.last_name
FROM sakila.actor AS sac
GROUP BY sac.last_name
HAVING COUNT(sac.last_name) = 1;

