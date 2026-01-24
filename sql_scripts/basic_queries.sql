-- Задания 7-11 из методички
-- ===========================

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
SELECT 
    timezone,
    COUNT(*) AS city_count
FROM city
WHERE federal_district IN ('Сибирский', 'Приволжский')
GROUP BY timezone
ORDER BY timezone;
