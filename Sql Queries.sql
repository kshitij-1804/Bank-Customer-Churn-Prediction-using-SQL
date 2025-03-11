CREATE DATABASE  BANK_DB;

USE BANK_DB;

CREATE TABLE CUST_DT (
    CUSTOMER_ID INT,
    CREDIT_SCORE INT,
    COUNTRY VARCHAR(50),
    GENDER VARCHAR(7),
    AGE INT,
    TENURE INT,
    BALANCE FLOAT,
    PRODUCTS_NUMBER INT,
    CREDIT_CARD INT,
    ACTIVE_MEMBER INT,
    ESTIMATED_SALARY DECIMAL(8 , 6 ),
    CHURN INT
);

SELECT * FROM CUST_DT;

SELECT COUNT(*) FROM CUST_DT;

-- This query checks whether each specified column in the CUSTOMER_DETAIL(CUST_DT) table contains NULL values. However, the way it is currently structured will return a single boolean result (TRUE or FALSE) for each column across all rows

SELECT 
    CUSTOMER_ID IS NULL,
    CREDIT_SCORE IS NULL,
    COUNTRY IS NULL,
    GENDER IS NULL,
    AGE IS NULL,
    TENURE IS NULL,
    BALANCE IS NULL,
    BALANCE IS NULL,
    PRODUCTS_NUMBER IS NULL,
    CREDIT_CARD IS NULL,
    ACTIVE_MEMBER IS NULL,
    ESTIMATED_SALARY IS NULL,
    CHURN IS NULL
FROM
    CUST_DT;
    
-- Beginner Level

-- What is the total number of customers in the dataset?
-- How many customers have a credit score above 700?
-- What is the average age of all customers?

-- Intermediate Level

-- How many customers have churned versus those who have not?
-- What is the average balance of customers who have a credit card?
-- List all unique countries represented in the dataset.

-- Advanced Level

-- What percentage of active members have churned compared to non-active members?
-- Find the average estimated salary for customers who have churned.
-- Create a report showing the number of products held by each customer and their churn status.

-- Expert Level

-- Write a query that predicts churn based on customer demographics using a CASE statement.
-- Identify trends in customer balances over time for those who have churned.
-- Calculate the correlation between credit score and balance for all customers.

-- Data Analysis Level

-- Generate a summary report that groups customers by country and provides average balance and churn rate.
-- Write a query that identifies the top 10% of customers based on estimated salary and their churn status.
-- Create a view that shows customer details along with their tenure categorized into ranges (e.g., 0-1 years, 1-3 years).
    

--  Q.1 What is the total number of customers in the dataset?

SELECT DISTINCT(COUNT(*)) AS TOTAL_CUSTOMERS
FROM CUST_DT;

-- Q.2 How many customers have a credit score above 700?

SELECT COUNT(*) AS HIGH_CREDIT_SCORE_CUSTOMER
FROM CUST_DT
WHERE CREDIT_SCORE >=700;

--  Q.3 What is the average age of all customers?

SELECT AVG(AGE) AS AVERAGE_AGE 
FROM CUST_DT;

-- Q.4 How many customers have churned versus those who have not?

SELECT CHURN, COUNT(*) AS TOTAL_CUSTOMERS
FROM CUST_DT
GROUP BY CHURN;


-- Q.5 What is the average balance of customers who have a credit card?

SELECT CREDIT_CARD , AVG(BALANCE) AS AVERAGE_BALANCE
FROM CUST_DT
GROUP BY CREDIT_CARD;



-- Q.6 List all unique countries represented in the dataset.

SELECT DISTINCT(COUNTRY) FROM CUST_DT;

-- Q.7 What percentage of active members have churned compared to non-active members?

SELECT ACTIVE_MEMBER , AVG(CHURN) *100 AS CHURN_PERCENTAGE
FROM CUST_DT
GROUP BY ACTIVE_MEMBER;

