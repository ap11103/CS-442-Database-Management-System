--Query 5
--For each product, output the max sales quant for each quarter 
--and their corresponding dates
--compute the max sales quant for each product
--compute the date of the max sales
with spring as 
	(select s.prod, max(s.quant) as Q1_MAX
	from sales s
	where s.month = 3 or s.month = 4 or s.month = 5
	group by prod), 
s_date as 
	(select spring.prod, spring.Q1_MAX, date
	from spring
	join sales s on spring.prod = s.prod and spring.Q1_MAX = s.quant
	where s.month = 3 or s.month = 4 or s.month = 5), 

summer as 
	(select s.prod, max(s.quant) as Q2_MAX
	from sales s
	where s.month = 6 or s.month = 7 or s.month = 8
	group by prod), 
sm_date as
	(select summer.prod, summer.Q2_MAX, date
	from summer
	join sales s on summer.prod = s.prod and summer.Q2_MAX = s.quant
	where s.month = 6 or s.month = 7 or s.month = 8),

fall as
	(select s.prod, max(s.quant) as Q3_MAX
	from sales s
	where s.month = 9 or s.month = 10 or s.month = 11
	group by prod),
f_date as
	(select fall.prod, fall.Q3_MAX, date
	from fall
	join sales s on fall.prod = s.prod and fall.Q3_MAX = s.quant
	where s.month = 9 or s.month = 10 or s.month = 11),


winter as
	(select s.prod, max(s.quant) as Q4_MAX
	from sales s
	where s.month = 1 or s.month = 2 or s.month = 12
	group by prod),
w_date as
	(select winter.prod, winter.Q4_MAX, date
	from winter
	join sales s on winter.prod = s.prod and winter.Q4_MAX = s.quant
	where s.month = 1 or s.month = 2 or s.month = 12)
--put the quarter and date together

select distinct s.prod as PRODUCT, s_date.Q1_MAX, s_date.date, sm_date.Q2_MAX, sm_date.date, 
	f_date.Q3_MAX, f_date.date, w_date.Q4_MAX, w_date.date
from sales s
join s_date on s.prod = s_date.prod
join sm_date on s.prod = sm_date.prod
join f_date on s.prod = f_date.prod
join w_date on s.prod = w_date.prod
order by s.prod;
