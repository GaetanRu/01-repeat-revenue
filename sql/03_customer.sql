-- ============================================================
-- 03_customer.sql  |  Customer-level RFM base table
-- Recency: days since last purchase (relative to 2011-12-09)
-- Frequency: distinct invoice count (non-cancelled)
-- Monetary: total revenue (non-cancelled)
-- ============================================================

CREATE OR REPLACE TABLE `retail_analytics.customer_base` AS

WITH reference_date AS (
  SELECT DATE '2011-12-09' AS ref_date
)

SELECT
  t.customer_id,
  MAX(t.invoice_date)                               AS last_purchase_date,
  DATE_DIFF(r.ref_date, MAX(t.invoice_date), DAY)   AS recency_days,
  COUNT(DISTINCT t.invoice_no)                       AS frequency,
  ROUND(SUM(t.revenue), 2)                           AS monetary
FROM `retail_analytics.clean_transactions` t
CROSS JOIN reference_date r
WHERE t.is_cancelled = FALSE
GROUP BY t.customer_id, r.ref_date;

-- Quick distribution check
SELECT
  ROUND(AVG(recency_days))   AS avg_recency_days,
  ROUND(AVG(frequency), 1)   AS avg_orders,
  ROUND(AVG(monetary), 2)    AS avg_spend,
  ROUND(MIN(monetary), 2)    AS min_spend,
  ROUND(MAX(monetary), 2)    AS max_spend,
  COUNT(*)                   AS total_customers
FROM `retail_analytics.customer_base`;
