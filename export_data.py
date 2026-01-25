import sqlite3
import pandas as pd
import json
from pathlib import Path

DB_PATH = "game_sales.db"
SQL_DIR = Path("sql_scripts")
CSV_OUT = Path("results/csv")
JSON_OUT = Path("results/json")

CSV_OUT.mkdir(parents=True, exist_ok=True)
JSON_OUT.mkdir(parents=True, exist_ok=True)

conn = sqlite3.connect(DB_PATH)

# Список SQL-запросов
queries = {
    "top_games": "SELECT Name, Platform, Global_Sales FROM games ORDER BY Global_Sales DESC LIMIT 20",
    "genres_stats": "SELECT Genre, COUNT(*), SUM(Global_Sales) FROM games GROUP BY Genre",
    "publishers": "SELECT Publisher, COUNT(*), SUM(Global_Sales) FROM games GROUP BY Publisher",
    "sales_by_year": "SELECT Year, COUNT(*), SUM(Global_Sales) FROM games GROUP BY Year"
}

for name, query in queries.items():
    df = pd.read_sql_query(query, conn)
    
    # Экспорт в CSV
    df.to_csv(CSV_OUT / f"{name}.csv", index=False)
    
    # Экспорт в JSON
    with open(JSON_OUT / f"{name}.json", "w", encoding="utf-8") as f:
        json.dump(df.to_dict(orient="records"), f, ensure_ascii=False, indent=2)
    
    print(f"✓ {name} — сохранён")

conn.close()
print("Все результаты успешно выгружены")