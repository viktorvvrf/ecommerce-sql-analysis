-- ──────────────────────────────────────────────
-- 02. Выручка по месяцам с накопительным итогом
-- ──────────────────────────────────────────────
-- Задача: посчитать выручку по месяцам и нарастающий итог за весь период.
-- Вывод: какие месяцы самые прибыльные, как растёт выручка.
--
-- Используемые конструкции: JOIN, GROUP BY, strftime(), оконная SUM() OVER()
-- ──────────────────────────────────────────────

SELECT
    strftime('%Y-%m', o.order_date) AS month,
    ROUND(SUM(oi.line_total), 2)   AS revenue,
    COUNT(DISTINCT o.order_id)      AS orders_count,
    ROUND(SUM(oi.line_total) / COUNT(DISTINCT o.order_id), 2) AS avg_check,
    ROUND(SUM(SUM(oi.line_total)) OVER (ORDER BY strftime('%Y-%m', o.order_date)), 2) AS cumulative_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;
