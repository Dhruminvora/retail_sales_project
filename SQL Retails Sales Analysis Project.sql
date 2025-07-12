--1. Database Setup
--Database Creation: The project starts by creating a database named p1_retail_db.
--Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

--2. DATA Exploration & Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Checking Data Count after Deletion of records

SELECT COUNT(*) FROM retail_sales;

-- 3. Data Analysis & Findings
--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantiy >=4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) TotalSaleOfEachCategory
FROM retail_sales
GROUP BY category;
	
--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT AVG(age) Average_Age FROM retail_sales
WHERE category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale > 1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT DISTINCT COUNT(transactions_id) transactions, gender, category
FROM retail_sales
GROUP BY gender, category
ORDER BY transactions DESC;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year using CTE and windows function:
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        ROUND(AVG(total_sale),2) AS average_monthly_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
RankedMonths AS (
    SELECT 
        sales_year,
        sales_month,
        average_monthly_sales,
        RANK() OVER (PARTITION BY sales_year ORDER BY average_monthly_sales DESC) AS rnk
    FROM MonthlySales
)
SELECT 
    sales_year,
    sales_month,
    average_monthly_sales
FROM RankedMonths
WHERE rnk = 1
ORDER BY sales_year;

--**Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT TOP 5 customer_id, SUM(total_sale) net_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sale DESC;

--Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category,    
       COUNT(DISTINCT customer_id) as count_unique_customer
FROM retail_sales
GROUP BY category;

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY number_of_orders DESC;