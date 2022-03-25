CREATE FUNCTION factor(@number INT)
RETURNS INT

AS BEGIN
DECLARE @count INT, @faktoriyel INT
SET @count=1
SET @faktoriyel=1

WHILE (@count<=@number)
BEGIN 
	SET @faktoriyel*=@count
	SET @count+=1
END
RETURN @faktoriyel
END

SELECT dbo.factor(5)