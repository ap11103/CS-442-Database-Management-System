--Query 5: for each product, find the median sales quantity 
--assume an odd number of sales
--base table for distinct prod, quant
--join base and sales for relative pos
--compute median from count of sales
--for quant values > med
--compute the med_pos
--median quant is min() --> output pos.prod and pos.quant

WITH base as (
	select distinct s.prod, s.quant
	from sales s
	group by s.prod, s.quant
	order by s.prod, s.quant), 
	
pos as (
	select base.prod, base.quant, count(s.quant) rel_pos
	from base, sales s
	where s.prod = base.prod and s.quant <= base.quant
	group by base.prod, base.quant),

med as (
	select s.prod, ceiling(count(quant)/2) med_cnt
	from sales s
	group by s.prod), 

other_max as (
	select pos.prod, pos.quant, pos.rel_pos, med.med_cnt
	from pos natural join med
	where pos.rel_pos >= med.med_cnt),
	
med_pos as (
	select prod, min(rel_pos) pos
	from other_max
	group by other_max.prod)

select p.prod PRODUCT, p.quant MEDIAN_QUANT
from pos p
join med_pos m on m.prod = p.prod and m.pos = p.rel_pos
order by p.prod
