# Recovering Repeat Revenue — Meridian Home Goods

**Role:** Data Analyst + Project Lead
**Tools:** BigQuery · Tableau Public · SQL · Google Sheets (QA)
**Dataset:** UCI Online Retail II (~542K transactions, 2011)

---

## Business Problem
Meridian Home Goods had no visibility into customer repeat-purchase behavior. Retention spend was undifferentiated. This analysis identifies which segments drive repeat revenue, quantifies revenue at risk from lapsing customers, and benchmarks cohort retention.

## Key Findings
- Repeat buyers generate **93.1% of revenue** despite being only 64% of customers
- **Champions segment** (25% of customers) accounts for **66.8% of revenue** (£5.35M)
- **£1.03M at risk** from At-Risk + Cannot Lose segments (883 lapsing customers, 136–173 days inactive)
- **Month-1 cohort retention: 21%** — at the floor of the 20–30% e-commerce benchmark
- Revenue follows a **60/10 rule**: top 10% of customers = 60% of all revenue

## Recommendation
Target At-Risk customers (658 customers, £817K revenue, 136 days inactive) with a personalised win-back campaign. A 30% recovery rate returns ~£245K. Protect Champions with a VIP programme — losing one top-decile customer equals losing 120 bottom-decile customers.

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
