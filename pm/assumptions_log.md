# Assumptions Log — Meridian Home Goods: Customer Retention Analysis

_Update this log each time you make a data decision. Include what you found, what you decided, and why._

---

## Data Quality Decisions

| # | Issue | Finding | Decision | Rationale |
|---|-------|---------|----------|-----------|
| 1 | Null CustomerID | 135,080 rows (24.9%) have no CustomerID | Exclude from all customer-level analysis | Cannot track behavior without a stable ID |
| 2 | Cancellations (C-prefix InvoiceNo) | 9,288 rows (1.7%) are cancellations | Exclude from revenue; flag as `is_cancelled = TRUE` | Cancellations do not represent realized revenue |
| 3 | Negative quantity | 10,624 rows (≤0); includes ~9,288 cancellations + ~1,336 non-C-prefix adjustments | Exclude (Quantity <= 0) | Returns/adjustments reduce actual revenue; excluding keeps analysis focused on purchase behavior |
| 4 | Zero/negative UnitPrice | 2,517 rows (≤0); likely postage (StockCode "POST"), free samples, bank charges | Exclude (UnitPrice <= 0) | No meaningful revenue calculation possible |
| 10 | Postage lines (StockCode = "POST") | Single postage invoice found at £8,142.75 — not product revenue | Exclude StockCode = 'POST' entirely | Postage distorts per-customer revenue totals; not a product behavior signal |
| 11 | Extreme quantity outliers | 2 invoices: 80,995 units @ £2.08 (£168K) and 74,215 units @ £1.04 (£77K) — implausible retail quantities | Exclude rows where Quantity > 10,000 AND UnitPrice < 5 | Almost certainly data entry errors; keeping would skew total revenue and RFM scores for 2 customers |
| 5 | Reference period | Sheet "Year 2010-2011" covers Dec 2010–Dec 2011 | Use 2011-01-01 to 2011-12-09 | Excludes the single Dec 2010 partial month; gives a clean 12-month calendar year |
| 6 | Recency reference date | Need a fixed point for recency calculation | Use 2011-12-09 | Last transaction date in dataset; makes recency interpretable as "days since last purchase in 2011" |

---

## RFM Scoring Decisions

| # | Decision | Details |
|---|----------|---------|
| 7 | Scoring method | NTILE(5) quintiles per dimension (1–5) |
| 8 | Recency direction | Lower recency_days = better = higher R score (inverted) |
| 9 | Segment logic | See 04_rfm.sql — prioritizes R and F over M for segment labels |

---

## Updates (fill in as you work)

_Example format:_
> **2024-WK2:** Discovered ~200 rows with StockCode = "POST" (postage charges). Decided to exclude from product-level analysis but retain in revenue totals. Rationale: postage is real revenue but not product behavior signal.

---