-- Q.8 Find the average estimated salary for customers who have churned.

SELECT AVG(ESTIMATED_SALARY) AS AVG_ESTIMATED_SALARY,CHURN
FROM CUST_DT
WHERE CHURN = 1;


-- Q.9 Create a report showing the number of products held by each customer and their churn status.

SELECT CUSTOMER_ID , PRODUCTS_NUMBER ,CHURN
FROM CUST_DT;

-- Q.10 Write a query that predicts churn based on customer demographics using a CASE statement.

SELECT 
    CASE
        WHEN AGE < 30 THEN 'YOUNG'
        WHEN AGE BETWEEN 30 AND 50 THEN 'MIDDLE-AGED'
        ELSE 'SENIOR'
    END AS AGE_GROUP,
    CHURN
FROM
    CUST_DT;
    
-- Q.11 Identify trends in customer balances over time for those who have churned.

SELECT TENURE ,  AVG(BALANCE) AS AVERAGE_BALANCED_CHURNED 
FROM CUST_DT
WHERE CHURN = 1
GROUP BY TENURE
ORDER BY TENURE;

-- Q.11 Generate a summary report that groups customers by country and provides average balance and churn rate.

SELECT COUNTRY , AVG(BALANCE) AS AVERAGE_BALANCE , AVG(CHURN) AS CHURN_RATE
FROM CUST_DT
GROUP BY COUNTRY;

-- Q.12 Write a query that identifies the top 10% of customers based on estimated salary and their churn status.

WITH SALARYRANKED AS (
SELECT * , NTILE(10) OVER (ORDER BY ESTIMATED_SALARY DESC) AS SALARY_DECILE
FROM CUST_DT)
SELECT CUSTOMER_ID , ESTIMATED_SALARY , CHURN
FROM SALARYRANKED
WHERE SALARY_DECILE = 1
limit 10;

-- Q.13 Create a view that shows customer details along with their tenure categorized into ranges (e.g., 0-1 years, 1-3 years).

CREATE VIEW CUSTOMER_TENURE_VIEW AS
SELECT CUSTOMER_ID , 
CASE WHEN TENURE =0 THEN 'NEW'
WHEN TENURE BETWEEN 1 AND 3 THEN ' 1-3 YEARS'
WHEN TENURE BETWEEN 4 AND 6 THEN '4-6 YEARS'
ELSE '7+ YEARS'
END AS TENURE_CATEGORY , CREDIT_SCORE , COUNTRY , GENDER , AGE , BALANCE , PRODUCTS_NUMBER , CREDIT_CARD , ACTIVE_MEMBER , ESTIMATED_SALARY , CHURN 
FROM CUST_DT;

SELECT * FROM CUSTOMER_TENURE_VIEW;

-- BUSINESS SCENARIO QUESTIONS

-- Customer Segmentation: What are the characteristics of customers who churn versus those who remain?
-- Churn Prediction: Can we predict which customers are likely to churn based on their attributes?
-- Product Usage: How does the number of products a customer has relate to their likelihood of churning?
-- Demographic Analysis: What demographic factors (age, gender, country) are associated with higher churn rates?
-- Balance Impact: Does a higher account balance correlate with lower churn rates?
-- Credit Score Influence: How does a customer's credit score affect their likelihood of remaining an active member?
-- Tenure Analysis: Is there a relationship between the length of time a customer has been with the bank and their likelihood to churn?
-- Salary Insights: How does estimated salary influence customer retention and product usage?
-- Active Membership Trends: What percentage of customers are active members, and how does this relate to churn?
-- Country Comparison: Which country has the highest churn rate and what factors contribute to this?
-- Gender Differences: Are there significant differences in churn rates between male and female customers?
-- Product Effectiveness: Which products are associated with higher retention rates among customers?
-- Churn Rate Over Time: How has the churn rate changed over different periods (e.g., by tenure)?
-- Customer Value Assessment: What is the average balance of customers who have churned compared to those who have not?
-- Marketing Strategies: What targeted marketing strategies could be developed based on customer characteristics to reduce churn?


