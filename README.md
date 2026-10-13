# Telecom customer churn: EDA, SQL KPIs, Power BI and PySpark segmentation

A coursework analytics project on the public **IBM Telco Customer Churn** dataset (7,043 customers). The goal is to
understand who churns and why, using four tools: pandas preprocessing, Python visualizations, SQL KPIs with a Power
BI dashboard, and k-means segmentation in PySpark.

![Python](https://img.shields.io/badge/Python-pandas%20%7C%20seaborn-3776AB?logo=python&logoColor=white)
![PySpark](https://img.shields.io/badge/PySpark-MLlib%20k--means-E25A1C?logo=apachespark&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?logo=powerbi&logoColor=black)

## Workflow (files are numbered in order)

| # | File | What it does |
|---|---|---|
| 1 | `1.data preprocess.ipynb` | Converts `TotalCharges` to numbers, drops the 11 rows where it is blank, encodes categories (binary + one-hot) → `processed_telco_customer_churn.csv` (7,032 × 32) |
| 2 | `2.data_visualization_project.ipynb` | Plots churn by contract type, monthly charges, tenure, streaming TV, senior status, payment method and phone service |
| 3 | `3.power bi project.pbix` | Power BI dashboard |
| 4 | `4.sql.final.sql` | MySQL schema (demographics, services, contracts, central table) and KPI queries: churn rate, revenue, tenure, simple CLV, revenue lost |
| 5 | `5.benchmark spark.ipynb` | PySpark k-means on `tenure`, `MonthlyCharges`, `TotalCharges`, with k = 2…9 compared by silhouette score and timing |

Data: `telecom_churn_data - RAW.csv` (original) and `processed_telco_customer_churn.csv` (cleaned).

## Key numbers (computed from `processed_telco_customer_churn.csv`)

| | Churn rate | Customers |
|---|---|---|
| Overall | **26.6%** | 7,032 |
| Month-to-month contract | **42.7%** | 3,875 |
| One-year contract | 11.3% | 1,472 |
| Two-year contract | 2.8% | 1,685 |

- Correlation with churn: tenure −0.35, monthly charges +0.19, total charges −0.20.
- Customers who leave do so early. Short tenure is the clearest single signal. Higher monthly charges are linked to
  churn, but only moderately.

## Metric definitions

- Churn rate is churned customers divided by the customers in that group (`SUM(Churn) / COUNT(*)`). The fiber-optic
  and one-year SQL queries use the same definition, with that segment as the denominator.
- The contract, streaming-TV, and payment-method charts map an all-zero one-hot row back to the dropped baseline:
  month-to-month, no streaming TV, and bank transfer.
- PySpark k-means clusters `scaled_features` (not the unscaled `features` vector). The k loop prints silhouette
  score. Higher is better.

## What I learned

- Contract type and tenure explain much more of churn than demographics do.
- The same churn definition has to be used in pandas, SQL, BI, and Spark: churned customers divided by the customers
  in that group.

## Data source

IBM sample dataset "Telco Customer Churn" (as distributed on Kaggle).
