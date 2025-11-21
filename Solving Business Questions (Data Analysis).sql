									-- Solving Business Questions (Data Analysis) --

-- To Check
SELECT * FROM Tb_netflix;

-- Q1. Count the number of Movies vs TV Shows.
SELECT
	type AS Show_Types,
	COUNT(Show_Id) AS Total_Count
FROM Tb_netflix
GROUP BY type
ORDER BY Total_Count DESC;

-- Q2. Find the most common rating for movies and TV shows.
SELECT
    Show_Types,
    rating
FROM (
    SELECT
        type AS Show_Types,
        rating,
        COUNT(Show_Id) AS Total_Count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(Show_Id) DESC) as Ranking
    FROM Tb_netflix
    GROUP BY type, rating
) AS r1
WHERE Ranking = 1;

-- Q3. List all movies released in the year 2020.
SELECT
	*
FROM Tb_netflix
WHERE type = 'Movie'
	AND release_year = 2020
ORDER BY show_id ASC;

-- Q4. Find the top 5 countries with the most content on Netflix.
SELECT
    TRIM(New_Country) AS Country,
    COUNT(Show_Id) AS Total_Show_Count
FROM Tb_netflix
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(Country, ',')) AS New_Country
GROUP BY TRIM(New_Country)
ORDER BY Total_Show_Count DESC
LIMIT 5;

-- Q5. Identify the longest movie.
SELECT
	*
FROM Tb_netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS INTEGER) DESC
LIMIT 1;

-- Q6. Find content added in the last 5 years.
SELECT
	*
FROM Tb_netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 Years';

-- Q7. Find all the movies/TV shows by director 'Rajiv Chilaka'.
SELECT
	*
FROM Tb_netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- Q8. List all TV shows with more than 5 seasons.
SELECT *
FROM Tb_netflix
WHERE type = 'TV Show'
  AND CAST(
        REPLACE(
            REPLACE(LOWER(duration), ' seasons', ''), 
            ' season', ''
        ) AS INTEGER
      ) > 5;

-- Q9. Count the number of content items in each genre.
SELECT
    TRIM(New_Genre) AS Genre,
    COUNT(Show_Id) AS Total_Show_Count
FROM Tb_netflix
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS New_Genre
GROUP BY TRIM(New_Genre)
ORDER BY Total_Show_Count DESC;

/* Q10. Find each year and the average numbers of content release in India (only) on netflix.
		Return top 5 year with highest avg content release.
*/
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*) AS Yearly_Content,
	ROUND(
		COUNT(*):: NUMERIC/(SELECT COUNT(*) FROM Tb_netflix WHERE Country = 'India'):: NUMERIC * 100
		, 2) AS AVG_Content_Per_Year
FROM Tb_netflix
WHERE Country = 'India'
GROUP BY EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))
ORDER BY AVG_Content_Per_Year DESC
LIMIT 5;

-- Q11. List all movies that are documentaries.
SELECT
	*
FROM Tb_netflix
WHERE listed_in ILIKE '%documentaries%';

-- Q12. Find all content without a director.
SELECT
	*
FROM Tb_netflix
WHERE director IS NULL;

-- Q13. Find how many movies actor 'Salman Khan' appeared in last 10 years.
SELECT
	*
FROM Tb_netflix
WHERE casts ILIKE '%Salman Khan%'
	AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- Q14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
    TRIM(New_Casts) AS Casts,
    COUNT(Show_Id) AS Total_Show_Count
FROM Tb_netflix
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(Casts, ',')) AS New_Casts
WHERE Country ILIKE '%India%'
  AND Type = 'Movie'
GROUP BY TRIM(New_Casts)
ORDER BY Total_Show_Count DESC
LIMIT 10;

/* Q15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
		Label content containing these keywords as 'Bad' and all other content as 'Good'.
		Count how many items fall into each category.
*/
WITH New_Table AS
(
	SELECT
		*,
		CASE
			WHEN description ILIKE '%kill%'
				OR description ILIKE '%violence%' THEN 'Bad_Content'
			ELSE 'Good_Content'
		END AS Content_Category
	FROM Tb_netflix
)
SELECT
	Content_Category,
	COUNT(Show_Id) AS Total_Content
FROM New_Table
GROUP BY Content_Category
ORDER BY Total_Content DESC;

														-- END --