SELECT * FROM CUST_DT;

-- Q.14 Customer Segmentation: What are the characteristics of customers who churn versus those who remain?

-- CUSTOMER SEGMENTATION

SELECT 
    AVG(AGE) AS AVG_AGE,
    AVG(BALANCE) AS AVG_BALANCE,
    -- COUNT(*) AS TOTAL_CUSTOMERS,
    SUM(CASE
        WHEN CHURN = 1 THEN 1
        ELSE 0
    END) AS CHURNED_CUSTOMER,
    SUM(CASE
        WHEN CHURN = 0 THEN 1
        ELSE 0
    END) AS RETAINED_CUSTOMER
FROM
    CUST_DT
GROUP BY CHURN;


-- Q.14  Can we predict which customers are likely to churn based on their attributes?

-- CHURN PREDICTION

SELECT CUSTOMER_ID , COUNTRY , GENDER , AGE , BALANCE ,  CREDIT_SCORE,CHURN
FROM CUST_DT
WHERE CHURN = 1;

-- Q.15 How does the number of products a customer has relate to their likelihood of churning?

-- PRODUCT_USAGE

SELECT 
    PRODUCTS_NUMBER, AVG(CHURN) AS AVG_CHURN_RATE
FROM
    CUST_DT
GROUP BY PRODUCTS_NUMBER
ORDER BY AVG_CHURN_RATE;

-- Q.16 What demographic factors (age, gender, country) are associated with higher churn rates?

-- DEMOGRAPHICS ANALYSIS

SELECT 
    COUNTRY,
    GENDER,
    AVG(AGE) AS AVG_AGE,
    AVG(CHURN) AS HIGH_CHURN_RATES
FROM
    CUST_DT
GROUP BY COUNTRY ,GENDER
ORDER BY HIGH_CHURN_RATES DESC;

-- Q.17 Does a higher account balance correlate with lower churn rates?

-- BALANCE IMPACT

SELECT 
    CASE
        WHEN BALANCE >= 125000 THEN 'HIGH BALANCE'
        ELSE 'LOW BALANCE'
    END AS BALANCE_CATEGORY,
    AVG(CHURN) AS AVG_CHURN_RATE
FROM
    CUST_DT
GROUP BY BALANCE_CATEGORY
order by avg_churn_rate desc;

-- Q.18  How does a customer's credit score affect their likelihood of remaining an active member?

-- CREDIT SCORE INFLUENCE


SELECT
CASE WHEN CREDIT_SCORE BETWEEN 700 AND 850 THEN 'GOOD'
	WHEN CREDIT_SCORE BETWEEN 450 AND 700 THEN 'AVERAGE'
    ELSE 'BAD' END AS CREDIT_SCORE_CATEGORY , AVG(ACTIVE_MEMBER)*100 AS ACTIVE_MEMBER_RATE
FROM CUST_DT
GROUP BY CREDIT_SCORE_CATEGORY;

-- Q.19  Is there a relationship between the length of time a customer has been with the bank and their likelihood to churn?

-- TENURE ANALYSIS

SELECT 
    TENURE, AVG(CHURN) AS AVG_CHURN_RATE
FROM
    CUST_DT
GROUP BY TENURE
ORDER BY TENURE;

SELECT 
CASE WHEN TENURE BETWEEN 0 AND 3 THEN 'INITIAL PERIOD' 
	WHEN TENURE BETWEEN 4 AND 7 THEN ' MIDDLE PERIOD ' ELSE 'MATURE PERIOD' END AS TENURE , AVG(CHURN) AS CHURN_RATE 
    FROM CUST_DT
    GROUP BY TENURE 
    ORDER BY CHURN_;

-- Q.20 How does estimated salary influence customer retention and product usage?

-- SALARY INSIGHTS

