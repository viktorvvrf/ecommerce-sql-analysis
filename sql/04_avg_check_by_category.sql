-- ──────────────────────────────────────────────
-- 04. Средний чек по категориям товаров
-- ──────────────────────────────────────────────
-- Задача: сравнить средний чек и количество заказов между категориями.
-- Вывод: какие категории дают высокий чек, какие — большой объём.
--
-- Используемые конструкции: JOIN (3 таблицы), AVG, COUNT DISTINCT, GROUP BY
-- ──────────────────────────────────────────────

SELECT
    c.category_name,
    COUNT(DISTINCT oi.order_id) AS orders_count,
    ROUND(AVG(oi.line_total), 2) AS avg_check,
    ROUND(SUM(oi.line_total), 2) AS total_revenue,
    ROUND(SUM(oi.quantity), 0)  AS total_units
FROM order_items oi
JOIN products p   ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o     ON oi.order_id = o.order_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY c.category_id, c.category_name
ORDER BY avg_check DESC;
