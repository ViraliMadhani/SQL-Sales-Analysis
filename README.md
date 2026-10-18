# SQL Sales Analysis

## About the Project

This project explores sales data using SQL Server to understand sales trends, product performance, revenue distribution, and customer behaviour.

The analysis goes beyond basic sales summaries, using SQL to compare performance over time, identify revenue patterns, and segment customers based on their purchasing history.

## Analysis Covered

- **Sales Trends:** Analysed monthly and yearly sales patterns.
- **Cumulative Analysis:** Used running totals and average calculations to examine sales over time.
- **Product Performance:** Compared product sales with historical averages and previous-year performance.
- **Revenue Distribution:** Analysed revenue contributions across product categories and countries.
- **Customer Segmentation:** Classified customers into New, Regular, and VIP segments using spending and customer lifespan.
- **Reporting Views:** Created SQL views for customer and product reporting.

## SQL Concepts Used

SQL Server, joins, aggregate functions, CTEs, window functions, `CASE WHEN`, date functions, subqueries, and views.

## Key Findings

- Bikes accounted for approximately 96.46% of total revenue in the analysed results.
- The United States and Australia together contributed approximately 62.07% of total revenue.
- Around 79% of customers fell into the New segment under the project's segmentation rules.

The findings PDF provides further details and context. These observations are based on the query outputs and the definitions used in this project.

## Repository Contents

The repository contains six SQL query files covering different areas of analysis and one PDF documenting the key findings and business observations.

## Setup Instructions

1. Install Microsoft SQL Server and SQL Server Management Studio (SSMS).
2. Obtain the database backup from the original dataset source and restore it in SSMS.
3. Open the relevant SQL files and execute the queries against the restored database.

**Note:** Queries using `DATETRUNC` require SQL Server 2022 or later.

## Notes

This project was completed as part of my SQL practice and portfolio development, with a focus on applying SQL techniques to explore sales data and interpret business patterns.
