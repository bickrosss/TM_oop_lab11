-- Настройка режимов
.mode csv
.headers on

-- Удаляем таблицу если уже существует
DROP TABLE IF EXISTS games;

-- Импортируем данные из CSV
.import datasets/vgsales.csv games

-- Проверяем импорт
SELECT 'Импорт завершён. Записей:' AS status, COUNT(*) AS count FROM games;

-- Показываем структуру
.schema games