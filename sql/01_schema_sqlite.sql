-- ──────────────────────────────────────────────
-- Схема базы данных для SQLite
-- E-commerce аналитика
-- ──────────────────────────────────────────────

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;

CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id  INTEGER NOT NULL,
    price        REAL NOT NULL,
    cost         REAL NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id      INTEGER PRIMARY KEY,
    customer_name    TEXT NOT NULL,
    email            TEXT,
    city             TEXT,
    registration_date TEXT NOT NULL
);

CREATE TABLE sellers (
    seller_id   INTEGER PRIMARY KEY,
    seller_name TEXT NOT NULL,
    rating      REAL
);

CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER NOT NULL,
    seller_id     INTEGER NOT NULL,
    order_date    TEXT NOT NULL,
    ship_date     TEXT,
    delivery_date TEXT,
    status        TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_items (
    item_id    INTEGER PRIMARY KEY,
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL,
    line_total REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id   INTEGER PRIMARY KEY,
    order_id    INTEGER NOT NULL,
    rating      INTEGER NOT NULL,
    comment     TEXT,
    review_date TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Индексы для ускорения аналитических запросов
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);
CREATE INDEX idx_reviews_order ON reviews(order_id);
