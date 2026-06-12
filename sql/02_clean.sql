-- ============================================================
-- 02_clean.sql  |  Build clean_transactions table
-- Business rules applied (see pm/assumptions_log.md):
--   - Exclude null CustomerID
--   - Flag cancellations (C-prefix InvoiceNo); exclude from revenue
--   - Exclude Quantity <= 0 or UnitPrice <= 0
--   - Exclude StockCode = 'POST' (postage charges, not product revenue)
--   - Exclude extreme quantity outliers: Quantity > 10000 AND UnitPrice < 5
--   - Reference period: 2011-01-01 to 2011-12-09 (full calendar year in sheet)
-- ============================================================

CREATE OR REPLACE TABLE `retail_analytics.clean_transactions` AS

SELECT
  CAST(InvoiceNo AS STRING)              AS invoice_no,
  CAST(StockCode AS STRING)              AS stock_code,
  Description                            AS description,
  Quantity                               AS quantity,
  DATE(InvoiceDate)                      AS invoice_date,
  UnitPrice                              AS unit_price,
  ROUND(Quantity * UnitPrice, 2)         AS revenue,
  CAST(CustomerID AS INT64)              AS customer_id,
  Country                                AS country,
  STARTS_WITH(
    CAST(InvoiceNo AS STRING), 'C'
  )                                      AS is_cancelled
FROM `retail_analytics.raw_transactions`
WHERE
  CustomerID IS NOT NULL
  AND Quantity > 0
  AND UnitPrice > 0
  AND StockCode != 'POST'
  AND NOT (Quantity > 10000 AND UnitPrice < 5)
  AND DATE(InvoiceDate) BETWEEN '2011-01-01' AND '2011-12-09';

-- Verify row count and revenue after cleaning
SELECT
  COUNT(*)                              AS clean_rows,
  COUNTIF(is_cancelled)                 AS cancelled_rows,
  COUNTIF(NOT is_cancelled)             AS revenue_rows,
  ROUND(SUM(CASE WHEN NOT is_cancelled THEN revenue END), 2) AS clean_revenue
FROM `retail_analytics.clean_transactions`;
