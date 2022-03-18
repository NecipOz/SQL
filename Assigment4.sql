---test---
WITH T1 AS(
SELECT B.product_id, A.order_id, A.order_date, B.quantity, B.list_price, B.discount,
	   LEAD(B.quantity) OVER(PARTITION BY B.product_id ORDER BY B.order_id) next_quantity,
	   LEAD(B.discount) OVER(PARTITION BY B.product_id ORDER BY B.order_id) next_discount
FROM sale.orders A, sale.order_item B
WHERE A.order_id=B.order_id
)
SELECT *, next_quantity-quantity, next_discount-discount
FROM T1;

---SOLUTION----
--First partition by product and sum quantities
WITH T2 (product_id, discount, sum_quan) AS(
SELECT distinct B.product_id, B.discount,
	   SUM(B.quantity) OVER(PARTITION BY B.product_id, B.discount) sum_quan
FROM sale.orders A, sale.order_item B
WHERE A.order_id=B.order_id)
,
--Second calculate regression slope formula variables
T3 AS(
SELECT *, COUNT(*) OVER(PARTITION BY product_id) "n", 
		SUM(discount*sum_quan) OVER(PARTITION BY product_id) "sum_xy", 
	    SUM(discount) OVER(PARTITION BY product_id) "sum_x",
		 SUM(sum_quan) OVER(PARTITION BY product_id) "sum_y",
		 SUM(discount*discount) OVER(PARTITION BY product_id) "sum_x_sqr",
		 SUM(sum_quan*sum_quan) OVER(PARTITION BY product_id) "sum_ysqr"
FROM T2)
,
T4 AS(
SELECT *, (n*sum_xy)-(sum_x*sum_y) "num", (n*sum_x_sqr-sum_x*sum_x) "denom", 
		(sum_ysqr-((sum_y*sum_y)/n)) "gnkt"
FROM T3)
,
---Third calculate regression slope (general slope formula not beta) 
---If filter denom to avoid zero divisor error
T5 AS(
SELECT *, num/denom "reg_line"
FROM T4
WHERE denom!=0)
,
T6 AS(
SELECT distinct product_id, CASE   
         WHEN reg_line > 5 THEN 'POSITIVE'  
         WHEN reg_line < -5 THEN 'NEGATIVE'   
         ELSE 'NEUTRAL'  
      END [result]
FROM T5
)
--ISNULL GIVES ERROR WHEN "0 OR 1 ORDER" WRITTEN INSTEAD OF 0. 
--IN THE RESULT COLUMN 0 SHOWS NO ORDER OR ONLY 1 ORDER FROM THIS PRODUCT. 

SELECT A.product_id, B.result, ISNULL(cast(B.result as nvarchar(50)),0) RESULT_
FROM product.product A
LEFT JOIN T6 B
ON A.product_id=B.product_id
ORDER BY A.product_id


