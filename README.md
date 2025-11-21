# Netflix-Movies-and-TV-Shows-Analysis-PostgreSQL

![Logo 2](https://github.com/user-attachments/assets/6b1594f5-ebe5-436e-a378-3a7bf2040b51)

# Backgropund

I worked with the netflix_titles.csv dataset (~8,809 content records plus header) containing Netflix catalogue metadata: show_id, type (Movie/TV Show), title, director, cast(s), country, date_added, release_year, rating, duration, listed_in (genres), and description.

I created a relational table Tb_netflix, performed data-cleaning (removed rows with misplaced values, trimmed text, checked duplicates), converted and parsed fields for analysis (e.g., parsed duration numeric minutes, converted date_added to dates, split multi-valued country and listed_in using STRING_TO_ARRAY + UNNEST), and fixed or identified NULL/missing director entries.

# Objective / Problem Statement

