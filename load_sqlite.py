#!/usr/bin/env python3
'''Загрузка данных из CSV в SQLite базу.
Запуск: python load_sqlite.py
Результат: файл ecommerce.db в текущей папке
'''
import sqlite3, csv, os

DB_PATH = 'ecommerce.db'

def create_schema(conn):
    conn.executescript(open('sql/01_schema_sqlite.sql', encoding='utf-8').read())

def load_table(conn, table_name, columns, csv_path):
    with open(csv_path, encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader)  # skip header
        placeholders = ','.join(['?'] * len(columns))
        col_str = ','.join(columns)
        conn.executemany(f'INSERT INTO {table_name} ({col_str}) VALUES ({placeholders})', reader)
    count = conn.execute(f'SELECT COUNT(*) FROM {table_name}').fetchone()[0]
    print(f'  {table_name}: {count} строк')

def main():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    conn = sqlite3.connect(DB_PATH)
    print('Создание схемы...')
    create_schema(conn)
    conn.commit()
    print('Загрузка данных...')
    load_table(conn, 'categories', ['category_id','category_name'], 'data/categories.csv')
    load_table(conn, 'products', ['product_id','product_name','category_id','price','cost'], 'data/products.csv')
    load_table(conn, 'customers', ['customer_id','customer_name','email','city','registration_date'], 'data/customers.csv')
    load_table(conn, 'sellers', ['seller_id','seller_name','rating'], 'data/sellers.csv')
    load_table(conn, 'orders', ['order_id','customer_id','seller_id','order_date','ship_date','delivery_date','status'], 'data/orders.csv')
    load_table(conn, 'order_items', ['item_id','order_id','product_id','quantity','line_total'], 'data/order_items.csv')
    load_table(conn, 'reviews', ['review_id','order_id','rating','comment','review_date'], 'data/reviews.csv')
    conn.commit()
    conn.close()
    print(f'\nГотово! База: {DB_PATH}')
    print('Откройте её в DB Browser for SQLite и выполняйте запросы из папки sql/')

if __name__ == '__main__':
    main()
