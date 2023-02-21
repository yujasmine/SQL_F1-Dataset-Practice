-- Connect to the remote database ErgastF1 and list available tables
SHOW DATABASES;
USE ErgastF1;
SHOW TABLES;

-- Find how many drivers are recorded in the database?
SELECT COUNT(DISTINCT driverId) as num_drivers
FROM drivers


-- Find the 5 youngest drivers and the 5 oldest ones?
SELECT 
	dob AS birthday
	, forename AS first_name
	, surname AS last_name
FROM drivers d
ORDER BY dob ASC 
LIMIT 5

SELECT 	
	dob AS birthday
	, forename AS first_name
	, surname AS last_name
FROM drivers d
ORDER BY dob DESC 
LIMIT 5

-- See how many races are recorded in the database
SELECT COUNT(DISTINCT raceId) AS num_races
FROM results r 

-- Display the drivers'names and races they ran by decreasing number of podiums they ended up in (results.position equals 1, 2, or 3)
SELECT 
	d.forename as first_name
	, d.surname as last_name
	, COUNT(r.position) as num_podiums
FROM drivers d
LEFT JOIN results r
	ON d.driverID = r.driverID
LEFT JOIN races rc
	ON r.raceID = rc.raceID
WHERE r.position in (1,2,3)
GROUP BY 1,2
ORDER BY 3 DESC;

-- Display the top 10 drivers ranked by their number of pole positions (driverStandings.position equals 1)
SELECT 
	d.forename as first_name
	, d.surname as last_name
	, COUNT(ds.position) as rank
FROM drivers d 
INNER JOIN driverStandings ds 
ON d.driverId = ds.driverId 
WHERE ds.`position` = 1
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10


-- Find how many times did Ayrton Senna won a race? How many times did he finish second?
SELECT  
	d.forename AS first_name
	, d.surname AS last_name
	, COUNT(CASE WHEN r.`position`  = 1 THEN 1 END) AS won_race
	, COUNT(CASE WHEN r.`position` = 2 THEN 1 END) AS second_place
FROM drivers d 
INNER JOIN results r 
ON d.driverId = r.driverId 
WHERE d.forename = 'Ayrton'
AND d.surname = 'Senna'
GROUP BY 1,2

-- Display the top 10 constructors ranked by the number of victories of their pilots
SELECT 
	c.name AS constructor_name
	, COUNT(cs.`position`) AS num_victories
FROM constructors c 
INNER JOIN constructorStandings cs 
ON c.constructorId = cs.constructorId 
WHERE cs.`position`  = '1'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- Display all constructors and order their victories by driver (decreasing). With which pilot did Ferrari won the highest number of Grand Prix?
SELECT 
	c.name AS constructor_name
	, COUNT(r.position) AS num_victories
	, d.forename AS first_name
	, d.surname AS last_name
FROM constructors c 
INNER JOIN results r 
ON c.constructorId = r.constructorId 
INNER JOIN drivers d 
ON r.driverId = d.driverId 
WHERE r.`position` = '1'
GROUP BY 1,3,4
ORDER BY 2 DESC

-- Find out with which constructor did Juan Fangio won the highest number of Grand Prix?
SELECT 
	c.name AS constructor_name
	, COUNT(r.position) AS num_victories
	, d.forename AS first_name
	, d.surname AS last_name
FROM constructors c 
INNER JOIN results r 
ON c.constructorId = r.constructorId 
INNER JOIN drivers d 
ON r.driverId = d.driverId 
WHERE r.`position` = '1'
AND d.forename = 'Juan' 
AND d.surname = 'Fangio'
GROUP BY 1,3,4
ORDER BY 2 DESC



