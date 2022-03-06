CREATE VIEW Customer_Product2
AS
SELECT	distinct D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT *
FROM dbo.Customer_Product2

CREATE VIEW First_Product
AS
SELECT	distinct D.customer_id, D.first_name, D.last_name, A.product_id
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black'

CREATE VIEW Second_Product
AS
SELECT	distinct D.customer_id, D.first_name, D.last_name, A.product_id AS 'Second_product'
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'

CREATE VIEW Third_Product
AS
SELECT	distinct D.customer_id, D.first_name, D.last_name, A.product_id AS 'Third_product'
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'

SELECT A.customer_id, A.first_name, A.last_name, 
		ISNULL(REPLACE(product_id,'13','Yes'),'No') AS 'First_product',
		ISNULL(REPLACE(Second_Product,'21','Yes'),'No') 'Second_product',
		ISNULL(REPLACE(Third_Product,'16','Yes'),'No') 'Third_product'
FROM dbo.Customer_Product2 A
LEFT JOIN dbo.First_Product B ON A.customer_id = B.customer_id
LEFT JOIN dbo.Second_Product C ON A.customer_id = C.customer_id
LEFT JOIN dbo.Third_Product D ON A.customer_id = D.customer_id