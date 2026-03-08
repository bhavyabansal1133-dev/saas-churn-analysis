# SaaS Churn & Retention Analysis

**Author:** Bhavya Dhanuka  
**Tool:** PostgreSQL  
**Dataset:** Internet Service Provider Customer Data — 72,000+ records  
**Skills demonstrated:** SQL, Cohort Analysis, Segmentation, Business Recommendations

---

## Problem Statement

More than half of all customers have churned — 55.4% — meaning the business is losing customers faster than it is gaining them. This is not an attrition problem; it is a structural retention failure.

This analysis uses customer behavioral and contractual data to identify the key drivers of churn and translate them into specific, data-backed business recommendations.

---

## Dataset

| Column | Description |
|---|---|
| `id` | Unique customer identifier |
| `is_tv_subscriber` | 1 if subscribed to TV package, 0 otherwise |
| `is_movie_package_subscriber` | 1 if subscribed to movie package, 0 otherwise |
| `subscription_age` | Duration of subscription in years |
| `bill_avg` | Average monthly bill over last 3 months |
| `remaining_contract` | Years remaining on contract (NULL = no contract, 0 = expired) |
| `service_failure_count` | Number of service failure calls in last 3 months |
| `download_avg` | Average monthly download in GB over last 3 months |
| `upload_avg` | Average monthly upload in GB over last 3 months |
| `download_over_limit` | Number of times download limit was exceeded in last 9 months |
| `churn` | 1 if churned, 0 if retained |

---

## Approach

Customer data was loaded into a PostgreSQL database and analyzed through segmentation and cohort analysis to isolate the behavioral and contractual factors most strongly associated with churn. Five analytical questions were investigated:

1. What is the overall churn rate?
2. Do bundled service customers churn less?
3. Do service failures or download limit breaches drive churn?
4. How does contract status affect churn probability?
5. Does tenure predict churn?

---

## Findings

### 1. Overall Churn Rate: 55.4%

Over half the customer base has churned. This establishes the baseline against which all segment-level findings are compared.

---

### 2. Bundled Services Are an Underutilized Retention Mechanism

| Segment | Churn Rate |
|---|---|
| Overall | 55.4% |
| TV Subscribers | 47.7% |
| Movie Package Subscribers | 33.9% |

Customers subscribed to TV churn 8% less than the overall average. Movie package subscribers churn 21% less. The more services a customer holds, the less likely they are to leave — yet most customers remain on single-service plans. Each additional service is a retention anchor the business is not actively leveraging.

---

### 3. Unexpected Charges — Not Service Failures — Drive Churn

| Metric | Churned | Retained |
|---|---|---|
| Avg Service Failures | 0.29 | 0.25 |
| Avg Download Over Limit | 0.35 | 0.03 |

Service failures show a marginal difference between churned and retained customers — they are not a primary churn driver. Download limit breaches, however, show an **11x gap**. This is not a usage problem; it is a notification failure. Customers are being surprised by overage charges with no prior warning, and they are leaving because of it.

---

### 4. Contract Expiry Is a Churn Cliff

| Contract Status | Churn Rate |
|---|---|
| No contract (NULL) | 91.4% |
| Expired (0 years) | 99.6% |
| Expiring soon (0–1 year) | 13.5% |
| Safe zone (>1 year) | 10.3% |

Contract status is the strongest predictor of churn in this dataset. The business loses virtually every customer the moment their contract ends — 99.6% churn rate at expiry. Customers with time still remaining churn at only 13.5%, but this window is not being acted on. Without intervention, 86.5% of those customers will follow the same path to expiry and near-certain churn.

---

### 5. Tenure Has Minimal Impact on Churn

| Segment | Avg Tenure |
|---|---|
| Churned customers | 2.23 years |
| Retained customers | 2.73 years |

The 0.5-year gap between churned and retained customers is not a strong signal. Loyalty programs built purely on tenure would likely be ineffective — retention strategy should focus on contract structure and service bundling instead.

---

## Recommendations

### 1. Launch a Contract Renewal Campaign for Expiring-Soon Customers
Target all customers with 0–1 years remaining on their contract with a proactive renewal offer 90 days before expiry. The data shows churn jumps from 13.5% to 99.6% once a contract expires — this window is where retention is won or lost, and currently nothing is being done in it.

### 2. Deploy Proactive Download Limit Alerts
Notify customers when they reach 80–90% of their download limit, with a clear explanation of overage charges and an easy upgrade path. Churned customers exceeded their limit at 11x the rate of retained customers. Unexpected charges are a notification failure, not a usage problem — and it is the highest-ROI operational fix available.

### 3. Introduce Bundle Discounts as a Standard Retention Offer
Offer targeted discounts on TV and movie packages to single-service customers, particularly those flagged as churn risks. Movie package subscribers churn at 33.9% vs 55.4% overall — a 21-point gap. Pricing strategy should reflect that each additional service materially reduces churn probability.

---

## Limitations

The dataset contains no free-text customer remarks. Without a reason-for-leaving field, churn categories can only be inferred from behavioral signals. Adding a cancellation reason capture to the product would significantly sharpen future analysis and allow direct validation of these findings.

---

## Files

| File | Description |
|---|---|
| `analysis.sql` | All SQL queries with inline results and findings |
| `README.md` | Full analysis report |

---

## About

This is a portfolio project demonstrating end-to-end analytical problem solving — from raw data to business recommendations — using PostgreSQL.  
Connect with me on [LinkedIn](https://linkedin.com/in/bhavya-dhanuka)
