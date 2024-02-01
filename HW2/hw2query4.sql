--Query4: For each customer, find top 3 highest quantities purchased in NJ
--show customer's name, quant, prod purchased and the date of the purchase

--Q1: find the first max quant for customer
--Q1.5: join with the sales table
--Q2: find the second max quant for customer
--Q3: find the third max quant for customer
--and then join the three max quant for customer

WITH Q1 as (
	select s.cust, max(s.quant) max_1
	from sales s
	where s.state = 'NJ'
	group by s.cust), 

Q1_5 as (
	select s.cust, s.quant, s.prod, s.date
	from sales s
	join Q1 on Q1.cust = s.cust and s.quant = Q1.max_1 and s.state = 'NJ'), 

Q2 as (
	select s.cust, max(s.quant) max_2
	from sales s
	join Q1 on Q1.cust = s.cust and s.quant != Q1.max_1 and s.state = 'NJ'
	group by s.cust), 

Q2_5 as (
	select s.cust, s.quant, s.prod, s.date
	from sales s
	join Q2 on s.cust = Q2.cust and s.quant = Q2.max_2 and s.state = 'NJ'),

Q3 as (
	select s.cust, max(s.quant) max_3
	from sales s
	join Q1 on Q1.cust = s.cust and s.quant != Q1.max_1 and s.state = 'NJ'
	join Q2 on Q2.cust = s.cust and s.state = 'NJ' and s.quant != Q2.max_2
	group by s.cust),
	
Q3_5 as (
	select s.cust, s.quant, s.prod, s.date
	from sales s
	join Q3 on s.cust = Q3.cust and s.quant = Q3.max_3 and s.state = 'NJ')
--union all the joins 
select s.cust CUSTOMER, s.quant QUANTITY, s.prod PRODUCT, s.date DATE
from Q1_5 s
union all
select t.cust CUSTOMER, t.quant QUANTITY, t.prod PRODUCT, t.date DATE
from Q2_5 t
union all
select q.cust CUSTOMER, q.quant QUANTITY, q.prod PRODUCT, q.date DATE
from Q3_5 q



	

