--Query 2: For each cust, prod, show the avg sales before, during, and after each month
-- for before Jan -> NULL and after Dec -> NULL
-- Year attribute is not considered for this query
--Subquery for Query 1 (first three)

--Q1: compute avg for cust, prod, and month
WITH Q1 as (
	select cust, prod, month, round(avg(quant),0) as AVG_QUANT
	from sales
	group by cust, prod, month),
	
Q2 as (
	select Q1.cust, Q1.prod, Q1.month, Q1.AVG_QUANT, t.AVG_QUANT as FOLLOW_AVG
	from Q1
	left join Q1 as t on Q1.cust = t.cust and Q1.prod = t.prod and Q1.month = t.month+1), 
	
Q3 as (
	select Q1.cust, Q1.prod, Q1.month, Q1.AVG_QUANT, t.AVG_QUANT AS PREVIOUS_AVG
	from Q1
	left join Q1 as t on Q1.cust = t.cust and Q1.prod = t.prod and Q1.month = t.month-1)
	
select Q2.cust as CUSTOMER, Q2.prod as PRODUCT, Q2.month as MONTH, PREVIOUS_AVG as BEFORE_AVG,
	Q2.AVG_QUANT as DURING_AVG, FOLLOW_AVG as AFTER_AVG
from Q2
join Q3 on Q2.cust = Q3.cust and Q2.prod = Q3.prod and Q2.month = Q3.month
order by Q2.cust, Q2.prod, Q2.month

