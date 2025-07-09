------------- WINDOWS FUNCTIONS --------------

USE SalesDB;

--  FIND THE TOTAL SALES ACROSS ALL ORDERS

SELECT * FROM Sales.Orders

SELECT 
	SUM(Sales) Total_Sales
FROM Sales.Orders

--  FIND THE TOTAL SALES FOR EACH PRODUCT

SELECT * FROM Sales.Orders

SELECT 
	ProductID,
	SUM(Sales) Total_Sales
FROM Sales.Orders
GROUP BY ProductID


--	FIND THE TOTAL SALES FOR EACH PRODUCT
--  ADDITIONALLY PROVIDE DETAILS SUCN ORDET ID, ORDER DATE

SELECT * FROM Sales.Orders

----- ERROR -----
SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) AS Total_Sales
FROM Sales.Orders
GROUP BY ProductID

--------  USING WINDOWS FUNCTION OVER() --------

----  OVER() ----
SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER() Total_Sales
FROM Sales.Orders

---- PARTITION BY---
SELECT
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID )  Total_Sales
FROM Sales.Orders

---- GRANUALARITY / LVEL OF DEDTAILS IN WINDOWS FUNCCTION

--  FIND THE TOTAL SALES ACROSS ALL ORDERS
--	FIND THE TOTAL SALES FOR EACH PRODUCT
--  ADDITIONALLY PROVIDE DETAILS SUCN ORDET ID, ORDER DATE

SELECT
	ProductID,
	OrderID,
	OrderDate,
	Sales,
	SUM(Sales) OVER()  Total_Sales_For_All_Product,
	SUM(Sales) OVER(PARTITION BY ProductID)  Total_Sales_For_Each_Product,
	SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) SalesByProductAndStatus
FROM Sales.Orders


-- RANK EACH ORDER BASED ON THEIR SALES FROM HIGHEST TO LOWEST
-- ADDITIONALLY PROVIDE DETAILS SUCH ODERID, ORDER DATE

SELECT * FROM Sales.Orders

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	RANK () OVER(ORDER BY Sales DESC) AS Sales_Rank
	FROM Sales.Orders;

----------------  FRAME CLAUSE ------------------

SELECT * FROM Sales.Orders

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) total_sales
	FROM Sales.Orders;

------- SHORT CUT : FOR ONLY PRECEEDING ------
-- UNBOUNDED PRECEEDING -> IT WILL WORK
-- UNBOUNDED FOLLOWING -> ERROR

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS 2 PRECEDING) total_sales
	FROM Sales.Orders;

-- DEFALUT FRAME 
-- NOTE : ORDER BY ALWAYS USES A FRAME

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate) total_sales
	FROM Sales.Orders;

-----------  OR  -----------

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total_sales
	FROM Sales.Orders;

--------------  0R  ------------

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS UNBOUNDED PRECEDING) total_sales
	FROM Sales.Orders;  


 -- FIND THE TOTAL SALES FOR EACH ORDER STATUS, ONLY  FOR TWO PRODUCTS 101 & 102

 SELECT * FROM Sales.Orders

 SELECT 
	OrderID,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER (Partition BY OrderStatus) AS TOTAL_SALES
	FROM Sales.Orders
	WHERE ProductID IN(101,102);

	-- RANK THE CUSTOMERS BASE ON THEIR ON TOTAL SALES

	SELECT 
		CustomerID,
		Sum(Sales) AS Total_sales,
		RANK() OVER(ORDER BY Sum(Sales) DESC) RANKING
	FROM Sales.Orders
	GROUP BY CustomerID

-----------------------  AGGREGATE WINDOW FUNCTION  ---------------------

---- 1.COUNT()

-- FIND THE TOTAL NO.OF ORDERS

SELECT COUNT(*) Total_orders
FROM Sales.Orders

-- FIND THE TOTAL NO.OF ORDERS FOR EACH CUSTOMERS
-- ADDITIONALLY PROVIDE DETAILS SUCH ORDERID,ORDER DATE

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() Total_orders,
	COUNT(*) OVER(PARTITION BY CustomerID) TOtal_NO_of_Customers
	FROM Sales.Orders

