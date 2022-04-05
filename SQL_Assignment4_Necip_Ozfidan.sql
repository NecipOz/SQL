--1
select round(avg(total),2) Avgtotal
from (	select B.name, sum(total_amt_usd) total
		from orders A, accounts B
		where A.account_id=B.id
		group by B.name
		order by total desc
		limit 10) as top10account;
		
--2
select avg(total_amt_usd)
from orders 
where account_id in (	select account_id
						from orders
						group by account_id
						having avg(total_amt_usd)> (select avg(total_amt_usd)
													from orders) )
