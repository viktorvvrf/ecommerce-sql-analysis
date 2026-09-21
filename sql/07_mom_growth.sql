-- ──────────────────────────────────────────────
-- 07. Динамика выручки: месяц к месяцу (MoM)
-- ──────────────────────────────────────────────
-- Задача: посчитать прирост выручки в процентах относительно прошлого месяца.
-- Вывод: какие месяцы показали рост, какие — спад, есть ли сезонность.
--
-- Используемые конструкции: CTE, LAG() OVER(), NULLIF, ROUND
-- Примечание: SQLite использует strftime() вместо TO_CHAR() для работы с датами.
-- ──────────────────────────────────────────────

WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,
        ROUND(SUM(oi.line_total), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status NOT IN ('cancelled', 'returned')
    GROUP BY strftime('%Y-%m', o.order_date)
),
with_prev AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    prev_revenue,
    ROUND(
        (revenue - prev_revenue) * 100.0 / NULLIF(prev_revenue, 0),
        2
    ) AS mom_growth_pct,
    CASE
        WHEN revenue > prev_revenue THEN 'Рост ↑'
        WHEN revenue < prev_revenue THEN 'Спад ↓'
        ELSE 'Без изменений'
    END AS trend
FROM with_prev
ORDER BY month;
