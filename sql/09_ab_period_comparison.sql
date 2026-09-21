-- ──────────────────────────────────────────────
-- 09. Сравнение двух периодов: 1-е полугодие vs 2-е полугодие 2024
-- ──────────────────────────────────────────────
-- Задача: сравнить ключевые метрики за два полугодия 2024 года.
-- Вывод: выросла ли выручка, средний чек и количество заказов во втором полугодии.
--
-- Используемые конструкции: CTE, CASE, GROUP BY, агрегатные функции
-- Примечание: для извлечения года и месяца из даты в SQLite используется strftime().
-- ──────────────────────────────────────────────

WITH period_data AS (
    SELECT
        oi.order_id,
        oi.line_total,
        o.status,
        strftime('%Y', o.order_date) AS order_year,
        CAST(strftime('%m', o.order_date) AS INTEGER) AS order_month
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status NOT IN ('cancelled', 'returned')
      AND strftime('%Y', o.order_date) = '2024'
)
SELECT
    CASE WHEN order_month <= 6 THEN 'H1 (янв–июн)'
                               ELSE 'H2 (июл–дек)'
    END AS period,
    COUNT(DISTINCT order_id) AS orders_count,
    ROUND(SUM(line_total), 2) AS revenue,
    ROUND(SUM(line_total) / COUNT(DISTINCT order_id), 2) AS avg_check,
    -- Прирост выручки второго полугодия относительно первого
    ROUND(
        (SUM(line_total) - LAG(SUM(line_total)) OVER (ORDER BY CASE WHEN order_month <= 6 THEN 1 ELSE 2 END))
        * 100.0
        / NULLIF(LAG(SUM(line_total)) OVER (ORDER BY CASE WHEN order_month <= 6 THEN 1 ELSE 2 END), 0),
        2
    ) AS revenue_growth_pct
FROM period_data
GROUP BY CASE WHEN order_month <= 6 THEN 'H1 (янв–июн)' ELSE 'H2 (июл–дек)' END
ORDER BY period;
