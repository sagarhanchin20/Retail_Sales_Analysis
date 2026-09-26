# Retail Sales Analysis Using SQL

## Project Overview

This project analyzes retail sales transaction data using **MySQL** to demonstrate practical SQL skills used in data analysis.

The analysis covers database creation, data cleaning, exploratory data analysis, aggregation, date and time analysis, customer segmentation, and business-focused SQL queries.

The objective is to transform raw retail transaction data into meaningful insights about **sales performance, customer behavior, product categories, and purchasing patterns**.

---

## Tools & Technologies

* **Database:** MySQL
* **Language:** SQL
* **Data Source:** Retail Sales Dataset
* **Environment:** MySQL Workbench

---

## Dataset

The dataset contains retail transaction records with the following fields:

| Column           | Description                   |
| ---------------- | ----------------------------- |
| `transaction_id` | Unique transaction identifier |
| `sale_date`      | Date of the transaction       |
| `sale_time`      | Time of the transaction       |
| `customer_id`    | Unique customer identifier    |
| `gender`         | Customer gender               |
| `age`            | Customer age                  |
| `category`       | Product category              |
| `quantity`       | Quantity purchased            |
| `price_per_unit` | Price per unit                |
| `cogs`           | Cost of goods sold            |
| `total_sale`     | Total transaction value       |

---

## Project Objectives

* Set up a relational database for retail sales data.
* Explore the structure and characteristics of the dataset.
* Identify and handle missing values.
* Analyze sales across different product categories.
* Analyze customer purchasing behavior.
* Identify high-value transactions and top customers.
* Analyze monthly sales trends.
* Use SQL date and time functions for business analysis.
* Apply aggregate functions, subqueries, CTEs, and window functions.

---

## Database Setup

```sql
CREATE DATABASE sql_project1;
USE sql_project1;
CREATE TABLE retail_sales(transaction_id INT PRIMARY KEY,
						sale_date DATE,
						sale_time TIME,
						customer_id INT,
						gender VARCHAR(15),
						age INT,
						category VARCHAR(20),
						quantity INT,
						price_per_unit FLOAT,
						cogs FLOAT,
						total_sale FLOAT);
```

---

## Data Exploration & Cleaning

Initial exploration was performed to understand the dataset and verify its integrity.

### Record Count

```sql
SELECT COUNT(*) FROM retail_sales;
```

### Unique Customers

```sql
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
```

### Product Categories

```sql
SELECT DISTINCT category FROM retail_sales;
```

### Missing Value Check

```sql
SELECT * FROM retail_sales
WHERE transaction_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
OR customer_id IS NULL OR gender IS NULL OR category IS NULL OR quantity is NULL
OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

Records containing missing values were identified and handled during the data-cleaning stage.

---

# Business Analysis

The following business questions were addressed using SQL.

### 1. Sales on a Specific Date

Retrieve all transactions made on **November 5, 2022**.

```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 2. Clothing Transactions in November 2022

Find Clothing transactions where more than 4 units were sold during November 2022.

```sql
SELECT * FROM retail_sales
WHERE category='Clothing'
AND quantity >= 4
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01';
```

### 3. Total Sales by Category

```sql
SELECT category, SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY category;
```

### 4. Average Customer Age — Beauty Category

```sql
SELECT category, ROUND(AVG(age),2) AS AvgAgeOfCustomers
FROM retail_sales
WHERE category= 'Beauty';
```

### 5. High-Value Transactions

Identify transactions where the total sale amount exceeded 1000.

```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### 6. Transactions by Gender and Category

```sql
SELECT gender, category, COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;
```

### 7. Best-Selling Month for Each Year

Calculate the average monthly sale and identify the highest-performing month for each year.

```sql
SELECT * FROM(
	SELECT EXTRACT(YEAR FROM sale_date) AS year, 
	EXTRACT(MONTH FROM sale_date) AS month, 
	ROUND(AVG(total_sale),2) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranks 
	FROM retail_sales
	GROUP BY year, month
) as t
WHERE ranks = 1;
```

This query demonstrates the use of a **window function (`RANK`)** to compare monthly performance within each year.

### 8. Top 5 Customers by Total Spending

```sql
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
```

### 9. Unique Customers by Category

```sql
SELECT COUNT(DISTINCT customer_id) AS count_of_unique_customers, category
FROM retail_sales
GROUP BY category;
```

### 10. Orders by Time of Day

Transactions were categorized into Morning, Afternoon, and Evening shifts.

```sql
WITH hourly_sale
AS(
SELECT sale_time,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS shift,
quantity
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

# SQL Concepts Demonstrated

This project applies the following SQL concepts:

* `SELECT` and `WHERE`
* Filtering with multiple conditions
* `GROUP BY`
* `ORDER BY`
* Aggregate functions: `COUNT()`, `SUM()`, `AVG()`
* `COUNT(DISTINCT)`
* `CASE` statements
* Date and time functions
* `EXTRACT()`
* Common Table Expressions (`WITH`)
* Subqueries
* Window functions
* `RANK()`
* Data cleaning and NULL handling

---

# Key Insights

The analysis provides insights into:

* Sales performance across product categories.
* Customer purchasing patterns.
* High-value transactions.
* Top-spending customers.
* Monthly sales performance.
* Customer distribution across product categories.
* Order volume across different times of the day.

---

# Conclusion

This project demonstrates the use of **MySQL and SQL for practical retail sales analysis**. The analysis covers the complete workflow from database setup and data cleaning to exploratory analysis and business-oriented querying.

The project provided hands-on experience with **aggregation, date and time analysis, CTEs, subqueries, CASE statements, and window functions**, while translating business questions into SQL queries and analytical insights.
