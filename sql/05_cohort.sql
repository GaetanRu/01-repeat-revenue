-- ============================================================
-- 05_cohort.sql  |  Monthly Cohort Retention Matrix
-- Cohort = month of first purchase
-- Months since first = how many months later customer returned
-- Output: cohort × months_since_first → retention rate
-- ============================================================

CREATE OR REPLACE TABLE `retail_analytics.cohort_retention` AS

WITH first_purchase AS (
  SELECT
    customer_id,
    MIN(invoice_date)                              AS first_date,
    DATE_TRUNC(MIN(invoice_date), MONTH)           AS cohort_month
  FROM `retail_analytics.clean_transactions`
  WHERE is_cancelled = FALSE
  GROUP BY customer_id
),

monthly_activity AS (
  SELECT
    t.customer_id,
    DATE_TRUNC(t.invoice_date, MONTH)              AS activity_month
  FROM `retail_analytics.clean_transactions` t
  WHERE t.is_cancelled = FALSE
  GROUP BY t.customer_id, DATE_TRUNC(t.invoice_date, MONTH)
),

cohort_data AS (
  SELECT
    f.cohort_month,
    DATE_DIFF(m.activity_month, f.cohort_month, MONTH) AS months_since_first,
    COUNT(DISTINCT m.customer_id)                       AS active_customers
  FROM first_purchase f
  JOIN monthly_activity m USING (customer_id)
  GROUP BY f.cohort_month, months_since_first
),

cohort_sizes AS (
  SELECT cohort_month, COUNT(*) AS cohort_size
  FROM first_purchase
  GROUP BY cohort_month
)

SELECT
  cd.cohort_month,
  cs.cohort_size,
  cd.months_since_first,
  cd.active_customers,
  ROUND(cd.active_customers / cs.cohort_size * 100, 1) AS retention_rate
FROM cohort_data cd
JOIN cohort_sizes cs USING (cohort_month)
ORDER BY cd.cohort_month, cd.months_since_first;

-- Key retention benchmarks (Month 1, 3, 6 averaged across cohorts)
SELECT
  months_since_first,
  ROUND(AVG(retention_rate), 1) AS avg_retention_rate,
  COUNT(DISTINCT cohort_month)  AS cohorts_in_sample
FROM `retail_analytics.cohort_retention`
WHERE months_since_first IN (0, 1, 2, 3, 5)
GROUP BY months_since_first
ORDER BY months_since_first;
