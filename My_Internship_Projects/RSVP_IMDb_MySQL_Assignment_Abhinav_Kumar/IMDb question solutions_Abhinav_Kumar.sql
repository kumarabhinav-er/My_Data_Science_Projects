USE imdb;

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SHOW TABLES;

SELECT COUNT(*) AS Total_Rows_in_movie_table
FROM movie;
-- There are total of 7997 rows in movie table.

SELECT COUNT(*) AS Total_Rows_in_director_mapping_table
FROM director_mapping;
-- There are total of 3867 rows in director_mapping table. 

SELECT COUNT(*) AS Total_Rows_in_genre_table
FROM genre;
-- There are total of 14662 rows in genre table.

SELECT COUNT(*) AS Total_Rows_in_names_table
FROM names;
-- There are total of 25735 rows in names table.

SELECT COUNT(*) AS Total_Rows_in_ratings_table
FROM ratings;
-- There are total of 7997 rows in ratings table.

SELECT COUNT(*) AS Total_Rows_in_role_mapping_table
FROM role_mapping;
-- There are total of 15615 rows in role_mapping table.








-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS total_ID_nulls, 
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS total_title_nulls, 
	SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS total_year_nulls,
	SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS total_date_published_nulls,
	SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS total_duration_nulls,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS total_country_nulls,
	SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS total_worlwide_gross_income_nulls,
	SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS total_languages_nulls,
	SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS total_production_company_nulls

FROM movie;

-- There are 4 columns which have null values in them and those are listed below:
	-- 1. country
    -- 2. worldwide_gross_income
    -- 3. languages
    -- 4. production_company
    
        


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT Year,
		COUNT(id) AS number_of_movies
FROM movie
GROUP BY year        
ORDER BY year;

        

SELECT MONTH(date_published) AS month_num,
		COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num        
ORDER BY month_num;





/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT SUM(number_of_movies) AS total_number_of_movies_produced_by_USA_or_India  -- Adding number of movies produced in the USA and India
FROM
(SELECT year,
		COUNT(id) AS number_of_movies,
        country
FROM movie
WHERE year = 2019 AND (country LIKE '%USA%' OR country LIKE '%India%')  -- Filtering by country 
GROUP BY country        -- Grouping by country
ORDER BY number_of_movies DESC) AS sub;




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(genre)         -- Taking distinct genre for all movies
FROM genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


-- genre with highest number of movies produced overall
SELECT DISTINCT(genre),
		COUNT(DISTINCT movie_id) AS total_count_of_movies_in_a_particular_genre   -- counting the number of movies for distinct generes
FROM genre
GROUP BY genre   -- grouping by genre
ORDER BY total_count_of_movies_in_a_particular_genre DESC
LIMIT 1;   -- limiting the output to get the genere with highest number of movies


-- genre with highest number of movies produced for the last year
SELECT g.genre, 
		m.year AS movies_release_year,
		COUNT(g.movie_id) AS total_count_of_movies_in_a_particular_genre
FROM movie m
LEFT JOIN genre g
	ON m.id = g.movie_id
WHERE m.year = 2019
GROUP BY g.genre
ORDER BY total_count_of_movies_in_a_particular_genre DESC
LIMIT 1;





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:



WITH only_one_genre AS
(
SELECT movie_id, COUNT(genre) AS count_of_movies
FROM genre
GROUP BY movie_id
HAVING count_of_movies = 1
)
SELECT COUNT(count_of_movies) AS movie_with_single_genre     -- counting movies with only one genre 
FROM only_one_genre;







/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH gen_mov_summary AS       -- common table expression
(
SELECT g.movie_id,
		g.genre,
        m.id,
        m.title,
        m.duration
FROM genre g
LEFT JOIN movie m        -- joining movie table with genre table
	ON g.movie_id = m.id
) 
SELECT genre,
	ROUND(AVG(duration),2) AS avg_duration      -- Rounding the average for movie duration 