-- FIND THE TOTAL NO.OF CUSTOMERS , ADDITIONALLY PROVIDE ALL CUSTOMERS DETAILS
-- FIND THE TOTAL NUMBER OF SCORES FOR THE CUSTTOMERS

SELECT *,
COUNT(CustomerID) OVER() NO_OF_CUSTOMERS,
COUNT(Score) OVER() TOTALNO_OF_Scores 
FROM Sales.Customers

-- CHECK WHETHER THE TABLE 'ORDERS' CONTAIN ANY DUPLICATE ROWS

SELECT* FROM Sales.Orders

SELECT OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CHECK_PK
FROM Sales.Orders

-- CHECK WHETHER THE TABLE 'ORDERS.ARCHIVE' CONTAIN ANY DUPLICATE ROWS

SELECT* FROM Sales.Orders

SELECT * FROM(
		SELECT OrderID,
			COUNT(*) OVER(PARTITION BY OrderID) CHECK_PK
		FROM Sales.OrdersArchive
		)T WHERE CHECK_PK > 1


------- 2.SUM() -------

-- FIND THE TOTAL SALES ACROSS ALL ORDERS
-- AND THE TOTAL SALES FOR EACH PRODUCTS
-- ADDITIONALY PROVIDE DETAILS SUCH AS ORDERID,ORDER DATE

SELECT * FROM Sales.Orders

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) SalesFOrProduct
	FROM Sales.Orders

-- COMPARISION USECASE : COMPARES THE CURRENT VALUE AND AGGREGATED VALUE OF WINDOW FUNCTIONS

-- FIND THE PERCENTAGE CONTRIBUTION OF EACH PRODUCTS SALES TO THE TOTAL SALES

SELECT
	OrderID,ProductId,
	Sales,
	SUM(Sales) OVER() TotalSales,
	ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100,2) PErcentage_of_sales
	FROM Sales.Orders

------------- AVG() ---------------

-- FIND THE AVG SALES ACROSS ALL ORDERS
-- AND THE AVG SALES FOR EACH PRODUCTS
-- ADDITIONALY PROVIDE DETAILS SUCH AS ORDERID,ORDER DATE

SELECT 
	OrderID,OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() avg_sales,
	AVG(Sales) OVER(PARTITION BY ProductID) avg_sale_of_product
	FROM Sales.Orders


-- FIND THE AVERAGE SCORES OF CUSTOMERS
-- ADDITIONALLY PROVIDE DETAILS SUCH AS CUSTOMERID, LASTNAME

SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score,0) score_without_null,
	AVG(Score) OVER() avg_customer_score,
	AVG(COALESCE(Score,0)) OVER() avg_score_without_null
FROM Sales.Customers

-- FIND ALL ORDERS WHERE SALES ARE HIGHER THAN THE THE AVERAGE ACROSS ALL ORDERS

--- NOTE: WINDOW FUNCTIONS CAN'T BE USED IN THE WHERE CLAUSE

SELECT * FROM Sales.Orders

SELECT 
* 
FROM(
	SELECT 
		OrderID,
		Sales,
		AVG(Sales) OVER() avg_sales
	FROM Sales.Orders
)t WHERE Sales > avg_sales


------------ MIN(), MAX() ---------

-- FIND THE HIGHEST AND LOWEST SALES OF ALL ORDERS
-- FIND THE HIGHEST AND LOWEST SALES FOR EACH PRODUCT
-- ADDITIONALLY PROVIDE DETAILS SUCH ORDERID,ORDER DATE

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(Sales) OVER() min_sales,
	MAX(Sales) OVER() max_sales,
	MIN(Sales) OVER(PARTITION BY ProductID) min_sales_for_each_product,
	MAX(Sales) OVER(PARTITION BY ProductID) max_sales_for_each_product
FROM Sales.Orders


-- SHOW THE EMPLOYEES WHO HAVE HIGHEST SALARAIES

SELECT * FROM (
	SELECT *,
	MAX(Salary) OVER() Highest_salary
	FROM Sales.Employees
	)t 
	WHERE Salary = Highest_Salary

