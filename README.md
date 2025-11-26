# Netflix Movies and TV Shows Analysis (PostgreSQL)

![Logo 2](https://github.com/user-attachments/assets/6b1594f5-ebe5-436e-a378-3a7bf2040b51)

# Background

I worked with the netflix_titles.csv dataset (~8,809 content records plus header) containing Netflix catalogue metadata: show_id, type (Movie/TV Show), title, director, cast(s), country, date_added, release_year, rating, duration, listed_in (genres), and description.

I created a relational table Tb_netflix, performed data-cleaning (removed rows with misplaced values, trimmed text, checked duplicates), converted and parsed fields for analysis (e.g., parsed duration numeric minutes, converted date_added to dates, split multi-valued country and listed_in using STRING_TO_ARRAY + UNNEST), and fixed or identified NULL/missing director entries.

# Role 

Data Analyst (SQL-focused) — responsible for end-to-end exploratory data analysis and preparatory data engineering on a single-source streaming catalogue to produce business-friendly insights for content strategy, catalogue curation, and regional marketing decisions.

# Objective / Problem Statement

Design and implement an SQL-driven analysis of the Netflix catalogue to answer business questions that inform content strategy and regional programming decisions.

The project objective is: Using Tb_netflix as the canonical table, clean and transform the dataset, then produce actionable insights that describe the catalogue composition, content safety signals, regional production strength (with emphasis on India), creative
contributors (directors/actors), and temporal trends in releases — enabling product, programming, and marketing teams to prioritise content acquisition, promotion, and regional investment.

# Dataset

The data for this project is sourced from the Kaggle dataset:

• Dataset Link: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

# Project Structure

### 1) Database Setup

Database Creation: The project starts by creating a database named SQL_Project_2_Netflix_Data_Analysis.

Table Creation: A table named Tb_netflix is created to store the Netflix data from the netflix.csv file.

```SQL
-- Creating the tables

CREATE TABLE Tb_netflix (
    Show_Id VARCHAR(10) PRIMARY KEY,
    Type VARCHAR(12),
    Title VARCHAR(150),
    Director VARCHAR(220),
    Casts VARCHAR(800),
    Country VARCHAR(150),
    Date_Added VARCHAR(70),
    Release_Year INT,
    Rating VARCHAR(10),
    Duration VARCHAR(20),
    Listed_In VARCHAR(500),
    Description TEXT
);
```

### 2) Data Cleaning & Exploration

Netflix data from the netflix.csv file was imported to Tb_netflix using the 'Import/Export Data...' option in PostgreSQL.

The data was checked and some key values were found.

```SQL
-- To Check
SELECT * FROM Tb_netflix;

-- Finding Some Key Values
SELECT
	COUNT(Show_Id) AS Total_Movies_and_Shows
FROM Tb_netflix;

SELECT
	DISTINCT type AS Distinct_Types_of_Content
FROM Tb_netflix;

SELECT
	DISTINCT rating AS Distinct_Types_of_Rating
FROM Tb_netflix;
```

Some wrong values were seen in the 'rating' column and were removed.

```SQL
-- Finding the wrong value rows
SELECT
	*
FROM Tb_netflix
WHERE rating = '74 min'
   OR rating = '66 min'
   OR rating = '84 min';

-- Removing the wrong value rows for ease.
DELETE
FROM Tb_netflix
WHERE rating = '74 min'
   OR rating = '66 min'
   OR rating = '84 min';
```
Duplicate titles were checked, and none were found.

```SQL
-- Checking for Duplicate Titles
SELECT
	Title,
	COUNT(*) AS Duplicate_Count
FROM Tb_netflix
GROUP BY Title
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

-- No Duplicates Were Found
```

### 3) Data Analysis

The following business questions were answered.

1. Count the number of Movies vs TV Shows.

```SQL
SELECT
	type AS Show_Types,
	COUNT(Show_Id) AS Total_Count
FROM Tb_netflix
GROUP BY type
ORDER BY Total_Count DESC;
```

2. Find the most common rating for movies and TV shows.

```SQL
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
```

3. List all movies released in the year 2020.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE type = 'Movie'
	AND release_year = 2020
ORDER BY show_id ASC;
```

4. Find the top 5 countries with the most content on Netflix.

```SQL
SELECT
    TRIM(New_Country) AS Country,
    COUNT(Show_Id) AS Total_Show_Count
FROM Tb_netflix
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(Country, ',')) AS New_Country
GROUP BY TRIM(New_Country)
ORDER BY Total_Show_Count DESC
LIMIT 5;
```

5. Identify the longest movie.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS INTEGER) DESC
LIMIT 1;
```

