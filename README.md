# Advanced SQL Business Analytics & Insights

A collection of SQL analytics scripts designed to extract actionable business intelligence from sales, customer, and product datasets. This repository demonstrates core data warehousing concepts, window functions, advanced aggregations, and automated reporting views.

---

## Included SQL Scripts & Analytics Models

| Script File | Description & Core Concepts |
| :--- | :--- |
| **`ChangesOverTimeAnalysis.sql`** | Tracks monthly and yearly sales trends, total active customers, and volume over time. |
| **`CumulativeAnalysis.sql`** | Computes running totals of sales and moving average pricing using SQL window functions. |
| **`PerformanceAnalysis.sql`** | Evaluates yearly product performance against historical averages and calculates Year-over-Year (YoY) growth using `LAG()`. |
| **`Part-to-WholeAnalysis.sql`** | Analyzes category-level contributions to overall business revenue as percentages. |
| **`DataSegmentation.sql`** | Segments products by cost ranges and categorizes customers into behavioral tiers (VIP, Regular, New). |
| **`CustomerReport.sql`** | Builds a consolidated view (`report_customers`) combining demographics, RFM metrics, age groups, and average monthly spend. |
| **`ProductReport.sql`** | Generates a comprehensive product performance report (`report_products`) using `NTILE()` tiering, lifespan, and recency analytics. |

---

## Key Features & Techniques

* **Advanced Window Functions:** Leverages `SUM() OVER()`, `AVG() OVER()`, `LAG()`, and `NTILE()` for deep comparative analytics.
* **Data Segmentation & Behavioral Tiers:** Automatically classifies customers and products into dynamic tiers to support targeted marketing and inventory strategies.
* **BI-Ready Views:** Includes commented migration scripts to turn complex analytical queries into shareable database views for downstream reporting tools (e.g., Power BI, Tableau).
* **Null Handling:** Utilizes functions like `COALESCE` and clean conditional casing (`CASE WHEN`) to safeguard against unbalanced metrics.

---

## Prerequisites & Environment

These scripts are written in **SQL** and optimized for **Microsoft SQL Server / Azure SQL Database**. They assume a standard relational schema containing at least:
* `fact_sales` (Transactional sales data)
* `dim_customers` (Customer profiles)
* `dim_products` (Product details and catalog info)

---

## Usage

Clone the repository and run the scripts in your preferred SQL client (such as SSMS or Azure Data Studio) connected to your data warehouse or analytical database. 
