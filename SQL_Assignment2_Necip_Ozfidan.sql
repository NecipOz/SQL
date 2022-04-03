--1
SELECT A.primary_poc, B.occurred_at, B.channel, A.name
FROM accounts A, web_events B
WHERE A.id=B.account_id AND
	  A.name LIKE 'Walmart%';
	  

--2
SELECT C.name region_name, B.name sales_rep_name, A.name account_name
FROM accounts A, sales_reps B, region C
WHERE A.sales_rep_id=B.id AND
	  B.region_id=C.id
ORDER BY A.name;



--3
SELECT C.name region_name, A.name account_name, (D.total_amt_usd/(D.total+0.01))
FROM accounts A, sales_reps B, region C, orders D
WHERE A.sales_rep_id=B.id AND
	  B.region_id=C.id AND
	  A.id=D.account_id;