-- 	FIND DEVIATION FOR EACH SALES FROM THE MIN AND MAX SALES AMOUNT

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(Sales) OVER() minb_sales,
	MAX(Sales) OVER() max_sales,
	Sales - MIN(Sales) OVER() DeviationFromMin ,
	MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders


-------------------- RUNNING TOTAL AND ROLLING TOTAL ----------------

-- CALULATE THE MOVING AVERAGE OF SALES FOR EACH PRODUCT OVERTIME

---- OVERTIME Means: SORTING THE ORDERDATE in ASC ORDER [RUNNING TOTAL]
SELECT * FROM Sales.Orders

SELECT 
	OrderID,
	Orderdate,
	ProductID,
	Sales,
	AVG(Sales) OVER(Partition by ProductID)avg_sales,
	AVG(Sales) OVER(Partition by ProductID ORDER BY OrderDate) moving_avg_sales
	FROM Sales.Orders

-- CALULATE THE MOVING AVERAGE OF SALES FOR EACH PRODUCT OVERTIME,
-- INCLUDING ONLY THE NEXT ORDER [ ROLLING TOTAL]

SELECT 
	OrderID,
	Orderdate,
	ProductID,
	Sales,
	AVG(Sales) OVER(Partition by ProductID)avg_sales,
	AVG(Sales) OVER(Partition by ProductID ORDER BY OrderDate) moving_avg_sales,
	AVG(Sales) OVER(Partition by ProductID ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) ROLLing_avg_sales
	FROM Sales.Orders


--------------------- WINDOW RANKING FUNCTIONS ----------------------

-------------  1. ROW NUMBER()  ------------

-- RANK THE ORDERS BASED ON THEIR SALES FROM HIGHEST TO LOWEST

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) as rank_of_orders
FROM Sales.Orders


-------------  2. RANK()  ------------

-- RANK THE ORDERS BASED ON THEIR SALES FROM HIGHEST TO LOWEST
-- [ IT HANDLES TIE  WITH GAPS]

SELECT 
	OrderID,
	ProductID,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) as rank_by_sales
FROM Sales.Orders


-------------  3. DENSE_RANK()  ------------

-- RANK THE ORDERS BASED ON THEIR SALES FROM HIGHEST TO LOWEST
-- [ IT HANDLES TIE  WITHout  GAPS]

SELECT 
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK() OVER (ORDER BY Sales DESC) as rank_by_sales
FROM Sales.Orders

--- USE CASE : 1 --> TOP N ANALYSIS

-- FIND THE TOP HIGHEST SALES FOR EACH PRODUCT

SELECT * FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) rank_by_sales
	FROM Sales.Orders)t
WHERE rank_by_sales = 1

-- --- USE CASE : 2 --> BOTTOM N ANALYSIS

-- FIND THE LOWEST 2 CUSTOMERS BASED ON THEIR TOTAL SALES

SELECT * FROM(
	SELECT
		CustomerID,
		SUM(Sales) Total_sales,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) as rank_by_customers
	FROM Sales.Orders
	GROUP BY CustomerID)t
WHERE rank_by_customers <= 2

-- --- USE CASE : 3 --> ASSIGN UNIQUE ID'S

-- ASSIGN UNIQUE IDS TO THE ROWS OF 'ORDERS ARCHIVE'

SELECT * FROM Sales.OrdersArchive

SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID) AS UniqueID,
	*
FROM Sales.OrdersArchive

---- USE CASE : 4 --> IDENTIFY DUPLICATES

-- IDENTIFY DUPLICATE ROWS IN THE TABLE 'ORDERS ARCHIVE'
-- AND RETURN A CLEAN RESULTS WITHOUT ANY DUPLICATES
-- [TAKING ONLY RECENT DATA]

SELECT * FROM(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
		*
	FROM Sales.OrdersArchive)t
WHERE rn = 1

--- if u want only MESSY RESULTS OR DUPLICATES

SELECT * FROM(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
		*
	FROM Sales.OrdersArchive)t
WHERE rn > 1

