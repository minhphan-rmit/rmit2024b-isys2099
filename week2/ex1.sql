-- Find a person by his/her id (1)
SELECT * 
FROM people
WHERE id = 30;

-- Find people whose first_names 
-- start with 'Ab' (2) 
CREATE INDEX idx_first_name ON people(first_name);

SELECT * 
FROM people
WHERE first_name LIKE 'Ab%';

DROP INDEX idx_first_name ON people(first_name);

-- Display the first and last names of people 
-- whose current city is 'Melbourne' (3)
CREATE INDEX idx_cities_name ON cities(name);
CREATE INDEX idx_people_current_location ON people(current_location);

-- SELECT p.first_name, p.last_name, p.current_location
-- FROM people p
-- JOIN cities c ON p.current_location = c.id
-- WHERE c.name = 'Melbourne';

SELECT first_name, last_name FROM people
WHERE current_location = 
    (SELECT id FROM cities WHERE name = 'Melbourne');

-- Delete the indexes created
DROP INDEX idx_cities_name ON cities;
DROP INDEX idx_people_current_location ON people;

-- Additional question: can you create an index to answer this query efficiently?
-- SELECT * FROM people WHERE first_name LIKE '%Alice%'
-- Create a full-text index on the first_name column
CREATE FULLTEXT INDEX idx_first_name_fulltext ON people(first_name);

-- Query using the full-text index
SELECT *
FROM people
WHERE MATCH(first_name) AGAINST ('Alice' IN BOOLEAN MODE);
