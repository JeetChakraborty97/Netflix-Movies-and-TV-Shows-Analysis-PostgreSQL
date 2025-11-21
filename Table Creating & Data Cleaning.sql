									-- Netflix Movies & TV Shows Data Analysis --
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

-- Notice: Upon running the previous query wrong values were seen in the 'rating' column.

-- Filding the wrong value rows
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

-- Checking for Duplicate Titles
SELECT
	Title,
	COUNT(*) AS Duplicate_Count
FROM Tb_netflix
GROUP BY Title
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

-- No Duplicates Were Found