-------------  4. NTILE(n)  ------------

SELECT 
	OrderID,
	Sales,
	NTILE(4) OVER(ORDER BY Sales DESC) Four_bucket,
	NTILE(3) OVER(ORDER BY Sales DESC) Three_bucket,
	NTILE(2) OVER(ORDER BY Sales DESC) Two_bucket,
	NTILE(1) OVER(ORDER BY Sales DESC) One_bucket
FROM Sales.Orders


---- USE CASE : 1 --> DATA SEGMENTATION

-- SEGMENT ALL ORDERS INTO 3 CATEGORIES: HIGH,MEDIUM,LOW Sales

SELECT * FROM Sales.Orders

SELECT *,
	CASE
		WHEN Buckets = 1 THEN 'HIGH'
		WHEN Buckets = 2 THEN 'MEDIUM'
		WHEN Buckets = 3 THEN 'LOW'
	END Sales_Segmentation
FROM(
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) Buckets
	FROM Sales.Orders)t

-- IN ORDER TO EXPORT THE DATA ,DIVIDE THE ORDERS INTO 2 GROUPS

SELECT 
	NTILE(2) OVER(ORDER BY OrderId) Buckets,
	*
FROM Sales.Orders


-------------------------- PERCENTAGE BASED RANKING ------------------------

---------- 1. CUME_DIST() ----------

-- FIND THE PRODUCTS THAT FALL WITHIN THE HIGHEST 40% OF THE PRICES

SELECT * FROM Sales.Products

SELECT 
	*,
	CONCAT(DistRank*100,'%') AS DistRank_PERCENT
FROM(
	SELECT 
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) DistRank
	FROM Sales.Products)t
WHERE DistRank <= 0.4

---------- 2. PERCENT_RANK() ----------

-- FIND THE PRODUCTS THAT FALL WITHIN THE HIGHEST 40% OF THE PRICES

SELECT * FROM Sales.Products

SELECT 
	*,
	CONCAT(DistRank*100,'%') AS DistRank_PERCENT
FROM(
	SELECT 
		Product,
		Price,
		PERCENT_RANK() OVER(ORDER BY Price DESC) DistRank
	FROM Sales.Products)t
WHERE DistRank <= 0.4


------------------------ WINDOW VALUE FUNCTIONS -------------------

-- ANALYZE THE MONTH-OVER-MONTH(MOM) PERFORMANCE
-- BY FINDING THE PERCENTAGE CHANGE IN SALES

SELECT * FROM SALES.ORDERS

SELECT *,
current_month_sales - previous_month_sales as MOM_Change,
ROUND(CAST((current_month_sales - previous_month_sales) AS FLOAT)/ previous_month_sales * 100,1) AS MOM_PERCENT
FROM(
	SELECT
		MONTH(OrderDate) order_month,
		SUM(Sales) current_month_sales,
		LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) previous_month_sales
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
	)t

-- IN ORDER TO ANALYZE CUSTOMER LOYALTY,
-- RANK CUSTOMERS BASED ON THE AVERAGE DAYS BETWEEN THEIR ORDERS

SELECT 
	CustomerID,
	AVG(days_until_nextorder) avg_days,
	RANK() OVER(ORDER BY COALESCE(AVG(days_until_nextorder),99999)) ranking_avg
FROM(
	SELECT
		CustomerID,
		OrderDate current_order,
		LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) next_order,
		DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate))days_until_nextorder
	FROM Sales.Orders
	)t
GROUP BY CustomerID

------------- 1. FIRST_VALUE() --------------
_____________ 2. LAST_VALUE() --------------

-- FIND THE HIGHEST AND LOWEST  SALES FOR EACH PRODUCT

SELECT
	OrderID,ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowest_sales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highest_sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) highest_sales2,
	MAX(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) highest_sales3,
	MIN(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) lowest_sales2
FROM Sales.Orders

-- FIND THE DIFFERENCE IN SALES BETWEEEN THE CURRENT AND THE LOWEST SALES

SELECT
	OrderID,ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowest_sales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highest_sales,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowest_sales
	FROM Sales.Orders



