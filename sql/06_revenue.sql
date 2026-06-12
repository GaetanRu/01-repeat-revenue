-- ============================================================
-- 06_revenue.sql  |  Revenue Concentration + At-Risk Analysis
-- Answers:
--   - % revenue from repeat vs one-time buyers
--   - Pareto: top X% customers → Y% of revenue
--   - At-risk revenue by segment
-- ============================================================

-- 1. Repeat vs one-time buyer revenue split
SELECT
  CASE WHEN frequency = 1 THEN 'One-Time' ELSE 'Repeat' END AS buyer_type,
  COUNT(*)                                                    AS customers,
  ROUND(SUM(monetary), 2)                                     AS total_revenue,
  ROUND(SUM(monetary) / SUM(SUM(monetary)) OVER () * 100, 1) AS revenue_pct
FROM `retail_analytics.customer_rfm`
GROUP BY buyer_type;

-- ============================================================
-- 2. Pareto concentration (decile buckets)
WITH deciles AS (
  SELECT
    customer_id,
    monetary,
    NTILE(10) OVER (ORDER BY monetary DESC) AS revenue_decile
  FROM `retail_analytics.customer_rfm`
)

SELECT
  revenue_decile,
  COUNT(*)                                                    AS customers,
  ROUND(SUM(monetary), 2)                                     AS revenue,
  ROUND(SUM(monetary) / SUM(SUM(monetary)) OVER () * 100, 1) AS revenue_pct,
  ROUND(
    SUM(SUM(monetary)) OVER (ORDER BY revenue_decile ROWS UNBOUNDED PRECEDING)
    / SUM(SUM(monetary)) OVER () * 100, 1
  )                                                           AS cumulative_revenue_pct
FROM deciles
GROUP BY revenue_decile
ORDER BY revenue_decile;

-- ============================================================
-- 3. At-risk revenue by segment
SELECT
  segment,
  COUNT(*)                            AS customers,
  ROUND(SUM(monetary), 2)             AS revenue_at_risk,
  ROUND(AVG(monetary), 2)             AS avg_revenue_per_customer,
  ROUND(AVG(recency_days))            AS avg_days_since_purchase
FROM `retail_analytics.customer_rfm`
WHERE segment IN ('At-Risk', 'Cannot Lose', 'Lost')
GROUP BY segment
ORDER BY revenue_at_risk DESC;

-- ============================================================
-- 4. Full segment revenue summary for dashboard
SELECT
  segment,
  COUNT(*)                                                    AS customers,
  ROUND(SUM(monetary), 2)                                     AS total_revenue,
  ROUND(SUM(monetary) / SUM(SUM(monetary)) OVER () * 100, 1) AS revenue_share_pct,
  ROUND(AVG(monetary), 2)                                     AS avg_ltv,
  ROUND(AVG(recency_days))                                    AS avg_recency_days,
  ROUND(AVG(frequency), 1)                                    AS avg_orders
FROM `retail_analytics.customer_rfm`
GROUP BY segment
ORDER BY total_revenue DESC;
