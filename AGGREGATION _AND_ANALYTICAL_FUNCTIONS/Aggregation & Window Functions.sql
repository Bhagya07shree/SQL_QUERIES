====================================================== 
                
              -- AGGREGATE FUNCTIONS --

     -- SUM()               -- MIN()
     -- AVG()               -- COUNT(*)            
     -- MAX()                 
 ========================================================= */

 /* retrieve  total, avg, min, max, no of sales sales */

SELECT 
    CustomerID,
    COUNT(*) AS [Total no o f Sales],
    SUM(Sales) AS [Total sales],
    AVG(sales) AS [avg_Sales],
    MAX(sales) AS [Hihest sales],
    MIN(Sales) AS [Lowest_Sales]
FROM Sales.Orders
GROUP BY CustomerID



====================================================== 
                
               -- WINDOW  BASIC FUNCTIONS --

                 -- SUM()      -- MIN()
                 -- AVG()      -- COUNT(*)            
                 -- MAX()                 
 ========================================================= */

 /* FIND THE TOTAL SALES FOR EACH ORDER */

SELECT 
    OrderID ,
    SUM(Sales) AS total
FROM Sales.Orders
GROUP BY 

/* FIND THE TOTAL SALES FOR EACH PRODUCT */

SELECT * FROM Sales.Orders;

SELECT 
    ProductID,
    SUM(sales) total
FROM sales.orders
GROUP BY ProductID

/* FIND THE TOTAL SALES FOR EACH PRODUCT ADDITIONALLY PROVIDE DETAILS SUCH ORDER
ID, ORDER DATE */

SELECT
    OrderID,
    CustomerID,
    ProductID,
    SUM(Sales) AS totals
FROM Sales.Orders
GROUP BY ProductID;

-- ERROR : column 'Sales.Orders.OrderID' is invalid in the select list because it is not contained in 
-- either an aggregate function or the GROUP BY clause.

-- need of window functions: to get the details 

SELECT
    OrderID,
    CustomerID,
    ProductID,
    SUM(Sales) OVER(PARTITION BY ProductID) totals
FROM Sales.Orders
ORDER BY ProductID


-- Synatax
/* AVG(Sales)    OVER(PARTITION BY category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING */
--window func         -- divide into groups

/* FIND THE TOTAL SALES FOR EACH PRODUCT ADDITIONALLLY PROVIDE DETAILS SUCH AS ORDER ID, ORDER DATE */

SELECT
    OrderId,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER() Total_sales,
    SUM(Sales) OVER(PARTITION BY ProductID) AS total 
FROM Sales.Orders


/* FIND THE TOTAL SALES FOR EACH COMBINATION OF PRODUCT AND ORDERStatuds 
ADDITIONALLLY PROVIDE DETAILS SUCH AS ORDER ID, ORDER DATE */

SELECT
    OrderId,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) AS total_sales
FROM Sales.Orders


/* RANK EACH ORDER BASED ON THEIR SALES FROM HIGHEST TO LOWEST 
ADDITIONALLY PROVIDE DETAILS SUCH ORDER ID, ORDER DATE */

SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) rank_
FROM Sales.Orders


SELECT
    OrderId,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
    ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS total_sales
FROM Sales.Orders

/* FIND THE TOTAL SALES  by ORDERSTATUS FOR PRODUCTID (101, 102)
ADDITIONALLLY PROVIDE DETAILS SUCH AS ORDER ID, ORDER DATE */


SELECT
    OrderId,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus) total_
FROM Sales.Orders
WHERE ProductID IN(101,102);

/* RANK CUSTOMERS BASED ON THEIR TOTAL SALES */ [using group by]

SELECT
    CustomerID,
    SUM(Sales) Total_sales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) rank_
FROM Sales.Orders
GROUP BY CustomerID


