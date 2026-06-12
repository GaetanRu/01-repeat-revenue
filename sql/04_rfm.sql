-- ============================================================
-- 04_rfm.sql  |  RFM Scoring + Segment Labels
-- Scoring: NTILE(5) quintiles per dimension
--   Recency:   5 = most recent (lowest recency_days)
--   Frequency: 5 = most frequent
--   Monetary:  5 = highest spend
-- Segments: based on R + F score combination
-- ============================================================

CREATE OR REPLACE TABLE `retail_analytics.customer_rfm` AS

WITH scored AS (
  SELECT
    customer_id,
    last_purchase_date,
    recency_days,
    frequency,
    monetary,
    -- Recency: lower days = better = higher score
    6 - NTILE(5) OVER (ORDER BY recency_days ASC)  AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC)          AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC)           AS m_score
  FROM `retail_analytics.customer_base`
)

SELECT
  *,
  ROUND((r_score + f_score + m_score) / 3.0, 2) AS rfm_avg,
  -- Segment logic: prioritize R and F for behavioral segments
  CASE
    WHEN r_score >= 4 AND f_score >= 4             THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 3             THEN 'Loyal'
    WHEN r_score >= 4 AND f_score <= 2             THEN 'New / Promising'
    WHEN r_score <= 2 AND f_score >= 3             THEN 'At-Risk'
    WHEN r_score <= 2 AND f_score <= 2 AND m_score >= 3 THEN 'Cannot Lose'
    WHEN r_score <= 1                              THEN 'Lost'
    ELSE 'Needs Attention'
  END AS segment
FROM scored;

-- Segment summary: size + revenue per segment
SELECT
  segment,
  COUNT(*)                           AS customers,
  ROUND(SUM(monetary), 2)            AS total_revenue,
  ROUND(AVG(monetary), 2)            AS avg_revenue,
  ROUND(AVG(recency_days))           AS avg_recency_days,
  ROUND(AVG(frequency), 1)           AS avg_orders
FROM `retail_analytics.customer_rfm`
GROUP BY segment
ORDER BY total_revenue DESC;
