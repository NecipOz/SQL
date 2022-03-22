
-- Clear Cust_id, update datatype to int, set it as primary key.

SELECT *
FROM dbo.cust_dimen;

UPDATE dbo.cust_dimen
SET Cust_id=RIGHT(Cust_id,LEN(Cust_id)-5);

ALTER TABLE dbo.cust_dimen
ALTER COLUMN Cust_id INT NOT NULL;

ALTER TABLE dbo.cust_dimen
	ADD CONSTRAINT PK_cust_id PRIMARY KEY CLUSTERED (Cust_id);

-- Clear Ord_id, update datatype to int, set it as primary key.

SELECT *
FROM dbo.orders_dimen;

UPDATE dbo.orders_dimen
SET Ord_id=RIGHT(Ord_id,LEN(Ord_id)-4);

ALTER TABLE dbo.orders_dimen
ALTER COLUMN Ord_id INT NOT NULL;

ALTER TABLE dbo.orders_dimen
	ADD CONSTRAINT PK_ord_id PRIMARY KEY CLUSTERED (Ord_id);


-- Clear Prod_id, update datatype to int, set it as primary key.

SELECT *
FROM dbo.prod_dimen;

UPDATE dbo.prod_dimen
SET Prod_id=RIGHT(Prod_id,LEN(Prod_id)-5);

ALTER TABLE dbo.prod_dimen
ALTER COLUMN Prod_id INT NOT NULL;

ALTER TABLE dbo.prod_dimen
	ADD CONSTRAINT PK_prod_id PRIMARY KEY CLUSTERED (Prod_id);

-- Clear Prod_id, update datatype to int, set it as primary key.

SELECT *
FROM dbo.shipping_dimen;

UPDATE dbo.shipping_dimen
SET Ship_id=RIGHT(Ship_id,LEN(Ship_id)-4);

ALTER TABLE dbo.shipping_dimen
ALTER COLUMN Ship_id INT NOT NULL;

ALTER TABLE dbo.shipping_dimen
	ADD CONSTRAINT PK_ship_id PRIMARY KEY CLUSTERED (Ship_id);


-- Clear Prod_id, Ship_id, Ord_id and Prod_id in market_fact table and update datatype to int, set it as foreign key.

SELECT *
FROM [dbo].[market_fact];

UPDATE dbo.market_fact
SET Cust_id=RIGHT(Cust_id,LEN(Cust_id)-5);

ALTER TABLE dbo.market_fact
ALTER COLUMN Cust_id INT NOT NULL;

UPDATE dbo.market_fact
SET Ord_id=RIGHT(Ord_id,LEN(Ord_id)-4);

ALTER TABLE dbo.market_fact
ALTER COLUMN Ord_id INT NOT NULL;

UPDATE dbo.market_fact
SET Prod_id=RIGHT(Prod_id,LEN(Prod_id)-5);

ALTER TABLE dbo.market_fact
ALTER COLUMN Prod_id INT NOT NULL;

UPDATE dbo.market_fact
SET Ship_id=RIGHT(Ship_id,LEN(Ship_id)-4);

ALTER TABLE dbo.market_fact
ALTER COLUMN Ship_id INT NOT NULL;

ALTER TABLE dbo.market_fact
ADD FOREIGN KEY (Ord_id) REFERENCES dbo.orders_dimen(Ord_id);

ALTER TABLE dbo.market_fact
ADD FOREIGN KEY (Cust_id) REFERENCES dbo.cust_dimen(Cust_id);

ALTER TABLE dbo.market_fact
ADD FOREIGN KEY (Prod_id) REFERENCES dbo.prod_dimen(Prod_id);

ALTER TABLE dbo.market_fact
ADD FOREIGN KEY (Ship_id) REFERENCES dbo.shipping_dimen(Ship_id);


-- set a new column as primary key of market_fact

ALTER TABLE dbo.market_fact
ADD market_fact_id int IDENTITY (1,1) NOT NULL;

ALTER TABLE dbo.market_fact
	ADD CONSTRAINT PK_market_fact_id PRIMARY KEY CLUSTERED (market_fact_id);


--DAwSQL Session -8 

--E-Commerce Project Solution


/*****************************************************************************
1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)
*****************************************************************************/

SELECT A.*, B.*, C.*, D.*,E.Discount, E.Order_Quantity, E.Product_Base_Margin, E.Sales, E.market_fact_id
INTO combined_table
FROM dbo.cust_dimen A, dbo.orders_dimen B, dbo.prod_dimen C,
	 dbo.shipping_dimen D, dbo.market_fact E
WHERE A.Cust_id=E.Cust_id AND
	  B.Ord_id=E.Ord_id AND
	  C.Prod_id=E.Ord_id AND
	  D.Ship_id=E.Ship_id;