6. Find content added in the last 5 years.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 Years';
```

7. Find all the movies/TV shows by director 'Rajiv Chilaka'.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

8. List all TV shows with more than 5 seasons.

```SQL
SELECT *
FROM Tb_netflix
WHERE type = 'TV Show'
  AND CAST(
        REPLACE(
            REPLACE(LOWER(duration), ' seasons', ''), 
            ' season', ''
        ) AS INTEGER
      ) > 5;
```

9. Count the number of content items in each genre.

```SQL
SELECT
    TRIM(New_Genre) AS Genre,
    COUNT(Show_Id) AS Total_Show_Count
FROM Tb_netflix
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS New_Genre
GROUP BY TRIM(New_Genre)
ORDER BY Total_Show_Count DESC;
```

10. Find each year and the average number of content releases in India (only) on Netflix. Return the top 5 years with the highest average content release.

```SQL
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
```

11. List all movies that are documentaries.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE listed_in ILIKE '%documentaries%';
```

12. Find all content without a director.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE director IS NULL;
```

13. Find how many movies actor 'Salman Khan' appeared in last 10 years.

```SQL
SELECT
	*
FROM Tb_netflix
WHERE casts ILIKE '%Salman Khan%'
	AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```SQL
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
```

15. Categorise the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```SQL
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
```

# Key Findings

1. Catalogue composition: A clear split between Movies and TV Shows that informs content scheduling and homepage prioritization. 

2. Content guidance mix: The most common ratings per content type were identified — useful for age-targeted marketing and parental controls. 

3. Timely releases: All movies released in 2020 were enumerated — helpful for curated seasonal collections or retrospectives. 

4. Regional volume leaders: Top 5 countries by content volume were identified, highlighting which markets contribute the most catalogue items. 

5. Outlier durations: The single longest movie was found — useful for spotlight features or "epic" programming tags. 

6. Recently added content: Items added within the last five years were isolated for freshnessdriven promotions. 

7. Director-level insight: All titles by Rajiv Chilaka were listed, enabling director-focused campaigns. 

8. Binge-worthy shows: TV shows with more than 5 seasons were flagged — prime candidates for binge playlists. 

9. Genre distribution: Counts per genre (by splitting listed_in) reveal genre concentrations and gaps for content acquisition strategy. 

10. India release trends: Per-year averages of content releases in India were computed; top 5 years with the highest averages were identified — guiding regional investment and release timing. 

11. Documentaries: All documentary movies were listed — useful for non-fiction bundles and documentary channels. 

12. Metadata gaps: Content records missing a director were flagged — priority targets for metadata enrichment. 

13. Actor-specific counts: How many movies Salman Khan appeared in over the last 10 years was calculated — useful for talent-focused licensing choices. 

14. Top Indian actors: Top 10 actors by number of movies produced in India were identified — supports influencer and cross-promotion strategies. 

15. Content-safety taxonomy: Content classified as Bad (contains keywords kill or violence in description) vs Good, with counts for each — a quick content-safety filter for moderation/labeling.

# Business Impact 

• Programmatic curation: Build data-driven playlists (e.g., “Binge Classics”, “India: Top Years”, “Documentary Spotlight”) using the lists produced. 

• Acquisition prioritization: Identify genres/countries under-represented in the catalogue for targeted licensing. 

• Marketing & personalization: Use rating and release-year signals to refine campaigns for different user cohorts (age, regional preference). 

• Metadata quality uplift: Target records missing directors for enrichment to improve search/recommendation accuracy. 

• Talent & partnership strategy: Quantify which actors/directors produce the most regional content to inform partnership and promotion deals. 

• Safety & compliance: Quick flagging of potentially violent content to feed tagging and parental-control paths. 

# Key SQL Techniques Used

• DDL: CREATE TABLE Tb_netflix

• Data cleaning: DELETE bad rows, TRIM/REPLACE, simple validation checks

• Date parsing: TO_DATE(date_added, 'Month DD, YYYY')

• Text parsing / multi-valued fields: STRING_TO_ARRAY(..., ',') + CROSS JOIN LATERAL UNNEST(...)

• Type casting: CAST(REPLACE(duration, ' min', '') AS INTEGER)

• Pattern matching and case-insensitive searches: ILIKE '%...%'

• Aggregations and windowing: GROUP BY, COUNT, ORDER BY, EXTRACT(YEAR FROM ...)

• Conditional categorization: CASE on description for content-safety labels

# Conclusion

This project demonstrates a complete end-to-end SQL workflow—from data cleaning and transformation to answering real business questions that uncover patterns in Netflix’s global catalogue. By structuring the dataset into a clean, analysis-ready table and applying advanced SQL techniques such as string parsing, multi-value unnesting, conditional categorisation, and time-based filtering, the analysis delivers clear insights into content distribution, regional trends, talent involvement, genre composition, and metadata quality.
