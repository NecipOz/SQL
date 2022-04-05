
/* Use parch and posey ERD to solve below questions */
/* GROUP BY QUIZ
1- Which account (by name) placed the earliest order? 
Your solution should have the account name and the 
date of the order. */


select A.name, B.occurred_at
from accounts A, orders B
where A.id=B.account_id
order by occurred_at
limit 1;

/*
2-Find the total sales in usd for each account. You 
should include two columns - the total sales for each 
company's orders in usd and the company name. */

select A.name, SUM(total_amt_usd) total
from accounts A, orders B
where A.id=B.account_id
group by A.name
order by total desc, A.name;



/*
3- Via what channel did the most recent (latest) 
web_event occur, which account was associated with 
this web_event? Your query should return only three 
values - the date, channel, and account name. */

select A.occurred_at, A.channel, B.name
from web_events A, accounts B
where A.account_id=B.id
order by A.occurred_at desc
limit 1;

/*
4- Find the total number of times each type of channel
from the web_events was used. Your final table should 
have two columns - the channel and the number of times 
the channel was used. */

select channel, count(channel) Num_of_Channel_Used
from web_events
group by channel
order by Num_of_Channel_Used desc;

/*
5- Who was the primary contact associated with the 
earliest web_event? */

select primary_poc
from accounts A, web_events B
where A.id=B.account_id
order by occurred_at
limit 1;


/*
6- What was the smallest order placed by each account 
in terms of total usd. Provide only two columns 
- the account name and the total usd. Order from 
smallest dollar amounts to largest. */

select A.name, min(total_amt_usd) smallest_order
from accounts A, orders B
where A.id=B.account_id
group by A.name
order by A.name;

/*
7- Find the number of sales reps in each region. 
Your final table should have two columns - the region 
and the number of sales_reps. Order from fewest reps 
to most reps. */

select B.name as Region, count(A.id) num_of_sales_rep
from sales_reps A, region B
where A.region_id=B.id
group by B.name
order by num_of_sales_rep;