FROM gen_mov_summary    
GROUP BY genre
ORDER BY avg_duration DESC;





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank AS       -- common table expression
(
SELECT  g.genre,
		COUNT(g.movie_id) AS movie_count,
        RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank	   -- using RANK() function for genre ranking 
FROM genre g
INNER JOIN movie m         -- joinging movie table with genre table
	ON g.movie_id = m.id
GROUP BY g.genre        
)
SELECT *
FROM genre_rank
WHERE genre = 'Thriller';      -- filtering by 'Thriller' genre









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating,       -- minimun avg_rating
		MAX(avg_rating) AS max_avg_rating,       -- maximun avg_rating
		MIN(total_votes) AS min_total_votes,    -- minimun total_votes
		MAX(total_votes) AS max_total_votes,     -- maximun total_votes
		MIN(median_rating) AS min_median_rating,   -- minimun median_rating
		MAX(median_rating) AS max_median_rating    -- maximun median_rating
FROM ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


SELECT m.title AS title,
		avg_rating,
        RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank -- using RANK() function to rank movie on their of avg_rating
FROM movie m 
INNER JOIN ratings r
	ON m.id = r.movie_id
LIMIT 10;    -- Getting top 10 results 
		







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
		COUNT(movie_id) AS movie_count  -- counting movies
FROM ratings r 
INNER JOIN movie m
	ON r.movie_id = m.id
GROUP BY median_rating     -- grouping by median_rating
ORDER BY median_rating;    








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT  production_company,
		COUNT(m.id) AS movie_count,
        RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_company_rank  -- using RANK() function to determine rank of production house
FROM movie m
INNER JOIN ratings r
		ON r.movie_id = m.id
WHERE (avg_rating > 8) AND (production_company IS NOT NULL)      -- filtering to get the desired output
GROUP BY production_company;   





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT gen_mov_summary.genre,
		COUNT(gen_mov_summary.movie_id) AS movie_count   
FROM                                                                     -- subquery
(
SELECT  m.id,
		g.movie_id,
		m.date_published,
		m.country,
        g.genre
FROM movie m 
LEFT JOIN genre g
	ON m.id = g.movie_id
WHERE (date_published BETWEEN '2017-03-01' AND '2017-03-31') AND (country LIKE '%USA%')    -- filtering using various given conditions
ORDER BY date_published
) AS gen_mov_summary
INNER JOIN ratings r
	ON gen_mov_summary.id = r.movie_id
WHERE total_votes > 1000    -- filtering on basis of total_votes
GROUP BY genre
ORDER BY movie_count DESC;




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  m.title,
		r.avg_rating,
        g.genre        
FROM movie m 
INNER JOIN genre g     -- joining genre table with movie table
	ON m.id = g.movie_id
INNER JOIN ratings r    -- joining ratings table with movie table
	ON m.id = r.movie_id
WHERE (avg_rating > 8) AND (title LIKE 'The%')   -- filtering out on given conditions
ORDER BY r.avg_rating DESC;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:



SELECT  r.median_rating,
		COUNT(movie_id) AS movie_count
FROM movie m 
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE (date_published BETWEEN '2018-04-01' AND '2019-04-01') AND (median_rating = 8)    -- filtering out on given conditions
GROUP BY median_rating;





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT (CASE WHEN total_german_movies_votes > total_italian_movies_votes  THEN 'Yes' ELSE 'No' END) AS 'output'
FROM
(SELECT SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS total_german_movies_votes,
        SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS total_italian_movies_votes

FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id) AS a;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_genre_summary AS                       -- common table expression
(
SELECT genre,
		COUNT(g.movie_id) AS movie_count_in_genre,
        RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM movie m
LEFT JOIN genre g                        -- joining genre table with movie table
	ON m.id = g.movie_id
INNER JOIN ratings r                     -- joining ratings table with movie table
	ON m.id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
LIMIT 3   
)
SELECT  n.name AS director_name,
		COUNT(g.movie_id) AS movie_count				
FROM movie m 
INNER JOIN ratings r                     -- joining ratings table with movie table
	ON m.id = r.movie_id
