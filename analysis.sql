-- ============================================================
-- SaaS Churn & Retention Analysis
-- Author: Bhavya Dhanuka
-- Dataset: Internet Service Provider Customer Data (72,000+ records)
-- Tool: PostgreSQL
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Churn Rate
-- What percentage of total customers have churned?
-- ============================================================

SELECT 
    (COUNT(CASE WHEN churn = 1 THEN id END) / CAST(COUNT(id) AS NUMERIC)) AS churn_rate
FROM customers;

-- Result: 0.554 (55.4% overall churn rate)


-- ============================================================
-- QUERY 2: Churn Rate by Bundle Subscription
-- Do customers with TV or movie packages churn less?
-- ============================================================

SELECT
    COUNT(id) AS total_customers,
    COUNT(CASE WHEN churn = 1 THEN id END) AS churned_customers,
    (COUNT(CASE WHEN churn = 1 AND is_tv_subscriber = 1 THEN id END) / 
     CAST(COUNT(CASE WHEN is_tv_subscriber = 1 THEN id END) AS NUMERIC)) AS tv_subscriber_churn_rate,
    (COUNT(CASE WHEN churn = 1 AND is_movie_package_subscriber = 1 THEN id END) / 
     CAST(COUNT(CASE WHEN is_movie_package_subscriber = 1 THEN id END) AS NUMERIC)) AS movie_package_churn_rate
FROM customers;

-- Results:
-- Overall churn:        55.4%
-- TV subscriber churn:  47.7%  (-8% vs overall)
-- Movie package churn:  33.9%  (-21% vs overall)
-- Finding: Bundled customers churn significantly less. Each additional service is a retention anchor.


-- ============================================================
-- QUERY 3: Service Quality vs Churn
-- Do service failures and download limit breaches drive churn?
-- ============================================================

SELECT
    AVG(CASE WHEN churn = 1 THEN service_failure_count END) AS churned_avg_service_failures,
    AVG(CASE WHEN churn = 0 THEN service_failure_count END) AS retained_avg_service_failures,
    AVG(CASE WHEN churn = 1 THEN download_over_limit END)   AS churned_avg_download_overlimit,
    AVG(CASE WHEN churn = 0 THEN download_over_limit END)   AS retained_avg_download_overlimit
FROM customers;

-- Results:
-- Service failures  — churned: 0.29  | retained: 0.25  (marginal difference)
-- Download overlimit — churned: 0.35  | retained: 0.03  (11x gap)
-- Finding: Service failures are NOT a primary churn driver.
--          Download limit breaches ARE — unexpected charges trigger exit.


-- ============================================================
-- QUERY 4: Churn Rate by Contract Status
-- How does remaining contract time affect churn probability?
-- ============================================================

SELECT
    (COUNT(CASE WHEN churn = 1 AND remaining_contract IS NULL THEN id END) /
     CAST(COUNT(CASE WHEN remaining_contract IS NULL THEN id END) AS NUMERIC))        AS no_contract_churn_rate,

    (COUNT(CASE WHEN churn = 1 AND remaining_contract = 0 THEN id END) /
     CAST(COUNT(CASE WHEN remaining_contract = 0 THEN id END) AS NUMERIC))            AS expired_contract_churn_rate,

    (COUNT(CASE WHEN churn = 1 AND remaining_contract > 0 AND remaining_contract < 1 THEN id END) /
     CAST(COUNT(CASE WHEN remaining_contract > 0 AND remaining_contract < 1 THEN id END) AS NUMERIC)) AS expiring_soon_churn_rate,

    (COUNT(CASE WHEN churn = 1 AND remaining_contract > 1 THEN id END) /
     CAST(COUNT(CASE WHEN remaining_contract > 1 THEN id END) AS NUMERIC))            AS safe_zone_churn_rate
FROM customers;

-- Results:
-- No contract (NULL):     91.4%  — no commitment, free to leave anytime
-- Expired contract (0):   99.6%  — business loses virtually every customer at expiry
-- Expiring soon (0-1yr):  13.5%  — critical intervention window
-- Safe zone (>1yr):       10.3%  — lowest churn, locked in
-- Finding: Contract expiry is a churn cliff. 
--          The window between expiring-soon and expired is where retention is won or lost.


-- ============================================================
-- QUERY 5: Subscription Age vs Churn
-- Do longer-tenure customers churn less?
-- ============================================================

SELECT
    AVG(CASE WHEN churn = 1 THEN subscription_age END) AS churned_avg_tenure,
    AVG(CASE WHEN churn = 0 THEN subscription_age END) AS retained_avg_tenure
FROM customers;

-- Results:
-- Churned customers avg tenure:  2.23 years
-- Retained customers avg tenure: 2.73 years
-- Finding: Tenure has minimal impact on churn. The 0.5 year difference is not a strong signal.
--          Loyalty programs based purely on tenure would likely be ineffective.
