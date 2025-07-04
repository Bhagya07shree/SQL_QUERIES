USE SalesDB;


---------- DATETIME FUNCTIONS -----------


SELECT OrderID, CreationTime,
		'2025-08-25' AS HARDCODE,
		GETDATE() TODAY
FROM Sales.Orders;


SELECT OrderID, CreationTime,
	YEAR(CreationTime) AS YEAR
FROM Sales.Orders;

SELECT OrderID, CreationTime,
	MONTH(CreationTime) AS MONTH,
	DAY(CreationTime) AS DAY
FROM Sales.Orders;

------ DATEPART ---------

SELECT OrderID, CreationTime,
	DATEPART(YEAR,CreationTime) AS YEAR_DP,
	DATEPART(MONTH,CreationTime) AS MONTH_DP,
	DATEPART(DAY,CreationTime) AS DAY_DP,
	DATEPART(HOUR,CreationTime) AS HOUR_DP,
	DATEPART(WEEKDAY,CreationTime) AS WEEK_DP,
	DATEPART(QUARTER,CreationTime) AS QUARTER_DP
FROM Sales.Orders;

--------- DATENAME ---------

SELECT OrderID, CreationTime,
	DATENAME(WEEKDAY,CreationTime) AS WEEK_DAY_DN,
	DATENAME(MONTH,CreationTime) AS MONTH_DN,
	DATENAME(QUARTER,CreationTime) AS QUARTER_DN
FROM Sales.Orders;


-------- DATETRUNC -----------

SELECT OrderID, CreationTime,
	DATETRUNC(MINUTE,CreationTime) AS MIN_DT,
	DATETRUNC(HOUR,CreationTime) AS HOUR_DT,
	DATETRUNC(DAY,CreationTime) AS DAY_DT,
	DATETRUNC(MONTH,CreationTime) AS MONTH_DT,
	DATETRUNC(YEAR,CreationTime) AS YEAR_DT
FROM Sales.Orders;


-- AGGREGATION AT MONTHN LEVEL ---

SELECT 
DATETRUNC(MONTH,CreationTime) AS CREATION,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,CreationTime);


-- AGGREGATION AT YEAR LEVEL ---

SELECT 
DATETRUNC(YEAR,CreationTime) AS CREATION,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR,CreationTime);

------- EOMONTH (END OF THE MONTH) -------

SELECT OrderID, CreationTime,
EOMONTH( CreationTime) AS END_OF_MONTH
FROM Sales.Orders;

---- START OF MONTH -----

SELECT OrderID, CreationTime,
DATETRUNC(MONTH,CreationTime) AS START_OF_MONTH,
--- USING CAST ---
CAST(DATETRUNC(MONTH,CreationTime) AS DATE) START_OF_MONTH
FROM Sales.Orders;


-- # HOW MANY ORDERS WERE PLACED IN AN YEAR

SELECT * FROM Sales.Orders

SELECT 
	YEAR(OrderDate) AS YEAR,
	COUNT(*) AS NO_OF_ORDERS
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

---- FORMATING ------

SELECT OrderID,CreationTime,
FORMAT(CreationTime,'dd') dd,
FORMAT(CreationTime,'ddd') ddd,
FORMAT(CreationTime,'dddd') dddd,
FORMAT(CreationTime,'MM') MM,
FORMAT(CreationTime,'MMM') MMM,
FORMAT(CreationTime,'MMMM') MMMM
FROM Sales.Orders;


SELECT OrderID,CreationTime,
FORMAT(CreationTime,'MM-dd-yyyy') USA_FORMAT,
FORMAT(CreationTime,'dd-MM-yyyy') EUROPE_FORMAT
FROM Sales.Orders;

SELECT OrderID,CreationTime,
'Day ' + FORMAT(CreationTime,'ddd MMM') + 
' Q' + DATENAME(quarter,CreationTime) + ' ' +
FORMAT(CreationTime,'yyyy HH:mm:ss tt')AS CUSTOME_FORMAT  --- WHEN USED DATEPART IT GAVE ERROR AS Conversion failed when converting the nvarchar value 'Day Wed Jan Q' to data type int.
FROM Sales.Orders;