/***************************************************************
2. Find the top 3 customers who have the maximum count of orders.
****************************************************************/

SELECT TOP 3 A.Cust_id, A.Customer_Name, COUNT(DISTINCT B.Ord_id) count_of_order
FROM dbo.cust_dimen A, dbo.orders_dimen B, dbo.market_fact C
WHERE A.Cust_id=C.Cust_id AND
	  B.Ord_id=C.Ord_id
GROUP BY A.Cust_id, A.Customer_Name
ORDER BY count_of_order DESC


/*****************************************************************************
3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
Use "ALTER TABLE", "UPDATE" etc.
*****************************************************************************/

ALTER TABLE dbo.combined_table
ADD DaysTakenForDelivery INT NULL;

SELECT *
FROM dbo.combined_table

UPDATE dbo.combined_table 
SET DaysTakenForDelivery=A.date_diff
FROM (SELECT market_fact_id, DATEDIFF(day,order_date,Ship_Date) date_diff
	  FROM dbo.combined_table) AS A
WHERE combined_table.market_fact_id=A.market_fact_id


/*****************************************************************************
4. Find the customer whose order took the maximum time to get delivered.
Use "MAX" or "TOP"
*****************************************************************************/

WITH T1 AS(
SELECT TOP 1 A.Order_Date, A.Ord_id, B.Ship_id,C.Cust_id, B.Ship_Date,C.market_fact_id, DATEDIFF(day,order_date,Ship_Date) date_diff
FROM dbo.orders_dimen A, dbo.shipping_dimen B, dbo.market_fact C
WHERE A.Ord_id=C.Ord_id AND
	  B.Ship_id=C.Ship_id
ORDER BY date_diff DESC
)
SELECT A.Cust_id, A.Customer_Name
FROM dbo.cust_dimen A, dbo.market_fact B, T1
WHERE A.Cust_id=B.Cust_id  AND
	  B.market_fact_id=T1.market_fact_id;


/*****************************************************************************
5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
You can use date functions and subqueries
*****************************************************************************/

--the total number of unique customers in January = 412
SELECT COUNT(DISTINCT A.Cust_id)
FROM dbo.cust_dimen A, dbo.market_fact B, dbo.orders_dimen C
WHERE A.Cust_id=B.Cust_id  AND
	  B.Ord_id=C.Ord_id AND
	  MONTH(Order_Date)=1

--First we get all orders of 412 customers where we found in the previous query by subquery method.
--Second we filter their orders in 2011.
--Third we get their unique order dates months.
--We create T2 table by "with". Then we count each customers month_2011. 
--If this count equal to 12 then this customer had orders every month of 2011.

WITH T2 AS(
SELECT DISTINCT A.Cust_id, MONTH(C.Order_Date) month_2011
FROM dbo.cust_dimen A, dbo.market_fact B, dbo.orders_dimen C
WHERE A.Cust_id=B.Cust_id  AND
	  B.Ord_id=C.Ord_id AND
	  A.Cust_id IN (SELECT DISTINCT A.Cust_id
					FROM dbo.cust_dimen A, dbo.market_fact B, dbo.orders_dimen C
					WHERE A.Cust_id=B.Cust_id  AND
						  B.Ord_id=C.Ord_id AND
						  MONTH(Order_Date)=1) 
	  AND YEAR(Order_Date)=2011
)

SELECT Cust_id, COUNT(month_2011) count_month
FROM T2
GROUP BY Cust_id
ORDER BY count_month DESC

--Since there is no customer whose count_month=12, no customer order every month of 2011.

/*****************************************************************************
6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
in ascending order by Customer ID
Use "MIN" with Window Functions
******************************************************************************/

--Join 3 lists and group by this list by cust_id and ord_id. So we obtain a list with unique ord_id.
WITH T3 AS(
SELECT A.Cust_id, A.Customer_Name, B.Ord_id, B.order_date
FROM dbo.cust_dimen A, dbo.orders_dimen B, dbo.market_fact C
WHERE A.Cust_id=C.Cust_id AND
	  B.Ord_id=C.Ord_id
GROUP BY A.Cust_id, A.Customer_Name, B.Ord_id, B.order_date
),
--By lead function get the third order date and give row number to the orders for each customer
T4 AS(
SELECT Cust_id, Customer_Name, order_date,Ord_id,
	   LEAD(order_date,2) OVER(PARTITION BY Cust_id ORDER BY order_date) third_order,
	   ROW_NUMBER() OVER(PARTITION BY Cust_id ORDER BY order_date) row_num
FROM T3)
--Find the difference between first and third order and 
--filter customers who had third and more orders. 
SELECT Cust_id, Customer_Name, order_date, Ord_id, third_order, 
	   DATEDIFF(day, order_date, third_order) diff_first_third
