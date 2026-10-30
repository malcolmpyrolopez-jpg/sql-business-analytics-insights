-- Changes Over Time Analysis --
-- Analyzing the Sales Performance Over time

-- Sales Performance Over time in a specific date using the YEAR and MONTH in seperate columns 
select 
	YEAR(order_date) as order_year,
	MONTH(order_date) as order_month,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
from fact_sales
where order_date is not null
group by YEAR(order_date), MONTH(order_date)
order by YEAR(order_date), MONTH(order_date)

-- Sales Performance Over time in a specific date using the YEAR and MONTH
select 
	DATETRUNC(year, order_date) as order_date,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
from fact_sales
where order_date is not null
group by DATETRUNC(year, order_date)
order by DATETRUNC(year, order_date)

-- Sales Performance Over time in a specific date whichever you see fit, you can customize the date format
select
	FORMAT(order_date, 'MMM-dd-yyyy') as order_date, -- Change the date format on the string function whichever data format you want
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
from fact_sales
where order_date is not null
group by FORMAT(order_date, 'MMM-dd-yyyy')
order by FORMAT(order_date, 'MMM-dd-yyyy')