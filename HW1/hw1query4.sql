--Query 4: For each customer and product combination, show the average sales quantities for the four seasons
--count the average for 4 seasons
--count the average and count for the whole year
--include customer and product
--compute the avg for spring
with sp_avg as 
	(select s.cust, s.prod, round(avg(s.quant),0) as spring_avg
	from sales s
	where s.month = 3 or s.month = 4 or s.month = 5
	group by cust, prod
	),
--compute the avg for summer
sm_avg as 
	(select s.cust, s.prod, round(avg(s.quant),0) as summer_avg
	from sales s
	where s.month = 6 or s.month = 7 or s.month = 8
	group by cust, prod
	),
--compute the avg for fall
f_avg as 
	(select s.cust, s.prod, round(avg(s.quant),0) as fall_avg
	from sales s
	where s.month = 9 or s.month = 10 or s.month = 11
	group by cust, prod
	),
--compute the avg for winter
w_avg as 
	(select s.cust, s.prod, round(avg(s.quant),0) as winter_avg
	from sales s
	where s.month = 1 or s.month = 2 or s.month = 12
	group by cust, prod
	),
--compute the year avg, sum, and quant
y_avg as 
	(select s.cust, s.prod, round(avg(s.quant),0) as year_avg, sum(s.quant) as year_total, 
	 count(s.quant) as year_count
	from sales s
	group by cust, prod)
--join the year, and quaterly info together
select y_avg.cust as CUSTOMER, y_avg.prod as PRODUCT, sp_avg.spring_avg as SPRING_AVG, sm_avg.summer_avg as SUMMER_AVG, 
		f_avg.fall_avg as FALL_AVG, w_avg.winter_avg as WINTER_AVG, y_avg.year_avg as AVERAGE, 
		y_avg.year_total as TOTAL, y_avg.year_count as COUNT
from y_avg join sp_avg on sp_avg.cust = y_avg.cust and sp_avg.prod = y_avg.prod
join sm_avg on sm_avg.cust = y_avg.cust and sm_avg.prod = y_avg.prod
join f_avg on f_avg.cust = y_avg.cust and f_avg.prod = y_avg.prod
join w_avg on w_avg.cust = y_avg.cust and w_avg.prod = y_avg.prod
order by y_avg.cust, y_avg.prod
