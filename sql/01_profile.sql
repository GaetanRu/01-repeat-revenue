-- ============================================================
-- 01_profile.sql  |  Data Profiling
-- Run this first. Understand shape before touching anything.
-- Dataset: retail_analytics.raw_transactions
-- ============================================================

-- 1. Row count and date range
SELECT
  COUNT(*)                          AS total_rows,
  MIN(InvoiceDate)                  AS earliest_date,
  MAX(InvoiceDate)                  AS latest_date,
  DATE_DIFF(MAX(DATE(InvoiceDate)), MIN(DATE(InvoiceDate)), DAY) AS date_span_days
FROM `retail_analytics.raw_transactions`;

-- ============================================================
-- 2. Null rates on key fields
SELECT
  COUNTIF(CustomerID IS NULL)                             AS null_customer_id,
  ROUND(COUNTIF(CustomerID IS NULL) / COUNT(*) * 100, 1) AS null_customer_pct,
  COUNTIF(Quantity IS NULL)                               AS null_quantity,
  COUNTIF(UnitPrice IS NULL)                              AS null_unitprice,
  COUNTIF(InvoiceDate IS NULL)                            AS null_invoice_date
FROM `retail_analytics.raw_transactions`;

-- ============================================================
-- 3. Cancellations
SELECT
  COUNTIF(STARTS_WITH(CAST(InvoiceNo AS STRING), 'C'))             AS cancelled_rows,
  ROUND(
    COUNTIF(STARTS_WITH(CAST(InvoiceNo AS STRING), 'C')) / COUNT(*) * 100, 1
  )                                                                 AS cancelled_pct
FROM `retail_analytics.raw_transactions`;

-- ============================================================
-- 4. Negative / zero quantity and price
SELECT
  COUNTIF(Quantity <= 0)   AS non_positive_quantity,
  COUNTIF(UnitPrice <= 0)  AS non_positive_price,
  COUNTIF(Quantity <= 0 OR UnitPrice <= 0) AS either_non_positive
FROM `retail_analytics.raw_transactions`;

-- ============================================================
-- 5. Distinct counts
SELECT
  COUNT(DISTINCT CustomerID)                AS distinct_customers,
  COUNT(DISTINCT InvoiceNo)                 AS distinct_invoices,
  COUNT(DISTINCT StockCode)                 AS distinct_products,
  COUNT(DISTINCT Country)                   AS distinct_countries
FROM `retail_analytics.raw_transactions`
WHERE CustomerID IS NOT NULL;

-- ============================================================
-- 6. Revenue sanity check (pre-cleaning)
SELECT
  ROUND(SUM(Quantity * UnitPrice), 2)  AS gross_revenue_raw,
  ROUND(AVG(Quantity * UnitPrice), 2)  AS avg_line_revenue,
  ROUND(MIN(Quantity * UnitPrice), 2)  AS min_line_revenue,
  ROUND(MAX(Quantity * UnitPrice), 2)  AS max_line_revenue
FROM `retail_analytics.raw_transactions`
WHERE CustomerID IS NOT NULL
  AND Quantity > 0
  AND UnitPrice > 0;

-- ============================================================
-- 7. Country distribution (top 10)
SELECT
  Country,
  COUNT(*) AS row_count,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS pct_of_rows
FROM `retail_analytics.raw_transactions`
GROUP BY Country
ORDER BY row_count DESC
LIMIT 10;
