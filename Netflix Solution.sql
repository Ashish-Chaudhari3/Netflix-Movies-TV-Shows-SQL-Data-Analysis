use netflix_db;

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year VARCHAR(55),
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


desc netflix;
select * from netflix;

select count(*) from netflix;

select distinct type from netflix;


-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows

select type,
count(*) as total_content
from netflix
group by type;



-- 2. Find the most common rating for movies and TV shows

select type,
rating
from
( select type,
rating,
count(*),
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by type,rating) as t1
where ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

select *
from netflix
where type = "Movie" and release_year = "2020";

-- 4. Find the average duration of movies on Netflix

WITH MovieDuration AS (
    SELECT 
        CAST(REPLACE(duration, ' min', '') AS UNSIGNED) AS minutes
    FROM netflix
    WHERE type = 'Movie'
)
SELECT AVG(minutes) AS avg_movie_duration
FROM MovieDuration;

-- 5. Identify the longest movie

SELECT *
FROM netflix
WHERE type = 'Movie'
and duration = (select max(duration) from netflix);

-- 6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %e, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director like "%Rajiv Chilaka%";
 
-- 8. List all TV shows with more than 5 seasons

select * from netflix
where type= "TV Show"
and duration > '5 Seasons';

-- 9. Find the earliest and latest release years on Netflix

WITH Years AS (
    SELECT MIN(release_year) AS earliest_year,
           MAX(release_year) AS latest_year
    FROM netflix
)
SELECT * FROM Years;


-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select year(STR_TO_DATE(date_added, '%M %e, %Y')) as Year,
count(*) as yearly_content,
count(*)/(select count(*) from netflix where country = 'India')*100 as avg_content
from netflix
where country ="India"
group by Year
order by avg_content desc
limit 5;

-- 11. List all movies that are documentaries

select * from netflix
where type = 'Movie' 
and  listed_in like '%Documentaries%';

-- 12. Find all content without a director

select * from netflix
where director = '';


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where casts like '%Salman Khan%'
and release_year > year(curdate())-10;

-- 14. Classify content as “Old” if released before 2010, otherwise “New”

WITH ReleaseCategory AS (
    SELECT 
        title,
        release_year,
        CASE WHEN release_year < 2010 THEN 'Old'
             ELSE 'New' END AS category
    FROM netflix
)
SELECT category, COUNT(*) AS total
FROM ReleaseCategory
GROUP BY category;



-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


with new_table as (
select * ,
( case when description like '%kill%' or description like '%violence%' then 'Bad_content'
  else 'Good_content'
  end) as category
from netflix
)
select category,
count(*) as total_content
from new_table
group by category;

-- 9


