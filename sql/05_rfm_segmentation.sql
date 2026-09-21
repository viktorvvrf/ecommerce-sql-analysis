-- ──────────────────────────────────────────────
-- 05. RFM-сегментация клиентов
-- ──────────────────────────────────────────────
-- Задача: разделить клиентов на сегменты по давности, частоте и сумме заказов.
-- Вывод: кто — лояльные, кто — «спящие», кого нужно возвращать.
--
-- Используемые конструкции: CTE, NTILE() OVER(), CASE, JOIN, GROUP BY
-- ──────────────────────────────────────────────

WITH rfm AS (
    SELECT
        o.customer_id,
        -- Recency: дней с последнего заказа (меньше = лучше)
        CAST(julianday('2025-09-30') - julianday(MAX(o.order_date)) AS INTEGER) AS recency,
        -- Frequency: количество заказов
        COUNT(DISTINCT o.order_id) AS frequency,
        -- Monetary: суммарная выручка
        ROUND(SUM(oi.line_total), 2) AS monetary
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status NOT IN ('cancelled', 'returned')
    GROUP BY o.customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        -- Чем меньше recency — тем выше балл (4 = самый недавний)
        NTILE(4) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency)  AS f_score,
        NTILE(4) OVER (ORDER BY monetary)   AS m_score
    FROM rfm
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    r_score, f_score, m_score,
    CASE
        WHEN r_score = 4 AND f_score >= 3 AND m_score >= 3 THEN 'Лояльные'
        WHEN r_score >= 3 AND f_score >= 3                THEN 'Постоянные'
        WHEN r_score = 4 AND f_score <= 2                  THEN 'Новички'
        WHEN r_score <= 2 AND f_score >= 2                 THEN 'Спящие'
        WHEN r_score = 1 AND f_score = 1                   THEN 'Потерянные'
        ELSE 'Прочие'
    END AS segment
FROM rfm_scores
ORDER BY monetary DESC
LIMIT 50;
