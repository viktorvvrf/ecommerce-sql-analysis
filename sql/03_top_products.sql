-- ──────────────────────────────────────────────
-- 03. Топ-10 товаров по выручке
-- ──────────────────────────────────────────────
-- Задача: найти самые продаваемые товары за весь период.
-- Вывод: какие товары приносят больше всего выручки — основа для закупок.
--
-- Используемые конструкции: JOIN (3 таблицы), GROUP BY, ORDER BY, LIMIT
-- ──────────────────────────────────────────────

SELECT
    p.product_name,
    c.category_name,
    SUM(oi.quantity)    AS units_sold,
    ROUND(SUM(oi.line_total), 2) AS revenue,
    ROUND(AVG(oi.line_total), 2) AS avg_order_value
FROM order_items oi
JOIN products p  ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o     ON oi.order_id = o.order_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY revenue DESC
LIMIT 10;