SELECT 
    CASE
        WHEN ESTIMATED_SALARY < 50000 THEN 'LOW_INCOM0E'
        WHEN ESTIMATED_SALARY BETWEEN 50000 AND 100000 THEN 'MEDIUM'
        ELSE 'HIGH_INCOME'
    END AS SALARY_CATEGORY,
    AVG(PRODUCTS_NUMBER) AS PRODUCT_USAGE,
    AVG(CHURN) AS RETENTION_RATE
FROM
    CUST_DT
GROUP BY SALARY_CATEGORY;

-- Q.21 What percentage of customers are active members, and how does this relate to churn?

-- ACTIVE MEMBERSHIP TREND

SELECT 
    ACTIVE_MEMBER,
    COUNT(*) * 100.0 / (SELECT 
            COUNT(*)
        FROM
            CUST_DT) AS PERCENTAGE_ACTIVE_MEMBERS,
    AVG(CHURN) AS AVG_CHURN_RATE
FROM
    CUST_DT
GROUP BY ACTIVE_MEMBER;

-- Q.22 Which country has the highest churn rate and what factors contribute to this?

-- COUNTRY COMPARISON

SELECT 
    COUNTRY,
    COUNT(*) AS TOTAL_CUSTOMER,
    GENDER,
    AVG(AGE) AS AVG_AGE,
    AVG(BALANCE),
    AVG(CREDIT_SCORE),
    AVG(estimated_salary) AS AVG_SALARY,
    AVG(CHURN) AS CHURN_RATE
FROM
    CUST_DT
GROUP BY COUNTRY , GENDER
ORDER BY CHURN_RATE DESC
LIMIT 1;

-- Q.23 Are there significant differences in churn rates between male and female customers?

-- GENDER DIFFERENCE

SELECT GENDER , AVG(CHURN) AS CHURN_RATE , COUNT(*) AS TOTAL_CUSTOMERS
FROM CUST_DT
GROUP BY GENDER;

-- Q.24 Which products are associated with higher retention rates among customers?

-- PRODUCT EFFECTIVENESS

SELECT 
    COUNT(*) AS TOTAL_CUSTOMERS,
    PRODUCTS_NUMBER AS PRODUCTS,
    AVG(CHURN) AS RETENTION_RATE
FROM
    CUST_DT
GROUP BY PRODUCTS
ORDER BY RETENTION_RATE ASC;

-- Q.25 How has the churn rate changed over different periods (e.g., by tenure)?

-- CHURN RATE OVER TIME

SELECT TENURE , AVG(CHURN) AS AVG_CHURN_RATE
FROM CUST_DT
GROUP BY TENURE
ORDER BY TENURE ;

-- Q.26 What is the average balance of customers who have churned compared to those who have not?

-- CUSTOMER VALUE ASSESSMENT

SELECT 
    CASE
        WHEN CHURN = 1 THEN 'CHURNED'
        ELSE 'RETAINED'
    END AS CHURN_COMPARISON,
    AVG(BALANCE)
FROM
    CUST_DT
GROUP BY CHURN_COMPARISON;

-- Q.27 What targeted marketing strategies could be developed based on customer characteristics to reduce churn?

-- MARKETING STRATEGIES

SELECT 
    COUNTRY, GENDER, AGE_GROUP, COUNT(*) AS POTENTIAL_TARGETS
FROM
    (SELECT 
        GENDER,
            COUNTRY,
            CASE
                WHEN AGE BETWEEN 18 AND 30 THEN 'YOUNG'
                WHEN AGE BETWEEN 30 AND 55 THEN 'MIDDLE_AGE'
                ELSE ' SENIOR'
            END AS AGE_GROUP
    FROM
        CUST_DT
    WHERE
        CHURN = 1) AS SUBQUERYY
GROUP BY GENDER , COUNTRY , AGE_GROUP;



SELECT * FROM CUST_DT;


 
