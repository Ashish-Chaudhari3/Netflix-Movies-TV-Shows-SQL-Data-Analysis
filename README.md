# Netflix-Movies-TV-Shows-SQL-Data-Analysis

![](https://github.com/Ashish-Chaudhari3/Netflix-Movies-TV-Shows-SQL-Data-Analysis/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type,
count(*) as total_content
from netflix
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select *
from netflix
where type = "Movie" and release_year = "2020";
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the average duration of movies on Netflix

```sql
WITH MovieDuration AS (
    SELECT 
        CAST(REPLACE(duration, ' min', '') AS UNSIGNED) AS minutes
    FROM netflix
    WHERE type = 'Movie'
)
SELECT AVG(minutes) AS avg_movie_duration
FROM MovieDuration;
```

**Objective:** To determine the average duration of movies available on Netflix.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
and duration = (select max(duration) from netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %e, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix
where director like "%Rajiv Chilaka%";
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * from netflix
where type= "TV Show"
and duration > '5 Seasons';
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Find the earliest and latest release years on Netflix

```sql
WITH Years AS (
    SELECT MIN(release_year) AS earliest_year,
           MAX(release_year) AS latest_year
    FROM netflix
)
SELECT * FROM Years;
```

**Objective:** To identify the earliest and latest release years of content available on Netflix

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select year(STR_TO_DATE(date_added, '%M %e, %Y')) as Year,
count(*) as yearly_content,
count(*)/(select count(*) from netflix where country = 'India')*100 as avg_content
from netflix
where country ="India"
group by Year
order by avg_content desc
limit 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select * from netflix
where type = 'Movie' 
and  listed_in like '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix
where director = '';
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
where casts like '%Salman Khan%'
and release_year > year(curdate())-10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Classify content as “Old” if released before 2010, otherwise “New”

```sql
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
```

**Objective:** To classify Netflix content into “Old” (before 2010) and “New” (2010 onwards) and count the total in each category.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Recent Additions:** A large volume of content has been added in the past 5 years, emphasizing Netflix’s expansion strategy.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
