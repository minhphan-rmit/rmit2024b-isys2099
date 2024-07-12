-- For finding people whose birth_location and current_location are the same
CREATE INDEX idx_people_birth_location ON people(birth_location);
CREATE INDEX idx_people_current_location ON people(current_location);

SELECT * 
FROM people 
WHERE birth_location = current_location;

-- For calculating the number of people in a city whose age is in a range
CREATE INDEX idx_people_age_current_location ON people(age, current_location);

SELECT current_location, COUNT(*) as num_people 
FROM people 
WHERE age BETWEEN 20 AND 30 
GROUP BY current_location;

-- For finding the 10 cities nearest to Sydney
CREATE INDEX idx_cities_latitude ON cities(latitude);
CREATE INDEX idx_cities_longitude ON cities(longitude);

SELECT c.id, c.name, c.latitude, c.longitude,
       (POWER(c.latitude - s.latitude, 2) + POWER(c.longitude - s.longitude, 2)) AS distance
FROM cities c,
     (SELECT latitude, longitude FROM cities WHERE name = 'Sydney') s
ORDER BY distance
LIMIT 10;
