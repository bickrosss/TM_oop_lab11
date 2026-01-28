-- ============================================
-- 5+ SQL-ЗАПРОСОВ К ДАТАСЕТУ VIDEO GAME SALES
-- ============================================

-- ЗАПРОС 1: Топ-10 игр по мировым продажам
SELECT 
    Name, 
    Platform, 
    Year, 
    Global_Sales
FROM video_games 
ORDER BY Global_Sales DESC 
LIMIT 10;

-- ЗАПРОС 2: Продажи по жанрам
SELECT 
    Genre,
    COUNT(*) AS Games_Count,
    SUM(Global_Sales) AS Total_Sales,
    AVG(Global_Sales) AS Avg_Sales
FROM video_games
GROUP BY Genre
ORDER BY Total_Sales DESC;

-- ЗАПРОС 3: Игры Nintendo после 2010 года
SELECT 
    Name, 
    Year, 
    Platform, 
    Global_Sales
FROM video_games
WHERE Publisher = 'Nintendo' 
    AND Year >= 2010
    AND Year IS NOT NULL
ORDER BY Year DESC, Global_Sales DESC;

-- ЗАПРОС 4: Продажи по платформам
SELECT 
    Platform,
    COUNT(*) as Games_Released,
    ROUND(SUM(Global_Sales), 2) as Total_Sales
FROM video_games
WHERE Platform IS NOT NULL
GROUP BY Platform
HAVING Games_Released >= 20
ORDER BY Total_Sales DESC
LIMIT 10;

-- ЗАПРОС 5: Динамика продаж по годам
SELECT 
    Year,
    COUNT(*) AS Releases,
    SUM(Global_Sales) AS Total_Sales,
    AVG(Global_Sales) AS Avg_Sales
FROM video_games
WHERE Year IS NOT NULL
    AND Year BETWEEN 1990 AND 2016
GROUP BY Year
ORDER BY Year;