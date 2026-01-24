-- ============================================
-- 5+ SQL-ЗАПРОСОВ К ДАТАСЕТУ VIDEO GAME SALES
-- ============================================

.headers on
.mode column

-- ЗАПРОС 1: Топ-10 игр по мировым продажам
SELECT 
    Name, 
    Platform, 
    Year, 
    ROUND(Global_Sales, 2) AS Global_Sales_M
FROM games 
ORDER BY Global_Sales DESC 
LIMIT 10;

-- ЗАПРОС 2: Продажи по жанрам
SELECT 
    Genre,
    COUNT(*) AS Games_Count,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales_M,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales_M
FROM games
GROUP BY Genre
ORDER BY Total_Sales_M DESC;

-- ЗАПРОС 3: Игры Nintendo после 2010 года
SELECT 
    Name, 
    Year, 
    Platform, 
    ROUND(Global_Sales, 2) AS Sales_M
FROM games
WHERE Publisher = 'Nintendo' 
    AND Year >= 2010
    AND Year IS NOT NULL
ORDER BY Year DESC, Sales_M DESC;

-- ЗАПРОС 4: Средние продажи по платформам (только популярные)
SELECT 
    Platform,
    COUNT(*) AS Games_Count,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales_M
FROM games
GROUP BY Platform
HAVING Games_Count > 100
ORDER BY Avg_Sales_M DESC;

-- ЗАПРОС 5: Динамика продаж по годам
SELECT 
    Year,
    COUNT(*) AS Releases,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales_M,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales_M
FROM games
WHERE Year IS NOT NULL
    AND Year BETWEEN 1990 AND 2016
GROUP BY Year
ORDER BY Year;

-- ЗАПРОС 6: Самые продаваемые игры в Японии
SELECT 
    Name,
    Platform,
    Publisher,
    ROUND(JP_Sales, 2) AS JP_Sales_M,
    ROUND(Global_Sales, 2) AS Global_Sales_M
FROM games
WHERE JP_Sales > 1
ORDER BY JP_Sales DESC
LIMIT 15;

-- ЗАПРОС 7 (дополнительный): Лучшие игры каждого года
SELECT 
    Year,
    Name AS Best_Game,
    MAX(Global_Sales) AS Max_Sales
FROM games
WHERE Year IS NOT NULL
    AND Year BETWEEN 2000 AND 2015
GROUP BY Year
ORDER BY Year DESC;
