--Query 3: For each cust, prod, state combination
--Q1: compute average sale for this cust for state
--Q2: average sale of the product and state but for other custs
--Q3: average sale of the customer for the given state for other prods
--Q4: customer's avg for the given product, but for other states

--customer/prod avg
WITH Q1 as (
	select cust, prod, state, avg(quant) as AVG_Q1
	from sales
	group by cust, prod, state), 
--other customer avg
Q2 as (
	select s.cust, s.prod, s.state, avg(t.quant) as AVG_Q2
	from sales s 
	left join sales t on s.cust != t.cust and s.prod = t.prod and s.state = t.state
	group by s.cust, s.prod, s.state), 
--other product average
Q3 as (
	select s.cust, s.prod, s.state, avg(t.quant) as AVG_Q3
	from sales s
	left join sales t on s.cust = t.cust and s.prod != t.prod and s.state = t.state
	group by s.cust, s.prod, s.state), 
--other state avg
Q4 as (
	select s.cust, s.prod, s.state, avg(t.quant) as AVG_Q4
	from sales s
	left join sales t on s.cust = t.cust and s.prod = t.prod and s.state != t.state
	group by s.cust, s.prod, s.state)

select Q1.cust CUSTOMER, Q1.prod PRODUCT, Q1.state STATE, round(Q1.AVG_Q1, 0) PROD_AVG, 
		round(Q2.AVG_Q2, 0) OTHER_CUST_AVG, round(Q3.AVG_Q3, 0) OTHER_PROD_AVG, round(Q4.AVG_Q4, 0) as OTHER_STATE_AVG
from Q1
left join Q2 on Q1.cust = Q2.cust and Q1.prod = Q2.prod and Q1.state = Q2.state
left join Q3 on Q1.cust = Q3.cust and Q1.prod = Q3.prod and Q1.state = Q3.state
left join Q4 on Q1.cust = Q4.cust and Q1.prod = Q4.prod and Q1.state = Q4.state
order by customer, product, state
	
	
	
	
	
	
	
