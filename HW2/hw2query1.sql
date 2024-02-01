--Query 1: For each customer, prod, and month, count the number of sales
-- that were between previous and following month's average sales quantities
-- use NULL for january and december 

--Q1: compute avg for cust, prod, and month
WITH Q1 as (
	select cust, prod, month, avg(quant) as AVG_QUANT
	from sales
	group by cust, prod, month),
	
--Q2: using Q1 compute avg (cust, prod, month - 1)
Q2 as (
	select s.cust, s.prod, s.month, s.quant, Q1.AVG_QUANT as FOLLOW_Q
	from sales s
	left join Q1 on s.cust = Q1.cust and s.prod = Q1.prod and s.month = Q1.month-1),
	
--Q3: using Q2 compute avg(cust, prod, month + 1)
Q3 as (
	select Q2.cust, Q2.prod, Q2.month, Q1.AVG_QUANT as PREVIOUS_Q, Q2.QUANT, Q2.FOLLOW_Q
	from Q2
	left join Q1 on Q2.cust = Q1.cust and Q2.prod = Q1.prod and Q2.month = Q1.month+1),

--Q4: Compute count between previous and following avgs
Q4 as (
	select cust, prod, month, count(quant) as COUNT_Q
	from Q3
	where quant between PREVIOUS_Q and FOLLOW_Q or 
		quant between FOLLOW_Q and PREVIOUS_Q
	group by cust, prod, month),

--Q5: base table
Q5 as (
	select cust, prod, month
	from sales s
	group by cust, prod, month)

select Q5.cust as CUSTOMER, Q5.prod as PRODUCT, Q5.month as MONTH, Q4.COUNT_Q AS SALES_COUNT_BETWEEN_AVERAGES
from Q5
left join Q4 ON Q5.cust = Q4.cust and Q5.prod = Q4.prod and Q5.month = Q4.month
order by Q5.cust, Q5.prod, Q5.month
