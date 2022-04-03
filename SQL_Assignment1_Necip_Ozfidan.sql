
/*
QUERY 1
Write a query to return the 10 customer_id with the most amount from the payment table. Include the customer_id, payment_id and amount in your query.
You can type your code after the asterisk-slash below
*/
select customer_id, payment_id, amount
from payment
order by amount desc
limit 10;

/*
QUERY 2
Write a query to return the 10 customer_id with the lowest amount from the same table. Again, include the customer_id, payment_id and amount in your query.
*/
select customer_id, payment_id, amount
from payment
order by amount, customer_id
limit 10;


/*
QUERY 3
Write a query to display the number of different language names from the language table.
*/
select count(distinct name) lang_num
from language;


/* 
QUERY 4
How many staff members are there in staff table?*/

select count(distinct staff_id) num_of_staff
from staff;



/*
QUERY 5
Write a query that will display te address with the smallest city_id in the address table 
*/
select address, city_id
from address
order by city_id
limit 1;
 



/* 
QUERY 6
Write a query of your own.
*/
select A.customer_id, A.first_name, A.last_name, B.max_return_day
from customer A
inner join (
			select customer_id, max(return_date - rental_date) as max_return_day
			from rental
			group by customer_id
			order by max_return_day desc
			limit 10) B
on A.customer_id = B.customer_id;