====================================================== 
                
               -- WINDOW AGRREGATE FUNCTIONS --

                 -- SUM()      -- MIN()
                 -- AVG()      -- COUNT(*)            
                 -- MAX()                 
 ========================================================= */


 /* FIND THE TOTAL NUMBER OF ORDERS
 FINFD THE TOTAL NUMBER OF ORDERS FOR EACH CUSTOMERS
 ADDITITIONALLY PROVIDE THE DETAILS SUCH AS ID, ORDER DATE*/

 SELECT
    OrderID,
    OrderDate,
    CustomerID,
    COUNT(*)  OVER() Total,
    COUNT(*) OVER(PARTITION BY CustomerID) Orderbycustomer
FROM Sales.Orders

/* FIND THE TOTAL NUMBER OF CUSTOMERS, ADDITIONALLY PROVIDE ALL CUSTOMER DETAILS
FIND THE TOTAL NUMBER OF SCORES FOR THE CUSTOMERS*/

SELECT 
* ,
COUNT(*) OVER() AS total,
COUNT(Score) OVER () total_customer,
COUNT(Country) OVER(PARTITION BY Country) total_countries
FROM Sales.Customers

/* CHECK WHETHER THE TABLE ' ORDERS' CONTAINS ANY DUPLICATE ROWS */

SELECT 
    OrderID,
    COUNT(*) OVER(PARTITION BY OrderID) CHECKPK
FROM Sales.Orders

SELECT 
* 
FROM
    (SELECT 
        OrderID,
        COUNT(*) OVER(PARTITION BY OrderID) CHECKPK
    FROM Sales.OrdersArchive)t
WHERE CHECKPK > 1

/* FIND THE TOTAL SALES ACROSS ALL PRODUCTS AND THE TOTAL SALES FOR EACH PRODUCT
ADDITIONALLY PROVIDE DETAILS SUCH ORDERID , ORDER DATE */

SELECT 
    OrderID,
    OrderDate,
    Sales,
    ProductID,
    SUM(Sales) OVER() total,
    SUM(Sales) OVER(PARTITION BY ProductID) Total_sales
FROM Sales.Orders

/* FIND THE PERCENTAGE CONTRIBUTION OF EACH PRODUCTS SALES TO THE TOTAL SALES*/

SELECT
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER() total,
    ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER () * 100,2) [percent(%)]
FROM Sales.Orders

/* FIND THE AVERAGE SALES ACROSS ALL ORDERS AND FIND THE AVERAGE SALES FOR EACH PRODUCT
ADDITIONALLY PROVIDE DETAILS SUCH ORDER ID, ORDER DATE */

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    AVG(Sales) OVER() avg_sales,
    AVG(Sales) OVER(PARTITION BY ProductID) avg_sales_byproduct
FROM Sales.Orders

/* FIND THE AVERAGE SCORES OF CUSTOMERS
ADDITIONALLY PROVIDE DETAILS SUCH AS CUSTOMERID AND LASTMNAME */

SELECT 
    customerID,
    LastName,
    Score,
    AVG(Score) OVER() Avg_score,
    AVG(COALESCE(Score,0)) OVER() nonull_avg
FROM Sales.customers


/* FIND ALL ORDERS WHERE SALES ARE HIGHER THAN THE AVERAGE SALES
ACROSS ALL ORDERS */

SELECT 
*
FROM(
    SELECT 
        OrderID,
        ProductID,
        Sales,
        AVG(Sales) OVER() avg_sales
    FROM Sales.Orders)t
WHERE Sales > avg_sales

/* FIND THE HIGHEST AND LOWEST SALES OF ALL ORDERS
FIND THE HOGHEST AND LOWEST SALES FOR EACH PRODUCT 
ADDITIONALLY PROVIDE DETAILS SUCH ORDERID, ORDER DATE
*/

SELECT
    OrderID,
    OrderDate,
    Sales,
    productID,
    MAX(Sales) OVER () max_sales,
    MIN(Sales) OVER() min_sales,
    MAX(Sales) OVER (PARTITION BY ProductID) max_sales_by_product,
    MIN(Sales) OVER(PARTITION BY ProductID) min_sales_by_product
FROM Sales.Orders

/* SHOW THE EMPLOYEES WHO HAVE THE HIGHEST SALARIES */

SELECT * FROM Sales.employees

