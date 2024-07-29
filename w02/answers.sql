-- Exercise 1

-- Query 1
SELECT * FROM people WHERE id = 12345;
-- No need to do anything because the `id` field has a primary index on it already (it was defined as the primary key of the people table)

-- Query 2
SELECT * FROM people WHERE first_name LIKE 'Ab%';
-- We should create an index on the first_name field
ALTER TABLE people
ADD INDEX idx_first_name (first_name);

-- But if we want to find people whose first_name ends with a string
-- SELECT * FROM people WHERE first_name LIKE '%Ab';
-- Creating an index on first_name will not help

-- Query 3
SELECT first_name, last_name
FROM people join cities
ON current_location = cities.id
WHERE cities.name = 'Melbourne';
-- We should create an index on the `name` column of the cities table for the WHERE condition
-- and another index on the current_location of the people table for the JOIN condition
ALTER TABLE cities
ADD INDEX idx_name (name);

ALTER TABLE people
ADD INDEX idx_current_location (current_location);

--------------------------------

-- Exercise 2

-- Query 1
SELECT * FROM people WHERE birth_location = current_location;
-- We must examine every record to answer this query
-- Without index, the operation is "table scan"

-- If we create an index on the combination of (birth_location, current_location)
-- We still have to scan every index, but it is "index scan"
-- In general, index entries are smaller than data records
-- Less number of disk block reading => faster

CREATE INDEX idx_birth_current
ON people(birth_location, current_location);

-- Query 2
SELECT * FROM people WHERE birth_date >= '1990-01-01' AND birth_date <= '2000-02-02';
-- Creating an index on birth_date column will help
CREATE INDEX idx_birth_date
ON people(birth_date);


-- Query 3

-- The students have provided excellent queries
-- to answer the question. Good job!

-- But in terms of performance, it's quite difficult to
-- create indexes to improve the queries due to
-- the multi-dimensional nature of the queries

-- An approximation: search for cities within a bounding box
-- In this case, the regular indexes can help

SELECT * FROM cities WHERE lat >= sydney_lat - deltaY AND lat <= sydney_lat + deltaY AND lng >= sydney_lng - deltaX AND lng <= sydney_lng + deltaX;

CREATE INDEX idx_lat_lng
ON cities(lat, lng);

-- deltaX and deltaY: how big you want the bounding rectangle is

-- Creating an index on (lat, lng) will help improve the search for cities in a bounding rectangle. But that's all. The cities in the result are not necessarily nearer to Sydney than the cities not in the results (why?).


--------------------------------

-- Exercise 3

CREATE FULLTEXT INDEX idx_content
ON news(content);

SELECT *, MATCH(`content`) AGAINST ('Database Applications' IN NATURAL LANGUAGE MODE) AS score FROM news ORDER BY score DESC;

SELECT * FROM news
WHERE MATCH(`content`) AGAINST ('+Machine Learning -Study' IN BOOLEAN MODE);
