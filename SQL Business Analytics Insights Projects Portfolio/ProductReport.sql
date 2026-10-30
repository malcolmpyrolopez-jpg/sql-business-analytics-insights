-- Product Report --
/* Purpose: This report consolidates key product metrics and behaviours

	Highlights:
		1. Gathers essential fields such as product name, category, subcategory, and cost
		2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers
		3. Aggregates product-level metrics:
			- total orders
			- total sales
			- total quantity sold
			- total customers (unique)
			- lifespan (in months)
		4. Calculates valuable KPIs:
			- recency (months since last sale)
			- average order revenue (AOR)
			- average monthly revenue*/

/*CREATE VIEW report_products AS*/ -- Uncomment this as this is the final step for this query to create a view and for it to be shared so that other users can create visualizations around it.
WITH product_base AS (
    -- Step 1: Gather essential fields and aggregate product-level metrics
    SELECT 
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        COUNT(DISTINCT s.order_number) AS total_orders,
        COALESCE(SUM(s.sales_amount), 0) AS total_sales,
        COALESCE(SUM(s.quantity), 0) AS total_quantity_sold,
        COUNT(DISTINCT s.customer_key) AS total_customers,
        MIN(s.order_date) AS first_sale_date,
        MAX(s.order_date) AS last_sale_date
    FROM dim_products p
    LEFT JOIN fact_sales s ON p.product_key = s.product_key
    GROUP BY 
        p.product_key, 
        p.product_name, 
        p.category, 
        p.subcategory, 
        p.cost
),
global_max_date AS (
    -- Reference date for recency (latest order date in the dataset)
    SELECT MAX(order_date) AS max_date FROM fact_sales
),
calculated_metrics AS (
    SELECT 
        b.product_name,
        b.category,
        b.subcategory,
        b.cost,
        b.total_orders,
        b.total_sales,
        b.total_quantity_sold,
        b.total_customers,
        
        -- Lifespan in months (days between first and last sale / 30.0)
        ROUND(CAST(DATEDIFF(day, b.first_sale_date, b.last_sale_date) AS FLOAT) / 30.0, 1) AS lifespan_months,
        
        -- Recency: Months since last sale relative to the dataset's latest date
        ROUND(CAST(DATEDIFF(day, b.last_sale_date, g.max_date) AS FLOAT) / 30.0, 1) AS recency_months,
        
        -- Average Order Revenue (AOR)
        CASE 
            WHEN b.total_orders > 0 THEN b.total_sales / b.total_orders 
            ELSE 0 
        END AS average_order_revenue,
        
        -- Average Monthly Revenue
        CASE 
            WHEN DATEDIFF(day, b.first_sale_date, b.last_sale_date) > 0 
            THEN b.total_sales / (CAST(DATEDIFF(day, b.first_sale_date, b.last_sale_date) AS FLOAT) / 30.0)
            ELSE b.total_sales 
        END AS average_monthly_revenue,

        -- Segment products into 3 performance tiers by total sales
        NTILE(3) OVER (ORDER BY b.total_sales DESC) AS revenue_tier
    FROM product_base b
    CROSS JOIN global_max_date g
)
-- Final Selection & Segment Labeling (Without ORDER BY)
SELECT 
    product_name,
    category,
    subcategory,
    cost,
    CASE 
        WHEN revenue_tier = 1 THEN 'High-Performer'
        WHEN revenue_tier = 2 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS performance_segment,
    total_orders,
    total_sales,
    total_quantity_sold,
    total_customers,
    COALESCE(lifespan_months, 0) AS lifespan_months,
    COALESCE(recency_months, 0) AS recency_months,
    ROUND(average_order_revenue, 2) AS average_order_revenue,
    ROUND(average_monthly_revenue, 2) AS average_monthly_revenue
FROM calculated_metrics;