FROM T4
WHERE third_order IS NOT NULL AND
      row_num=1;

/*****************************************************************************
7. Write a query that returns customers who purchased both product 11 and product 14, 
as well as the ratio of these products to the total number of products purchased by all customers.
Use CASE Expression, CTE, CAST and/or Aggregate Functions
*****************************************************************************/

CREATE VIEW T5 AS
SELECT Cust_id, COUNT(distinct Prod_id) two_prod, 
       SUM(CASE WHEN Prod_id=11 THEN 1.0  WHEN Prod_id=14 THEN 1.0  ELSE 0 END)/
				(SELECT COUNT(Prod_id) FROM market_fact) ratio
FROM dbo.market_fact
WHERE Prod_id=11 OR Prod_id=14
GROUP BY Cust_id;

SELECT A.Cust_id, Customer_Name, ratio
FROM cust_dimen A, T5
WHERE  A.Cust_id=T5.Cust_id AND
       T5.two_prod=2;





/*****************************
** CUSTOMER SEGMENTATION  **
*****************************/


/*****************************************************************************
1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
Use such date functions. Don't forget to call up columns you might need later.
*****************************************************************************/
CREATE VIEW monthly_basis AS
SELECT DISTINCT A.Cust_id, YEAR(order_date) order_year, MONTH(order_date) order_month, 
	   COUNT(MONTH(order_date)) OVER(PARTITION BY A.Cust_id, YEAR(order_date)) num_of_order_yearly,
	   COUNT(MONTH(order_date)) OVER(PARTITION BY A.Cust_id, YEAR(order_date),MONTH(order_date)) num_of_order_monthly
FROM dbo.market_fact A, dbo.orders_dimen B
WHERE A.Ord_id=B.Ord_id




  --2.Create a �view� that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

CREATE VIEW monthly_number AS
SELECT DISTINCT A.Cust_id, YEAR(order_date) order_year, MONTH(order_date) order_month, 
	   COUNT(MONTH(order_date)) OVER(PARTITION BY A.Cust_id, YEAR(order_date),MONTH(order_date)) num_of_order_monthly
FROM dbo.market_fact A, dbo.orders_dimen B
WHERE A.Ord_id=B.Ord_id



--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

CREATE VIEW next_order AS
SELECT *, DENSE_RANK() OVER(PARTITION BY Cust_id ORDER BY order_year, order_month) D_Rank,
	      LEAD(order_year) OVER(PARTITION BY Cust_id ORDER BY order_year, order_month) Next_Year,
		  LEAD(order_month) OVER(PARTITION BY Cust_id ORDER BY order_year, order_month) Next_Month
FROM monthly_number


--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

CREATE VIEW gap_month AS
SELECT *,(CASE WHEN Next_Month IS NULL THEN 0
			   WHEN Next_Month=order_year THEN Next_Month-order_month
			   ELSE (Next_Year-order_year)*12+Next_Month-order_month
		       END) AS GAP
FROM next_order


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as �churn� if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as �regular� if the customer has made a purchase every month.
--Etc.

CREATE VIEW a_gap AS
SELECT Cust_id, AVG(GAP) Avg_Gap
FROM gap_month
GROUP BY Cust_id

SELECT *, CASE WHEN Avg_Gap=0 OR Avg_Gap>4 THEN 'Churn'
            ELSE 'Regular' END AS Cust_freq
FROM a_gap




--MONTH-WISE RETENT�ON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

SELECT COUNT(*)
FROM a_gap
WHERE Avg_Gap=1


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.


--Number of customers in each month
CREATE VIEW total_cust_month AS
SELECT YEAR(order_date) order_year, MONTH(order_date) order_month, COUNT(DISTINCT Cust_id) Total_Cust
FROM dbo.market_fact A, dbo.orders_dimen B
WHERE A.Ord_id=B.Ord_id
GROUP BY YEAR(order_date),MONTH(order_date) 

--Number of Customers Retained in The next Month
CREATE VIEW total_cust_retained AS
SELECT order_year, order_month, COUNT(DISTINCT Cust_id) Cust_Ret_Current_Month
FROM gap_month
WHERE GAP=1
GROUP BY order_year, order_month 

--Number of Customers Retained in The next Month/Total Number of Customers in the Current Month
SELECT A.order_year, A.order_month, 
	   A.Total_Cust, B.Cust_Ret_Current_Month,
	   CAST((B.Cust_Ret_Current_Month*1.0/A.Total_Cust) AS DECIMAL (5,3)) ret_rate
FROM total_cust_month A
LEFT JOIN total_cust_retained B
ON A.order_month=B.order_month AND
   A.order_year=B.order_year
ORDER BY A.order_year, A.order_month



---///////////////////////////////////
--Good luck!