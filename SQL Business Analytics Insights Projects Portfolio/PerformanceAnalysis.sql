-- Performance Analysis -- 
-- Helps measure success and compare performance

/*Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales.*/
with yearly_product_sales as
	(
	select 
		year(f.order_date) as order_year,
		p.product_name,
		sum(f.sales_amount) as current_sales
		from fact_sales f 
			left join dim_products p
			on f.product_key = p.product_key
	where order_date is not null
	group by
		year(f.order_date),
	p.product_name
	)
select
	order_year,
	product_name,
	current_sales,
	avg(current_sales) over (partition by product_name) as avg_sales,
	current_sales - avg(current_sales) over (partition by product_name) as difference_in_average,
case when current_sales- avg(current_sales) over (partition by product_name) > 0 then 'Above Average'
	 when current_sales- avg(current_sales) over (partition by product_name) < 0 then 'Below Average'
	 else 'Average'
end average_change,
-- Year over year analysis
	lag(current_sales) over (partition by product_name order by order_year) as previous_sales,
	current_sales - lag(current_sales) over (partition by product_name order by order_year) as difference_previous_year,
case when current_sales- lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increasing'
	 when current_sales- lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decreasing'
	 else 'No Change'
end previous_year_change
from yearly_product_sales
order by product_name, order_year