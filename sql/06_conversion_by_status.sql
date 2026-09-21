-- ──────────────────────────────────────────────
-- 06. Конверсия по статусам заказов
-- ──────────────────────────────────────────────
-- Задача: посчитать долю каждого статуса от общего числа заказов.
-- Вывод: где теряем заказы (отмены, возвраты), каков % доставки.
--
-- Используемые конструкции: оконная SUM() OVER(), GROUP BY, ROUND
-- ──────────────────────────────────────────────

SELECT
    status,
    COUNT(*) AS orders_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total,
    -- Накопительная сумма для визуализации воронки
    ROUND(SUM(COUNT(*)) OVER (ORDER BY COUNT(*) DESC) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS cumulative_pct
FROM orders
GROUP BY status
ORDER BY orders_count DESC;
