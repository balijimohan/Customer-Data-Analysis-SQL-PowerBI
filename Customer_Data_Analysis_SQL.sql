-- ============================================================
-- Project Name : Customer Data Analysis Using SQL
-- Author       : Mohan Baliji
-- Database     : Customer_Data_Analysis
-- Tool         : MySQL Workbench
-- ============================================================

------- DATABASE ---------

CREATE DATABASE customer_data_analysis;
USE customer_data_analysis;
SELECT * FROM customer;
----------------------------------------------------------------

-------- CREATE TABLE ------

CREATE TABLE customer (
    invoice_no VARCHAR(20),
    customer_id VARCHAR(20),
    gender VARCHAR(20),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    payment_method VARCHAR(30),
    invoice_date VARCHAR(20),
    shopping_mall VARCHAR(100)
);
-----------------------------------------------------------------
-- NOTE:
-- Import the CSV dataset into the Customer table.
-- using MySQL Workbench -> Table Data Import Wizard.

---- ====================================================================
---- DATA CLEANING & PREPROCESSING ---------
---- ====================================================================

SELECT COUNT(*) AS total_records FROM customer;

--- Check NULL Values --------

SELECT * FROM customer
WHERE invoice_no IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price IS NULL
   OR payment_method IS NULL
   OR invoice_date IS NULL
   OR shopping_mall IS NULL;
--------------------------------------------------------------------------
--- Check Duplicate Records -------

SELECT
    invoice_no,
    COUNT(*) AS duplicate_count
FROM customer
GROUP BY invoice_no
HAVING COUNT(*) > 1;
----------------------------------------------------------------------------
--- Check Distinct Gender,Payment Methods,Category,Shopping Malls Values ------

SELECT DISTINCT gender        
FROM customer;

 SELECT DISTINCT category
FROM customer;

 SELECT DISTINCT payment_method
FROM customer;

SELECT DISTINCT shopping_mall
FROM customer;
---------------------------------------------------------------------------------
--- Check Age,Quantity and Price Range -------------

SELECT MIN(age),
       MAX(age)
FROM customer;
SELECT MIN(quantity),
       MAX(quantity)
FROM customer;
SELECT MIN(price),
       MAX(price)
FROM customer;
------------------------------------------------------------
--- Remove Leading/Trailing Spaces -----

UPDATE customer
SET gender = TRIM(gender);
UPDATE customer
SET category = TRIM(category);
UPDATE customer
SET payment_method = TRIM(payment_method);
UPDATE customer
SET shopping_mall = TRIM(shopping_mall);
----------------------------------------------------------------
--- CREATING NEW COLUMNS ------

ALTER TABLE customer
ADD revenue DECIMAL(12,2);
UPDATE customer
SET revenue = quantity * price;
ALTER TABLE customer
ADD age_group VARCHAR(20);
UPDATE customer
SET age_group =
CASE
    WHEN age < 20 THEN 'Teen'
    WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    ELSE '50+'
END;

SELECT * FROM customer;
------------------------------------------------------------------------------------

--- ===================================================================================
--- TASK QUESTIONS ----
--- ===================================================================================

--- 1.How is the shopping distribution according to gender?.

SELECT
    gender,
    COUNT(invoice_no) AS total_transactions
FROM customer
GROUP BY gender;
-----------------------------------------------------------------------------------
--- 2.Which gender did we sell more products to?

SELECT
    gender,
    SUM(quantity) AS total_products_sold
FROM customer
GROUP BY gender;
----------------------------------------------------------------------------------
--- 3.Which gender generated more revenue?

SELECT
    gender,
    ROUND(SUM(revenue),2) AS total_revenue
FROM customer
GROUP BY gender;
--------------------------------------------------------------------------------------
--- 4.Distribution of purchase categories relative to other columns?

SELECT
    category,
    gender,
    SUM(quantity) AS total_quantity
FROM customer
GROUP BY category, gender
ORDER BY category;
------------------------------------------------------------------------------------
--- 5.	How is the shopping distribution according to age?

SELECT
    age_group,
    COUNT(invoice_no) AS total_transactions
FROM customer
GROUP BY age_group;
---------------------------------------------------------------------------------
--- 6.Which age cat did we sell more products to?

SELECT
    age_group,
    SUM(quantity) AS total_products_sold
FROM customer
GROUP BY age_group;
--------------------------------------------------------------------------
--- 7.Which age cat generated more revenue?

SELECT
    age_group,
    ROUND(SUM(revenue),2) AS total_revenue
FROM customer
GROUP BY age_group;
-------------------------------------------------------------------------
--- 8.Distribution of purchase categories relative to other columns?

SELECT
    category,
    age_group,
    SUM(revenue) AS total_revenue
FROM customer
GROUP BY category, age_group
ORDER BY category;
----------------------------------------------------------------------------
--- 9.Does the payment method have a relation with other columns?

SELECT
    payment_method,
    gender,
    COUNT(invoice_no) AS total_transactions
FROM customer
GROUP BY payment_method, gender
ORDER BY payment_method;
----------------------------------------------------------------------------
--- 10.How is the distribution of the payment method?

SELECT
    payment_method,
    COUNT(invoice_no) AS total_transactions
FROM customer
GROUP BY payment_method;
----------------------------------------------------------------------------
--- 11.Top 5 Shopping Malls by Revenue (Extra Query).

SELECT
    shopping_mall,
    ROUND(SUM(revenue),2) AS total_revenue
FROM customer
GROUP BY shopping_mall
ORDER BY total_revenue DESC
LIMIT 5;

--- =====================================================================================
--- End of Customer Data Analysis SQL Project
--- =====================================================================================