SELECT 
* 
FROM(
    SELECT
    * ,
    MAX(salary) OVER() max_sal
    FROM Sales.employees)t
WHERE Salary = max_sal

/* FIND THE DEVIATION OF EACH SALES FROM THE MINIMUM AND MAXIMUM SALES AMOUNT */

SELECT 
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(sales) OVER() high_sales,
    MIN(Sales) OVER() low_sales,
    Sales - MIN(Sales) OVER() Deviationfrom_min,
    MAX(Sales) OVER()  - Sales Deiationfrom_max
FROM Sales.Orders


====================================================== 
                
               -- RUNNING AND ROLLING TOTAL --
               
 ========================================================= */

 -- ANALYTICAL USE CASES

 /* CALCULATE MOVING AVERAGE OF SALES FOR EACH PRODUCT OVER TIME */

SELECT 
    OrderId,
    ProductId,
    OrderDate,
    Sales,
    AVG(Sales) OVER (PARTITION BY ProductID) avg_by_product,
    AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MOVING_avg
FROM Sales.Orders

/* CALCULATE MOVING AVERAGE OF SALES FOR EACH PRODUCT OVER TIME
INCLUDING ONLY THE NEXT ORDER */

SELECT 
    OrderId,r
    ProductId,
    OrderDate,
    Sales,
    AVG(Sales) OVER (PARTITION BY ProductID) avg_by_product,
    AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate 
    ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ) rolling_avg
FROM Sales.Orders


====================================================== 
                
               -- WINDOW RANKING FUNCTION --

-- DISCRETE VALUES                  -- CONTINUOUS VALUES
-> ROW_RANK()                       -> CUME_DIST()
-> RANK()                           -> PERCENT_RANK()
->DENSE_RANK()

====================================================== 


SELECT
    OrderID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC)  sales_row_rank,
    RANK() OVER(ORDER BY Sales DESC)  sales_rank,
    DENSE_RANK() OVER(ORDER BY Sales DESC) sales_dense_rank
FROM Sales.Orders


/* FIND THE TOP HIGHEST SALE FOR EACH PRODUCT */

SELECT 
* 
FROM(
    SELECT 
        OrderID,
        ProductID,
        Sales,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) sales_rank
    FROM Sales.Orders)t
WHERE sales_rank = 1


/*FIND THE LOWEST 2 CUSTOMERS BASED ON THEIR TOTAL SALES */

SELECT 
*
FROM(
SELECT 
    CustomerID,
    SUM(Sales) AS Total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(Sales)) row_rank
FROM Sales.Orders
GROUP BY CustomerID )t
WHERE row_rank IN(1,2)

/* ASSIGN UNIQUE ID'S TO THE ROWS OF  THE ORDERS ARCHIVE TABLE */

SELECT * FROM Sales.OrdersArchive;

SELECT 
    ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) Unique_ID,
    *
FROM Sales.OrdersArchive;

/* IDENTIFY DUPLICATE ROWS IN THE TABLE 'ORDERS ARCHIVE
AND RETURN A CLEAN RESULT WITHOUT ANY DUPLICATES */


SELECT 
* 
FROM(
SELECT 
    ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime) rank_,
    *
FROM Sales.OrdersArchive)t
WHERE rank_ = 1 -- clean_data
-- WHERE rank_ > 1 -- duplicate_data


/*   NTILE(n)  = num of rows / n          */

SELECT
    OrderID,
    Sales,
    NTILE(1) OVER(ORDER BY Sales DESC) [1_bucket],
    NTILE(2) OVER(ORDER BY Sales DESC) [2_bucket],
    NTILE(3) OVER(ORDER BY Sales DESC) [3_bucket]
FROM Sales.Orders

--use case: segmentation

/* SEGMENT ALL ORDERS INTO 3 CATEGORIES : HIGH MEDIUM, AND LOW SALES */

SELECT
*,
CASE 
    WHEN buckets = 1 THEN 'High'
    WHEN buckets = 2 THEN 'Medium'
    WHEN buckets >= 3 THEN 'Low'
