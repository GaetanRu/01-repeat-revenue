# Recovering Repeat Revenue — Meridian Home Goods

**Role:** Data Analyst + Project Lead
**Tools:** BigQuery · Tableau Public · SQL · Google Sheets (QA)
**Dataset:** UCI Online Retail II (~1M transactions, 2010)

---

## Business Problem
Meridian Home Goods had no visibility into customer repeat-purchase behavior. Retention spend was undifferentiated. This analysis identifies which segments drive repeat revenue, quantifies revenue at risk from lapsing customers, and benchmarks cohort retention.

## Key Findings
_Fill in after Week 3 analysis_
- % of revenue from repeat buyers: **TBD**
- Top segment by revenue: **TBD**
- At-risk revenue (At-Risk + Cannot Lose segments): **$TBD**
- Month-1 cohort retention rate: **TBD%** vs. ~20–30% e-commerce benchmark

## Recommendation
_Fill in after analysis_

## Dashboard
[View on Tableau Public](_link_here_)

## Repo Structure
```
sql/           — BigQuery SQL scripts (profiling → RFM → cohorts → revenue)
pm/            — Project charter, assumptions log, stakeholder map
dashboard/     — Tableau screenshots
docs/          — Case study and executive summary
data_raw/      — Source CSV (gitignored)
```

## How to Reproduce
1. Download UCI Online Retail II from Kaggle (`mashlyn/online-retail-ii-uci`)
2. Create BigQuery project + dataset `retail_analytics`
3. Upload CSV as table `raw_transactions`
4. Run SQL scripts in order: `01_profile` → `02_clean` → `03_customer` → `04_rfm` → `05_cohort` → `06_revenue`
5. Connect Tableau Public to BigQuery and open the workbook in `dashboard/`
