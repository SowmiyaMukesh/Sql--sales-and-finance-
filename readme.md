# Sales & Financial Analytics using SQL

## Project Overview

In this project, I worked on a structured business dataset and performed end-to-end data analysis using SQL to understand sales performance, pricing, discount impact, and customer-level insights.
The project focuses on extracting meaningful business insights from transactional sales data by combining multiple fact and dimension tables and applying business logic step by step.
I created multiple queries, views, and stored procedures to analyze sales data at different levels such as customer, product, market, and region.
________________________________________
## Dataset & Data Model

The dataset consists of multiple structured tables including:
•	fact_sales_monthly → sales transactions
•	fact_gross_price → product pricing
•	fact_pre_invoice_deductions → pre-invoice discounts
•	fact_post_invoice_deductions → post-invoice discounts
•	fact_forecast_monthly → forecasted quantities
•	dim_customer → customer details
•	dim_product → product details
•	dim_date → date information
The data model follows a fact and dimension schema, enabling multi-dimensional analysis.
________________________________________
##Tools & Technologies Used

•	SQL (MySQL)
•	Joins (INNER, LEFT)
•	Aggregate Functions (SUM, ROUND)
•	GROUP BY & ORDER BY
•	CTE (Common Table Expressions)
•	Window Functions
•	Stored Procedures
•	Views
•	User-defined Functions
________________________________________
## What I Worked On
# 1. Sales & Revenue Analysis
•	Retrieved detailed sales records for specific customers
•	Calculated gross sales using price and quantity
•	Aggregated sales at daily, monthly, and yearly levels
________________________________________
# 2. Discount & Pricing Analysis
•	Applied pre-invoice discounts to calculate net invoice sales
•	Integrated post-invoice deductions
•	Calculated final net sales after multiple discount layers
________________________________________
# 3. Customer, Product & Market Analysis
•	Identified top markets, customers, and products based on net sales
•	Built parameterized queries to dynamically retrieve top N results
•	Analyzed customer contribution to total and regional sales
________________________________________
# 4. Advanced SQL Techniques
•	Used CTE to calculate contribution percentages
•	Applied window functions for percentage distribution
•	Created reusable views such as:
o	gross_sales
o	net_sales
o	sales_preinv_discount
o	sales_postinv_discount
________________________________________
# 5. Stored Procedures & Functions
•	Created stored procedures for:
o	top N customers by net sales
o	top N markets
o	top N products
•	Used user-defined functions:
o	get_fiscal_year()
o	get_fiscal_quarter()
________________________________________
# 6. Forecast vs Actual Analysis
•	Combined actual sales and forecast data into a new table
•	Calculated net error between forecasted and actual quantities
________________________________________
## Key Insights

•	Sales performance varies across markets, customers, and product categories
•	Discounts (pre and post invoice) significantly impact final net sales
•	A small group of customers and products contribute to a large share of revenue
•	Forecast vs actual comparison helps identify gaps in demand planning
________________________________________
## Conclusion

This project helped me strengthen my SQL skills by working with real-world business logic, including pricing, discounts, and performance analysis.
I was able to transform raw transactional data into structured insights using joins, aggregations, CTEs, and reusable SQL components like views and stored procedures.
The project reflects my ability to handle end-to-end data analysis using SQL in a business context.

