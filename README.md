# Netflix-Movies-and-TV-Shows-Analysis-PostgreSQL

![Logo 2](https://github.com/user-attachments/assets/6b1594f5-ebe5-436e-a378-3a7bf2040b51)

# Backgropund

I worked with the netflix_titles.csv dataset (~8,809 content records plus header) containing Netflix catalogue metadata: show_id, type (Movie/TV Show), title, director, cast(s), country, date_added, release_year, rating, duration, listed_in (genres), and description.

I created a relational table Tb_netflix, performed data-cleaning (removed rows with misplaced values, trimmed text, checked duplicates), converted and parsed fields for analysis (e.g., parsed duration numeric minutes, converted date_added to dates, split multi-valued country and listed_in using STRING_TO_ARRAY + UNNEST), and fixed or identified NULL/missing director entries.

# Role 

Data Analyst (SQL-focused) — responsible for end-to-end exploratory data analysis and preparatory data engineering on a single-source streaming catalogue to produce business-friendly insights for content strategy, catalogue curation, and regional marketing decisions.

# Objective / Problem Statement

Design and implement an SQL-driven analysis of the Netflix catalogue to answer business questions that inform content strategy and regional programming decisions.

The project objective is: Using Tb_netflix as the canonical table, clean and transform the dataset, then produce actionable insights that describe the catalogue composition, content safety signals, regional production strength (with emphasis on India), creative
contributors (directors/actors), and temporal trends in releases — enabling product, programming, and marketing teams to prioritize content acquisition, promotion, and regional investment.

# Project Structure

### 1) Database Setup

Database Creation: The project starts by creating a database named SQL_Project_2_Netflix_Data_Analysis.

Table Creation: A table named Tb_netflix is created to store the netflix.csv data.

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

### 2)