SELECT 
FORMAT(OrderDate, 'MMM yy') AS ORDER_DATE,
COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy');

-----  CONVERT() -------

SELECT
CONVERT(INT,'123') AS CONVERT_INT_TO_STRING,
CONVERT(DATE,'2025-08-20') AS CONVERT_STRING_TO_DATE,
CreationTime,
CONVERT(DATE,CreationTime) AS CONVERT_DATETIME_TO_DATE
FROM Sales.Orders;

--------- CAST() --------

SELECT
CAST('123' AS INT) AS [STR_TO_INT],
CAST(123 AS VARCHAR) AS [STR_TO_VARCHAR],
CAST('2025-08-20' AS DATE) AS [STR_TO_DATE],
CAST('2025-08-20' AS DATETIME ) AS [STR_TO_DATETIME],
CreationTime,
CAST(CreationTime AS DATE) AS DATE,
CAST(CreationTime AS TIME) AS TIME
FROM Sales.Orders


-------- DATEADD() ---------

SELECT 
OrderID,OrderDate,
DATEADD(DAY,-10,OrderDate) AS TEN_DAYS_BEFORE,
DATEADD(MONTH,5,OrderDate) AS FIVE_MONTHS_LATER,
DATEADD(YEAR,5,OrderDate) AS FIVE_YEARS_LATER
FROM Sales.Orders


----------------- NULL FUNCTIONS -----------------


-- FIND THE AVERAGE SCORE OF THE CUSTOMERS

SELECT * FROM Sales.Customers

SELECT 
CustomerID,
Score,
AVG(Score) OVER() AVG_SCORE,
COALESCE(Score,0) SCORE1,
AVG(COALESCE(Score,0)) OVER() SCORE2
FROM Sales.Customers


-- DISPLAY THE FULL NAME OF CUSTOMERS IN ASINGLE FIELD BY MERGING 
-- THEIR FIRST AND LAST NAMES, AND ADD 10 BONUS POINTS TO EACH CUSTOMER SCORE

SELECT * FROM Sales.Customers

SELECT CustomerID,
Score,
--COALESCE(LastName,''),
CONCAT(FirstName , ' ' , COALESCE(LastName,'')) AS FULL_NAME,
COALESCE(Score,0) + 10 AS SCORE_WITH_BONUS
FROM Sales.Customers 


-- SORT THE CUSTOMERS FROM LOWEST TO HIGHEST SCORES WITH NULLS APPEARING LAST


---  METHOD 1
SELECT * FROM Sales.Customers

SELECT
CustomerID,
FirstName, 
COALESCE(Score,9999)
FROM Sales.Customers 
ORDER BY COALESCE(Score,9999);

----  METHOD 2

SELECT
CustomerID,
FirstName,
Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END FLAG
FROM Sales.Customers 
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END,SCORE;


SELECT * FROM Sales.Orders 


SELECT 
OrderID,
Quantity,
Sales,
Sales / NULLIF(Quantity,0) Price
FROM Sales.Orders 


-- IDENTIFY THE CUSTOMERS WHO HAVE NO SCORES

SELECT * FROM Sales.Customers

SELECT 
CustomerID,
CONCAT(FirstName, ' ' ,COALESCE(LastName,''))
FROM Sales.Customers
WHERE Score IS NULL;


----- 0r ----
SELECT  * FROM Sales.Customers
WHERE Score IS NULL;


--- list all the details of customers who have not placed any orders

SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders;

SELECT
	C.*,
	O.OrderID,O.ProductID,O.CustomerID
FROM Sales.Customers AS C
LEFT JOIN Sales.Orders AS O
ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;


---------------- CASE STATEMENTS ----------------


