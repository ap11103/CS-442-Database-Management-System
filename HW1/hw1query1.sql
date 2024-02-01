-- HW #1/ Query 1
-- 1. Compute all the aggregate functions for customer (min, max, avg) ==> save the output
-- 2. Find all the details (prod, date, state) associated with min_q
-- by joining the output of step 2 and sales
-- 3. Find all the details (prod, date, state) associated with max_q
-- ==> by joining the output of step 3 and sales
-- 4. Join the results in 1, 2, 3


-- STEP 1:
--saves the output of the query
with part1 as (
	select cust, min(quant) min_q, max(quant) max_q, round(avg(quant), 1) avg_q
	from sales 
	group by cust
), 
--to display the table
--select * from part1
part2 as (
	select part1.cust, part1.min_q, s.prod, s.date, s.state, part1.max_q, part1.avg_q 
	from part1, sales s
	where part1.cust = s.cust and part1.min_q = s.quant
),
-- select * from part2
part3 as (
	select part2.cust, part2.min_q, part2.prod min_prod, part2.date min_date, part2.state min_state, 
	part2.max_q, s.prod max_prod, s.date max_date, s.state max_state, part2.avg_q 
	from part2, sales s
	where part2.cust = s.cust and part2.max_q = s.quant
)
select * from part3
