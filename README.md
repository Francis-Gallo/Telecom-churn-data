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

## Known issues (to fix)

- **The contract, streaming-TV and payment-method plots mislabel the baseline category.** They rebuild the category
  with `idxmax` over the one-hot columns. When all of them are 0 (e.g. month-to-month), `idxmax` returns the first
  column instead of NaN, so month-to-month customers are drawn as "One year". Use
  `np.where(dummies.sum(axis=1) == 0, "Month-to-month", dummies.idxmax(axis=1))`.
- **SQL churn rate:** `(COUNT(*) - SUM(Churn)) / COUNT(*)` is the *retention* rate. Churn rate is `SUM(Churn) / COUNT(*)`.
  The "churn rate for fiber optic / one-year" queries divide by *all* customers, not by the customers in that segment.
- **k-means runs on unscaled features.** `StandardScaler` writes `scaled_features`, but `KMeans` reads the default
  `features` column, so `TotalCharges` dominates the clusters. Add `.setFeaturesCol("scaled_features")`. The printed
  "Cost" values are silhouette scores (higher is better), not k-means cost.

## What I learned

- Contract type and tenure explain much more of churn than demographics do.
- One question can be answered consistently across pandas, SQL, BI and Spark, as long as the definitions match
  (see the churn-rate bug above).

## Data source

IBM sample dataset "Telco Customer Churn" (as distributed on Kaggle).
