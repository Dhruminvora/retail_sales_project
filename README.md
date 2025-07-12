# 🛒 Retail Sales SQL Data Analysis

## 📌 Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`  

This project demonstrates end-to-end data analysis using **SQL**, specifically within **Microsoft SQL Server (T-SQL)**. The focus is on simulating a real-world retail business scenario where transactional sales data is analyzed for actionable insights.

### 🎯 Objectives
To design a clean retail sales database, explore and clean raw data, and perform insightful SQL queries to identify customer trends, peak sales periods, high-value transactions, and performance across product categories.

---

## 🧠 Skills Demonstrated

- **Database Design & Setup**: Created a normalized schema with appropriate data types and constraints to store transactional retail sales data.
- **Data Cleaning & Validation**: Identified and removed null or incomplete records using SQL filtering techniques to ensure data integrity.
- **Data Exploration**: Executed queries to understand data distribution, spot inconsistencies, and profile customer demographics and product segments.
- **Advanced SQL Analysis**:
  - Used `GROUP BY`, `COUNT`, `SUM`, and `AVG` for aggregations.
  - Applied **CTEs (Common Table Expressions)** and **Window Functions (`RANK()`)** for complex logic like identifying the best-selling month per year.
  - Used `CASE` statements to segment data into time-based shifts (Morning, Afternoon, Evening).
- **Business Insights**:
  - Identified top-spending customers and high-value transactions.
  - Highlighted product categories with the highest revenue and most unique buyers.
  - Analyzed sales performance trends by month and customer demographics.

---

## 📂 Project Structure

### 1. Database Setup

**Database Creation:**  
```sql
CREATE DATABASE retails_db;
```

**Table Creation:**  
```sql
CREATE TABLE retail_sales (
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
```

### 2. Data Exploration & Cleaning

- **Record Count**
```sql
SELECT COUNT(*) FROM retail_sales;
```

- **Unique Customer Count**
```sql
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
```

- **Unique Categories**
```sql
SELECT DISTINCT category FROM retail_sales;
```

- **Null Value Check**
```sql
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

- **Remove Null Records**
```sql
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

- **Sales on 2022-11-05**
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

- **Clothing Sales with Quantity > 4 in November 2022**
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

- **Total Sales by Category**
```sql
SELECT category, SUM(total_sale) AS TotalSaleOfEachCategory
FROM retail_sales
GROUP BY category;
```

- **Average Age of Beauty Buyers**
```sql
SELECT AVG(age) AS Average_Age FROM retail_sales
WHERE category = 'Beauty';
```

- **Transactions Over $1000**
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

- **Transaction Count by Gender and Category**
```sql
SELECT COUNT(transactions_id) AS transactions, gender, category
FROM retail_sales
GROUP BY gender, category
ORDER BY transactions DESC;
```

- **Best-Selling Month in Each Year**
```sql
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
```

- **Top 5 Customers by Total Sales**
```sql
SELECT TOP 5 customer_id, SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sale DESC;
```

- **Unique Customers per Category**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS count_unique_customer
FROM retail_sales
GROUP BY category;
```

- **Orders by Time Shift**
```sql
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
```

---

## 📊 Findings

- **Customer Demographics**: Customers vary in age and gender, with significant engagement in categories like Clothing and Beauty.
- **High-Value Transactions**: Several purchases exceeded $1000, indicating premium buyers.
- **Sales Trends**: Monthly performance analysis revealed high and low-performing months per year.
- **Customer Insights**: Identified top customers and popular categories; calculated unique customer counts per segment.
- **Time-Based Patterns**: Most orders occur during specific parts of the day (Morning, Afternoon, Evening).

---

## 📈 Reports

- **Sales Summary**: Total and average sales by product category and customer demographics.
- **Trend Analysis**: Monthly and shift-based analysis to highlight seasonal performance.
- **Customer Insights**: Top-spending customers and unique buyers across categories.

---

## ✅ Conclusion

This project simulates a real-world scenario where SQL is used to perform complete retail data analysis. From database creation and cleaning to generating powerful business insights using SQL, this project demonstrates practical skills crucial for any Data Analyst role.

Key insights can help businesses optimize:
- Marketing strategies  
- Inventory planning  
- Customer engagement and loyalty programs
