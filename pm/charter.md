# Project Charter — Meridian Home Goods: Customer Retention Analysis

## Problem Statement
Meridian Home Goods has no visibility into repeat purchase behavior. Revenue concentration across buyer types is unknown. Retention spend is undifferentiated, meaning high-value and low-value customers receive the same treatment.

## Business Decision to Support
Which customer segments warrant targeted retention investment, and how much annual revenue is at risk from lapsing high-value customers?

## Scope
- **In scope:** 2010 transaction data, UK customers with a CustomerID, repeat vs. one-time buyer segmentation, RFM scoring, monthly cohort retention analysis, revenue concentration
- **Out of scope:** Product-level recommendations, pricing analysis, marketing campaign design, customers without CustomerID

## Success Metrics
1. Identify top 3 retention segments with quantified revenue at risk ($)
2. Establish cohort Month-1 retention rate baseline and compare to e-commerce benchmark (~20–30%)

## Key Stakeholders
| Role | Name (fictional) | Interest |
|------|-----------------|----------|
| CFO | Sarah Okafor | Revenue concentration risk, ROI on retention spend |
| CMO | James Reinholt | Which segments to target in campaigns |
| Head of Retention | Priya Nair | Actionable segment definitions, data quality |

## Assumptions (initial)
- CustomerID is the reliable unit of customer identity
- 2010 is representative of current business patterns
- Cancellations are excluded from revenue but tracked separately
- Reference date for recency: 2010-12-31

## Timeline
| Week | Focus |
|------|-------|
| 1 | Setup, profiling, charter, assumptions |
| 2 | Clean data, customer table, RFM scoring |
| 3 | Cohort analysis, revenue concentration, insights |
| 4 | Tableau dashboard, case study, README, STAR story |

## Tools
- BigQuery (SQL analysis)
- Tableau Public (dashboarding)
- GitHub (version control, portfolio)
- Google Sheets (QA spot-checks)
