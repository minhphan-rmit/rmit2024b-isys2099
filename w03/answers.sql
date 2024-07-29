-- Exercise 1

-- 5 partitions are required
-- we need to distribute data to those 5 partitions
-- as equally as possible

-- because the script generates random data
-- we can assume that birth_date is uniformly distributed

-- the birth year is from 1920 to 2020: total of 100 years
-- so, use range partitioning where each range is 20 years

-- extend the primary key of the 'people' table
-- to include birth_date

ALTER TABLE people
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (id, birth_date);

-- update the 'people' table to have 5 partitions

ALTER TABLE people
PARTITION BY RANGE(YEAR(birth_date)) (
  PARTITION p0 VALUES LESS THAN 1940,
  PARTITION p1 VALUES LESS THAN 1960,
  PARTITION p2 VALUES LESS THAN 1980,
  PARTITION p3 VALUES LESS THAN 2000,
  PARTITION p4 VALUES LESS THAN MAXVALUE
);

-- count people whose ages are from 20 to 30

-- this query does not use partition information
SELECT COUNT(*) FROM people
WHERE YEAR(birth_date) - YEAR(birth_date) BETWEEN 20 AND 30;

-- this query specifies partitions explicitly
SELECT COUNT(*) FROM people PARTITION (p3, p4)
WHERE YEAR(CURDATE()) - YEAR(birth_date) BETWEEN 20 AND 30;

-- this query can use the partition information
SELECT COUNT(*) FROM people
WHERE birth_date >= '1994-01-01' AND birth_date <= '2004-12-31';

-- conclusion: 1. make your queries as simple as possible;
-- and 2. add partition information explicitly to help
-- the database engine

--------------------------------------------

-- Exercise 2

-- according to the results in the tutorial,
-- we always got zero for the two partitions: SE and NE
-- and the reason is because: the database engine stops
-- looking for further partitions to insert data as soon as
-- a comparison result is final
-- so, if we have 2 partitions like this

-- partition pSW values less than (-337000, 1455000),
-- partition pSE values less than (-337000, MAXVALUE)

-- you can see that the partition pSW will get all records
-- whose lat < -337000
-- for records whose lat value > -337000, they cannot
-- be stored in the partition pSE either!
-- so, the only records that can be stored in pSE are those
-- whose lat value = -337000 and lng value >= 1455000
-- however, due to the large amount of lat (and lng) values,
-- the records who lat values are exactly -337000 may not
-- exist at all

-- solution: there are some solutions proposed by students
-- that use some kind of mapping from (lat, lng) to partitions
-- all are very good. However, we have to do the actual mapping,
-- not the database engine. That means using partitioning in this
-- case is not transparent to the application developers. In other
-- words, the application developers need to know about the
-- way the paritions are structured to use them efficiently. That
-- will make the database and the application are not separated well

-- another solution is to use only one coordinate, lat OR lng, but
-- not both. Then, you can use RANGE PARTITIONING along that
-- coordinate similarly to the way we did to birth_date

--------------------------------------------

-- Exercise 3

-- we can use LIST PARTITIONING for this exercise
-- first, expand the primary key
-- then, add the list partitioning at the end
-- of the CREATE TABLE statement

CREATE TABLE provinces (
	code varchar(20) NOT NULL,
	name varchar(255) NOT NULL,
	name_en varchar(255) NOT NULL,
	full_name varchar(255) NOT NULL,
	full_name_en varchar(255) NOT NULL,
	code_name varchar(255) NOT NULL,
	administrative_unit_id integer NOT NULL,
	administrative_region_id integer NOT NULL,
	PRIMARY KEY (code, administrative_region_id)
)
PARTITION BY LIST(administrative_region_id) (
  PARTITION Northeast VALUES IN (1),
  PARTITION Northwest VALUES IN (2),
  PARTITION RedRiverDelta VALUES IN (3),
  PARTITION NorthCentralCoast VALUES IN (4),
  PARTITION SouthCentralCoast VALUES IN (5),
  PARTITION CentralHighlands VALUES IN (6),
  PARTITION Southeast VALUES IN (7),
  PARTITION MekongRiverDelta VALUES IN (8)
);
