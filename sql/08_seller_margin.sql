-- ──────────────────────────────────────────────
-- 08. Маржинальность по продавцам
-- ──────────────────────────────────────────────
-- Задача: рассчитать валовую маржу каждого продавца (выручка минус себестоимость).
-- Вывод: кто работает с высокой маржой, кто — с большим объёмом, но низкой маржой.
--
-- Используемые конструкции: JOIN (3 таблицы), SUM, ROUND, GROUP BY, ORDER BY
-- ──────────────────────────────────────────────

SELECT
    s.seller_name,
    s.rating,
    COUNT(DISTINCT o.order_id)   AS orders_count,
    ROUND(SUM(oi.line_total), 2) AS revenue,
    ROUND(SUM(p.cost * oi.quantity), 2) AS total_cost,
    ROUND(SUM(oi.line_total) - SUM(p.cost * oi.quantity), 2) AS gross_profit,
    ROUND(
        (SUM(oi.line_total) - SUM(p.cost * oi.quantity)) * 100.0 / NULLIF(SUM(oi.line_total), 0),
        2
    ) AS margin_pct
FROM sellers s
JOIN orders o      ON s.seller_id = o.seller_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p    ON oi.product_id = p.product_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY s.seller_id, s.seller_name, s.rating
ORDER BY gross_profit DESC;
