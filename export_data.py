import sqlite3
import csv
import json
from pathlib import Path

print("Экспорт данных из базы данных в CSV и JSON")
print("=" * 50)

# Проверяем базу данных
db_path = Path("vgsales.db")
if not db_path.exists():
    print("Ошибка: База данных 'vgsales.db' не найдена")
    print("Сначала запустите: python create_db.py")
    exit(1)

print(f"База данных найдена: {db_path}")

# Создаем папки для результатов
results_dir = Path("results")
csv_dir = results_dir / "csv"
json_dir = results_dir / "json"

csv_dir.mkdir(parents=True, exist_ok=True)
json_dir.mkdir(parents=True, exist_ok=True)

print("Папки для результатов созданы")

# Подключаемся к базе данных
conn = sqlite3.connect('vgsales.db')
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

print("Подключение к базе данных установлено")

# Читаем SQL запросы из файла
sql_file = Path("sql_scripts/analysis.sql")
if not sql_file.exists():
    print(f"Ошибка: Файл {sql_file} не найден")
    conn.close()
    exit(1)

with open(sql_file, 'r', encoding='utf-8') as f:
    sql_content = f.read()

# Разделяем запросы
queries = []
current_query = ""

for line in sql_content.split('\n'):
    line = line.strip()
    if line.startswith('--') or not line:
        continue
    
    current_query += line + " "
    if ';' in line:
        query = current_query.strip()
        if query and len(query) > 10:
            queries.append(query)
        current_query = ""

if current_query and len(current_query.strip()) > 10:
    queries.append(current_query.strip())

print(f"Найдено {len(queries)} SQL запросов")

# Выполняем каждый запрос и экспортируем результаты
exported_count = 0
for i, query in enumerate(queries, 1):
    if not query:
        continue
    
    try:
        # Выполняем запрос
        cursor.execute(query)
        results = cursor.fetchall()
        
        if not results:
            print(f"Запрос {i}: Нет результатов")
            continue
        
        # Получаем названия колонок
        column_names = [description[0] for description in cursor.description]
        
        print(f"Запрос {i}: {len(results)} записей")
        
        # Экспорт в CSV
        csv_filename = csv_dir / f"query_{i:02d}.csv"
        with open(csv_filename, 'w', newline='', encoding='utf-8') as csv_file:
            writer = csv.writer(csv_file)
            writer.writerow(column_names)
            for row in results:
                writer.writerow(row)
        
        # Экспорт в JSON
        json_filename = json_dir / f"query_{i:02d}.json"
        data_for_json = []
        for row in results:
            data_for_json.append(dict(zip(column_names, row)))
        
        with open(json_filename, 'w', encoding='utf-8') as json_file:
            json.dump(data_for_json, json_file, ensure_ascii=False, indent=2)
        
        print(f"  Экспортировано: {csv_filename.name}, {json_filename.name}")
        
        exported_count += 1
        
    except sqlite3.Error as e:
        print(f"Ошибка SQL в запросе {i}: {e}")
        continue
    except Exception as e:
        print(f"Ошибка в запросе {i}: {str(e)[:100]}")
        continue

# Закрываем соединение
conn.close()

print("\nЭкспорт завершен")
print(f"Обработано запросов: {len(queries)}")
print(f"Успешно экспортировано: {exported_count}")

if exported_count > 0:
    print("\nСозданные файлы:")
    for csv_file in sorted(csv_dir.glob('*.csv')):
        print(f"  {csv_file.name}")
else:
    print("Не экспортировано ни одного файла")