END Category
FROM (
    SELECT
        OrderID,
        Sales,
        NTILE(3) OVER (ORDER BY Sales DESC) buckets
    FROM Sales.Orders)t


--use case: load segmentation

/* IN ORDER TO EXPORT THE DATA , DIVIDE THE ORDERS INTO 2 GROUPS */

SELECT * FROM Sales.Orders;

SELECT 
    NTILE(2) OVER(ORDER BY OrderID) buckets,
    *
FROM Sales.Orders


--  FOR CONTINUOUS VALUES

-- CUME_DIST() = POSITION NUMBER / NO OF ROWS [ IF TIE -> SHARES SAME VALUE]

--PERCENT_RANK() = POSITION NUMBER - 1 / NO OF ROWS - 1  [ IF TIE -> SHARES SAME VALUE]


/* FIND THE PRODUCTS THAT FALL WITHIN THE HIGHEST 40% OF THE PRICES */


SELECT 
*,
CONCAT(cume_dist_rank * 100, '%') [in_percent(%)]
FROM(
    SELECT
        ProductID,
        Product,
        Price,
        CUME_DIST() OVER (ORDER BY Price DESC) cume_dist_rank
    FROM Sales.Products)t
WHERE cume_dist_rank <= 0.4


-- 0R --

SELECT 
*,
CONCAT(percent_rank * 100, '%')
FROM(
    SELECT
        ProductID,
        Product,
        Price,
        PERCENT_RANK() OVER (ORDER BY Price DESC) percent_rank
    FROM Sales.Products)t
WHERE percent_rank <= 0.4




====================================================== 
                
               -- WINDOW VALUE FUNCTION --

-> LEAD ()                          -> FIRST_VALUE()
-> LAG ()                           -> LAST_VALUE()
====================================================== 

-- ANALYTICAL FUNCTIONS- > ALLOWS  TO ACCESS SPECIFIC VALUE FROM ANOTHER ROW

-- use case 1: Time Series analysis (MOM) , (YOY)
-- use case 2 TIME GAP ANALYSIS, COMAPRISON ANALYSIS

/* Analyze the month-over month performance by finding the percentage change
in sales between the current and previuos months */

SELECT 
* ,
current_month_sales - previous_month_sales AS MOM_change,
ROUND(CAST((current_month_sales - previous_month_sales) AS FLOAT)/(previous_month_sales) * 100,2) AS [percent(%)]
FROM(
    SELECT 
        MONTH(OrderDate) month_,
        SUM(Sales) current_month_sales,
        LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) previous_month_sales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
    )t

/* IN ORDER TO ANALYZE CUSTOMER LOYALTY,
RANK CUSTOMERS BASED ON THE AVERAGE DAYS BETWEEN THEIR ORDERS */

SELECT * FROM Sales.Orders;

SELECT
CustomerID,
AVG(days_until_next_order) avg_days,
RANK() OVER(ORDER BY COALESCE(AVG(days_until_next_order),9999)) Ranking
FROM(
    SELECT 
        CustomerID,
        OrderID,
        OrderDate AS [current_order],
        LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) [next_order],
        DATEDIFF(day,OrderDate , LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) days_until_next_order
    FROM Sales.Orders)t
GROUP BY CustomerID

-- FIRST_VALUE(), LAST_VALUE()

/* FIND THE LOWEST AND THE HIGHEST SALES FOR EACH PRODUCT*/

SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowestsales1,
    LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highestsales,
     FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) heighestsales2
FROM Sales.Orders


-- OR --


SELECT
    ProductID,
    MAX(Sales) OVER(PARTITION BY ProductID) heighestsales,
    MIN(Sales) OVER(PARTITION BY ProductID)lowestsales
FROM Sales.Orders


/* FIND THE LOWEST AND THE HIGHEST SALES FOR EACH PRODUCT
 FIND THE DIFFERENCE BETWEEN CURRENT AND LOWEST
 FIND THE DIFFERENCE BETWEEN CURRENT AND HIGHEST */

SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowestsales1,
    LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highestsales,
    Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) sales_diff
FROM Sales.Orders