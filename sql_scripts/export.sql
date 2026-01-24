-- Экспортные запросы
-- ===================

-- Для CSV экспорта
.mode csv
.headers on

-- Экспорт топа игр
.once ../results/top_games.csv
SELECT 
    Name, 
    Platform, 
    Year, 
    ROUND(Global_Sales, 2) AS Sales_M
FROM games 
ORDER BY Global_Sales DESC 
LIMIT 20;

-- Экспорт статистики по жанрам
.once ../results/genres_stats.csv
SELECT 
    Genre,
    COUNT(*) AS Games_Count,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales_M
FROM games
GROUP BY Genre
ORDER BY Total_Sales_M DESC;

-- Экспорт динамики по годам
.once ../results/sales_by_year.csv
SELECT 
    Year,
    COUNT(*) AS Releases,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales
FROM games
WHERE Year IS NOT NULL
GROUP BY Year
ORDER BY Year;

-- Для JSON экспорта
.mode json

-- Экспорт топа игр в JSON
.once ../results/top_games.json
SELECT 
    Name, 
    Platform, 
    Global_Sales 
FROM games 
ORDER BY Global_Sales DESC 
LIMIT 10;

-- Экспорт игр Nintendo в JSON
.once ../results/nintendo_games.json
SELECT 
    Name, 
    Year, 
    Platform, 
    Global_Sales
FROM games
WHERE Publisher = 'Nintendo' 
    AND Global_Sales > 1
ORDER BY Global_Sales DESC
LIMIT 15;
