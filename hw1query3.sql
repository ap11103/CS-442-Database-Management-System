--Query 3: for each customer, find the most favorite and least favorite product
--computes the sum quantities by customer for max and min
with part1 as 
	(select cust, prod, sum(quant) as sum_q
	from sales
	group by cust, prod), 
--computes max as most fav quantities depending on the customer
max_q as 
	(select cust, max(sum_q) as fav
	from part1
	group by cust), 
--computes min as least fav quantities depending on the customer
min_q as 
	(select cust, min(sum_q) as unfav
	from part1
	group by cust),
--joins max quantities and cust
most_f as 
	(select part1.cust, part1.prod
	from part1
	join max_q as max_fav on part1.cust = max_fav.cust
	and part1.sum_q = max_fav.fav), 
--joins least fav and cust	
least_f as 
	(select part1.cust, part1.prod
	from part1
	join min_q as min_unfav on part1.cust = min_unfav.cust
	and part1.sum_q = min_unfav.unfav) 
--puts it all together with customer, most_fav, and least_fav	
select least_fav.cust as CUSTOMER, most_fav.prod as MOST_FAV_PROD, least_fav.prod as LEAST_FAV_PROD
from least_f as least_fav
join most_f as most_fav on least_fav.cust = most_fav.cust;
