-- Задание 7
CREATE TABLE customer(name varchar(50));
SELECT * FROM customer;
.schema

-- Задание 8
.timer on
SELECT COUNT(*) FROM city;

-- Задание 9
SELECT MAX(LENGTH(city)) FROM city;

-- Задание 10
.mode csv
.import city.csv city

-- Задание 11
SELECT timezone, COUNT(*) AS city_count FROM city
WHERE federal_district IN ('Сибирский', 'Приволжский')
GROUP BY timezone ORDER BY timezone;

-- Задание 12
WITH samara AS (
    SELECT lat, lon
    FROM city
    WHERE name = 'Самара'
)
SELECT 
    c.name,
    (c.lat - s.lat) * (c.lat - s.lat) + (c.lon - s.lon) * (c.lon - s.lon) AS dist_sq
FROM city c, samara s
WHERE c.name != 'Самара'
ORDER BY dist_sq
LIMIT 3;