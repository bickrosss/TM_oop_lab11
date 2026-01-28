import sqlite3
import pandas as pd
import os
from pathlib import Path

csv_path = Path("datasets/vgsales.csv")

if not csv_path.exists():
    print(f"Ошибка: Файл {csv_path} не найден!")
    print("Доступные файлы в папке datasets:")
    
    datasets_dir = Path("datasets")
    if datasets_dir.exists():
        for file in datasets_dir.iterdir():
            print(f"  • {file.name}")
    else:
        print(" Папка 'datasets' не существует!")
    
    print(f"\nТекущая рабочая папка: {os.getcwd()}")
    exit(1)

try:
    
    df = pd.read_csv(csv_path)
    
except Exception as e:
    print(f"Ошибка при чтении CSV: {e}")
    exit(1)

try:
    conn = sqlite3.connect('vgsales.db')
    cursor = conn.cursor()
    
    df.to_sql('video_games', conn, if_exists='replace', index=False)
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_year ON video_games(Year)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_genre ON video_games(Genre)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_publisher ON video_games(Publisher)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_platform ON video_games(Platform)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_global_sales ON video_games(Global_Sales)')
    
    conn.commit()
    
    cursor.execute("SELECT COUNT(*) FROM video_games")
    count = cursor.fetchone()[0]
    
    cursor.execute("PRAGMA table_info(video_games)")
    columns = cursor.fetchall()
   
    print("БАЗА ДАННЫХ 'vgsales.db' СОЗДАНА УСПЕШНО!")
except Exception as e:
    print(f"❌ Ошибка при создании базы данных: {e}")
    if 'conn' in locals():
        conn.close()
    exit(1)