INNER JOIN genre g                        -- joining genre table with movie table
    ON m.id = g.movie_id
INNER JOIN director_mapping dm          -- joining director_mapping table with movie table
	ON m.id = dm.movie_id
INNER JOIN names n                      -- joining names table with director_mapping table
	ON dm.name_id = n.id,
top_genre_summary    
WHERE g.genre IN (top_genre_summary.genre) AND  (avg_rating > 8)   -- filtering to get required results
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;






/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

  

SELECT  n.name actor_name,
        COUNT(r.movie_id) AS movie_count
FROM movie m
INNER JOIN ratings r                           -- joining ratings table with movie table
	ON m.id = r.movie_id
INNER JOIN role_mapping rm                     -- joining role_mapping table with movie table
	ON m.id = rm.movie_id
INNER JOIN names n                             -- joining names table with role_mapping table
	ON rm.name_id = n.id
WHERE r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;                            -- Getting top two actors




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT  m.production_company,
        SUM(r.total_votes) AS vote_count,
        DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank         -- using DENSE_RANK() function on basis of total_votes to movies produced by production_company
FROM movie m
INNER JOIN ratings r              -- joining ratings table with movie table
	ON m.id = r.movie_id
GROUP BY m.production_company    -- grouping by production company
LIMIT 3;                         -- getting top three production company




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT  n.name AS actor_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) , 2) AS actor_avg_rating,
        DENSE_RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) , 2) DESC) AS actor_rank    -- using dense_rank() function for ranking on weighted average
        
FROM movie m
INNER JOIN ratings r                     -- joining ratings table with movie table
	ON m.id = r.movie_id
INNER JOIN role_mapping rm               -- joining role_mapping table with movie table
	ON m.id = rm.movie_id
INNER JOIN names n                       -- joining names table with role_mapping table
	ON rm.name_id = n.id
WHERE (country LIKE '%India%') AND (rm.category = 'actor')          -- filtering using various given conditions
GROUP BY actor_name
HAVING movie_count >= 5
LIMIT 1;                        -- getting top actor






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT  n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) , 2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) , 2) DESC) AS actress_rank   -- using dense_rank for ranking on weighted average
        
FROM movie m
INNER JOIN ratings r                 -- joining ratings table with movie table
	ON m.id = r.movie_id
INNER JOIN role_mapping rm           -- joining role_mapping table with movie table
	ON m.id = rm.movie_id
INNER JOIN names n                   -- joining names table with role_mapping table
	ON rm.name_id = n.id
WHERE (country LIKE '%India%') AND (rm.category = 'actress') AND (m.languages LIKE '%Hindi%')      -- filtering using various given conditions
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;                          -- getting top five actress







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
		r.avg_rating,
        CASE WHEN avg_rating > 8 THEN 'Superhit movies'
			 WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
             WHEN avg_rating BETWEEN 5 AND 7  THEN 'One-time-watch movies'
             WHEN avg_rating < 5 THEN 'Flop movies'
        END AS movie_classification     

FROM movie m
INNER JOIN genre g                     -- joining genre table with movie table
	ON m.id = g.movie_id
INNER JOIN ratings r                   -- joining ratings table with movie table
	ON m.id = r.movie_id
WHERE g.genre = 'Thriller'              -- filtering on thriller genre
ORDER BY r.avg_rating DESC;







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
		ROUND(AVG(m.duration),2) AS avg_duration,
        ROUND((SUM(AVG(m.duration)) OVER w1), 2) AS running_total_duration,
		ROUND(AVG(AVG(m.duration)) OVER w2, 2) AS moving_avg_duration
FROM movie m
INNER JOIN genre g                     -- joining genre table with movie table
	ON m.id = g.movie_id
