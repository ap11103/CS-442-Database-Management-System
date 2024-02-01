--Query2: For each year and month, find the busiest day and slowest day
--and their corresponding quantities

--computes the sum of quant as a base to compute max and min q
with part1 as
	(select year, month, day, sum(quant)as sum_q
	 from sales
	 group by year, month, day
	 order by year, month),
--from part1, it computes the min q for year and month	 
slow_q as
	(select year, month, min(sum_q) as min_q
	 from part1
	 group by year, month
	 order by year, month),
--from part1 and slow_q; uses join to find the slowest day based on year and month	 
slow_day as
	(select part1.year, part1.month, part1.day, slow.min_q
	from part1
	join slow_q as slow on part1.year = slow.year and part1.month = slow.month and part1.sum_q = slow.min_q),
--from part1, it computes the max q for year and month
busy_q as
	(select year, month, max(sum_q) as max_q
	 from part1
	 group by year, month
	 order by year, month),
--from previous part and part1, find the busiest day based on year and month
busy_day as
	(select part1.year, part1.month, part1.day, busy.max_q
	from part1
	join busy_q as busy on part1.year = busy.year and part1.month = busy.month and part1.sum_q = busy.max_q)

--puts all the output of the previous subqueries together using join based in year and month
select b_final.year, b_final.month, b_final.day as BUSIEST_DAY, b_final.max_q as BUSIEST_TOTAL_Q, 
		s_final.day as SLOWEST_DAY, s_final.min_q as SLOWEST_TOTAL_Q
from busy_day as b_final
join slow_day as s_final on b_final.year = s_final.year
and b_final.month = s_final.month;


