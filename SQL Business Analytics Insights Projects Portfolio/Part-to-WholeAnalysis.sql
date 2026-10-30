-- Part-to-Whole Analysis -- 
-- Analyze how an individual part is performing compared to the overall to understand which category has the highest impact on the business

-- Which categories contribute the most to overall sales?
with category_sales as (
	select
		category,
		sum(sales_amount) total_sales
	from fact_sales f
	left join dim_products p 
	on p.product_key = f.product_key
	group by category
						)
select
	category,
	total_sales,
	sum(total_sales) over () overall_sales,
	concat(round((cast (total_sales as float) / sum(total_sales) over ())*100, 2), '%') as percentage_of_total
from category_sales
order by total_sales desc