GROUP BY g.genre
WINDOW w1 AS (ORDER BY AVG(m.duration) ROWS UNBOUNDED PRECEDING),                      
	   W2 AS (ORDER BY AVG(m.duration) ROWS 5 PRECEDING);







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_three_genre AS                            -- common table expression
(		
SELECT  g.genre,
		COUNT(g.movie_id) AS movie_count
FROM genre g 
INNER JOIN movie m                            -- joining movie table with genre table
	ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(g.movie_id) DESC
LIMIT 3
),
top_five_movies AS                           -- common table expression
(             
SELECT  g.genre AS genre,
        m.year,
        m.title AS movie_name,
        m.worlwide_gross_income,
        DENSE_RANK() OVER(PARTITION BY  m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank   -- using dense_rank function and partitioning over year

FROM movie m
INNER JOIN genre g                                    -- joining genre table with movie table
	ON m.id = g.movie_id
WHERE g.genre IN (SELECT genre FROM top_three_genre)
)
SELECT *
FROM top_five_movies
WHERE movie_rank <= 5;
        







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



SELECT  m.production_company,
		COUNT(m.id) AS movie_count,
        DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank     -- using dense_rank function on movie count
FROM movie m
INNER JOIN ratings r                             -- joining ratings table with movie table
	ON m.id = r.movie_id
WHERE (POSITION(',' IN languages)>0) AND (production_company IS NOT NULL) AND (r.median_rating >= 8)    -- filtering to get required results
GROUP BY m.production_company
ORDER BY movie_count DESC    
LIMIT 2;     -- getting top two production houses




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT  n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) , 2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
FROM movie m
INNER JOIN genre g                    -- joining genre table with movie table
	ON m.id = g.movie_id
INNER JOIN ratings r                 -- joining ratings table with movie table
	ON m.id = r.movie_id
INNER JOIN role_mapping rm           -- joining role_mapping table with movie table
	ON m.id = rm.movie_id
INNER JOIN names n                   -- joining names table with role_mapping table
	ON rm.name_id = n.id
WHERE (g.genre = 'Drama') AND (rm.category = 'actress') AND (avg_rating > 8)     -- filtering to get desired output
GROUP BY actress_name
LIMIT 3;              -- getting top three actress







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH movie_date_summary AS                 -- common table expression
(
SELECT  dm.name_id, 
		n.name, 
        dm.movie_id,
        m.date_published, 
        LEAD(date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY date_published, dm.movie_id) AS date_next_movie
FROM director_mapping dm
INNER JOIN names AS n                   -- joining names table with director_mapping table
	ON dm.name_id = n.id 
INNER JOIN movie AS m                    -- joining movie table with director_mapping table
	ON dm.movie_id = m.id
),
date_difference_summary AS                      -- common table expression
(
SELECT *, DATEDIFF(date_next_movie, date_published) AS date_diff          -- calculating date difference between two consecutive movies of a director
FROM movie_date_summary
 ),
 avg_inter_days_summary AS                      -- common table expression
 (
SELECT  name_id, 
		AVG(date_diff) AS avg_inter_movie_days                    -- calculating average of date difference
FROM date_difference_summary
GROUP BY name_id
 ),  
final_result_summary AS                      -- common table expression
(
SELECT  dm.name_id AS director_id,
		n.name AS director_name,
        COUNT(dm.movie_id) AS number_of_movies,
        ROUND(avg_inter_movie_days) AS avg_inter_movie_days,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) , 2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration,
		ROW_NUMBER() OVER(ORDER BY COUNT(dm.movie_id) DESC) AS director_row_rank
FROM movie m
INNER JOIN director_mapping dm              -- joining director_mapping table with movie table
	ON m.id = dm.movie_id
INNER JOIN names n                          -- joining names table with director_mapping table
	ON dm.name_id = n.id
INNER JOIN ratings r                        -- joining ratings table with movie table
    ON m.id = r.movie_id
INNER JOIN avg_inter_days_summary AS a         -- joining avg_inter_days_summary CTE with director_mapping table
	ON a.name_id = dm.name_id    
GROUP BY director_id 
)

SELECT 	director_id,
		director_name,
        number_of_movies,
        avg_inter_movie_days,
        avg_rating,
        total_votes,
        min_rating,
        max_rating,
        total_duration
FROM final_result_summary        
LIMIT 9;    -- getting top nine directors based on number of movies

    