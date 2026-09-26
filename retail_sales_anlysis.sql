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

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantity is NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

DELETE FROM retail_sales
WHERE transaction_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantity is NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

SELECT COUNT(*) FROM retail_sales;

-- Data Exploration
-- How many sales we have?
SELECT COUNT(sales) AS TotalSales FROM retail_sales;

-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) AS TotalCustomers FROM retail_sales;

-- How many distinct category we have?
SELECT COUNT(DISTINCT category) AS TotalCategories FROM retail_sales;
SELECT DISTINCT category AS DiffCategories FROM retail_sales;

-- Analysis
-- Retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Retrieve all transcation where the category is 'clothing' and the quantity sold is more than or equal to 4 in the month of Nov-22
SELECT * FROM retail_sales
WHERE category='Clothing'
AND quantity >= 4
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01';

-- Calculate the total sales (tota_sales) for each category
SELECT category, SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY category;

-- Find average of customers who purchased items from the 'Beauty' category
SELECT category, ROUND(AVG(age),2) AS AvgAgeOfCustomers
FROM retail_sales
WHERE category= 'Beauty';

-- Find all transactions where the total sales is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Find total number of transactions made by each gender in each category
SELECT gender, category, COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;

-- Calculate the average sale for each month. Find out the best selling month in each year
SELECT * FROM(
	SELECT EXTRACT(YEAR FROM sale_date) AS year, 
	EXTRACT(MONTH FROM sale_date) AS month, 
	ROUND(AVG(total_sale),2) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranks 
	FROM retail_sales
	GROUP BY year, month
) as t
WHERE ranks = 1;

-- Find top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Find the number of unique customer who purchased items from each category
SELECT COUNT(DISTINCT customer_id) AS count_of_unique_customers, category
FROM retail_sales
GROUP BY category;

-- Create each shift and number of orders (example: Morning <= 12, Afternoon 12 & 17, Evening > 17
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