-- GENERATE A REPORT SHOWING THE TOTAL SALES FOR EACH CATEGORY:
--> HIGH : IF THE SALES HIGHER THAN 50
--> MEDIUM : IF THE SALES BETWEEN 20 AND 50
--> LOW : IF THE SALES EQUAL OR LOWER THAN 20

-- SORT THE RESULT FROM LOWEST TO HIGHEST

SELECT Category,
SUM(Sales) AS TOTAL_SALES
FROM(
	SELECT
	OrderID,Sales,
	CASE 
		WHEN Sales > 50 THEN 'HIGH'
		WHEN Sales > 20 THEN 'MEDIUM'
		ELSE 'LOW'
	END Category
	FROM Sales.Orders
	)T
GROUP BY Category
ORDER BY SUM(Sales);


-- RETRIEVE EMPLOYEE DETAILS WITH GENDER DISPLAYED AS FULL TEXT

SELECT * FROM Sales.Employees

SELECT 
EmployeeID,
FirstName,LastName,
Department,Gender,
CASE
	WHEN Gender = 'M' THEN 'MALE'
	WHEN Gender = 'F' THEN 'FEMALE'
	ELSE 'NOT AVAILABLE'
END GENDER_FULL_TEXT
FROM Sales.Employees;


-- RETRIEVE CUSTOMER DETAILS WITH ABBREVIATED COUNTRY CODE

SELECT DISTINCT Country
FROM Sales.Customers;

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE 
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'N/A'
	END Country_Abbreviation
FROM Sales.Customers

---- QUICK FORM OF CASE STATEMENTS ------

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'N/A'
	END Country_Abbreviation
FROM Sales.Customers


-- Find the average score of customers and treat null as 0
-- Additionally provide details such as customerID,  first and lastnmae

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Score,
	CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END Clean_Score,
	AVG(
	CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER() Avg_Clean_Score,
	AVG(Score) OVER() AVG_Score
FROM Sales.Customers


-- COUNT HOW MANY TIME EACH CUSTOMER HAS MADE AN ODER WITH SALES GREATER THAN 30

SELECT  * FROM Sales.Orders

SELECT
	CustomerID,
	SUM(CASE 
		WHEN Sales > 30 THEN 1
		ELSE 0
	END )N0_OF_ORDERS_GREATER_30,
	COUNT(*) Total_no_orders_by_each_customer
FROM Sales.Orders
GROUP BY CustomerID


---------------------  AGGREGATE FUNCTIONS  ---------------

-- # FIND TOTAL NO OF ODERS
-- THE TOTAL SALES, AVERAGE SALES FROM ALL ORDERS
-- THE HIGHEST AND LOWEST SALES OF ALL ORDERS

SELECT * FROM Sales.Orders


SELECT
Count(*) AS TOTAL_NO_OF_ORDERS,
SUM(Sales) AS TOTAL_SALES,
AVG(Sales) AS AVG_SALES,
MAX(Sales) AS HIGHEST_SALE,
MIN(Sales) AS LOWEST_SALE
FROM Sales.Orders

-- GROUPING BASED ON CUSTOMER
--- MORE DETAILED

SELECT
CustomerID,
Count(*) AS TOTAL_NO_OF_ORDERS,
SUM(Sales) AS TOTAL_SALES,
AVG(Sales) AS AVG_SALES,
MAX(Sales) AS HIGHEST_SALE,
MIN(Sales) AS LOWEST_SALE
FROM Sales.Orders
GROUP by  CustomerID

-- ANALYZE THE SCORES IN CUSTOMER TABLE

SELECT * FROM Sales.Customers

SELECT
CustomerID,
--SUM(COALESCE(Score, 0)) AS Clean_score,
Count(*) AS TOTAL_NO_OF_ORDERS,
SUM(COALESCE(Score, 0)) AS TOTAL_SALES,
AVG(COALESCE(Score, 0)) AS AVG_SALES,
MAX(COALESCE(Score, 0)) AS HIGHEST_SALE,
MIN(COALESCE(Score, 0)) AS LOWEST_SALE
FROM Sales.Customers
GROUP by CustomerID