/* ====================================================== 
                
                -- SQL NULL FUNCTIONS --

  --  ISNULL()              -- IS NULL
  -- COALESCE               -- IS NOT NULL              
  -- NULLIF                  

 ========================================================= */

 
 /* ================================= */
             -- ISNULL() --
 /* ================================= */

 -- ISNULL(value, replacement_value [another column value or 'unknown']) [ replacing null values with unknown]


 /* ================================= */
             -- COALESCE () --
 /* ================================= */

 -- COALEASCE(value1 value2, value 3)

 USE SalesDB;

 /* FIND THE AVERAGE SCORES OF THE CUSTOMERS */

 SELECT * FROM sales.Customers;

 SELECT
    CustomerID,
    Score,
    AVG(Score) OVER () AVGscore,
    COALESCE(Score,0) COALESCEscore,
    AVG(COALESCE(Score,0)) OVER() AVGscore2
FROM sales.Customers;

-- ALWAYS HANDLE NULL BEFORE AGGREGATION OR ANY MATHEMATICAL OPEARATIONS


-- 5 +2 = 7
-- 5 + null = null

/* DISPLAY THE FULL NAME OF CUSTOMERS IN A SINGLE FIELD
BY MERGING THEIR FIRST AND LAST NAME,
AND ADD 10 BONUS POINTS TO EACH CUSTOMERS SCORE*/

SELECT * FROM Sales.Customers;

SELECT
    CustomerID,
    COALESCE(FirstName,'') + ' ' + COALESCE(LastName,'') AS full_name,
    Score,
    COALESCE(Score,0) + 10 AS bonus_score
FROM Sales.Customers;


-- ALWAYS HANDLE NULL BEFORE JOINING TABLES

-- ALWAYS HANDLE NULL BEFORE SORTING 

/* SORT THE CUSTOMERS FROM LOWEST TO HIGHEST SCORE 
WITH NULLS APPEARING LAST */

SELECT 
    CustomerID,
    Score,
    -- ISNULL(Score, 99999)
    CASE WHEN Score IS NULL THEN 1 ELSE 0 END
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END,Score


/* ================================= */
             -- NULLIF () --
 /* ================================= */

-- NULLIF(value1, value2) [ if 2 values are equal returns null, else returns first value ]
-- NULLIF (Price , -1)

-- use case: to avoid divide by zero

/* FIND THE SALES PRICE FOR EACH ORDER BY DIVIDING SALES BY QUANTITY */

SELECT * FROM Sales.Orders;

SELECT 
    OrderID,
    Sales,
    Quantity,
    NULLIF(Sales,0)/ NULLIF(Quantity,0) AS Price
FROM Sales.Orders;


/* ================================= */
     -- IS NULL()  & IS NOT NULL()--
 /* ================================= */

  --  VALUE IS NULL
  -- VALUE IS NOT NUL


/* IDENTIFY THE CUSTOMERS WHO HAVE NO SCORES */

SELECT * FROM Sales.Customers;

SELECT
    CustomerID,
    Score
FROM Sales.Customers
WHERE Score IS NULL;

SELECT
    *
FROM Sales.Customers
WHERE Score IS NOT NULL;


-- ALWAYS HANDLE NULL BEFORE JOINING TABLES

/* LIST ALL DETAILS FOR CUSTOMERS WHO HAVE NOT PLACED ANY ORDERS */

SELECT *  FROM Sales.Customers;
SELECT *  FROM Sales.Orders;

SELECT
    C.*,
    O.OrderID
FROM Sales.Customers C
LEFT JOIN Sales.Orders O
ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL


-- null VS empty VS BLANK SPACE

WITH Orders AS(
SELECT 1 id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '    ' 
)
SELECT 
*,
DATALENGTH(Category) category_len,
DATALENGTH(TRIM(Category)) AS trimmed_category,
TRIM(Category) policy1,
NULLIF(TRIM(Category),'') policy2, -- best when inserting into databses, less storage,(unknown) takes more storage
COALESCE(NULLIF(TRIM(Category),''),'unknown') policy3 -- (unknown) best while preparation of report
FROM Orders



/* ================================= */
          -- CASE STATEMENTS --
 /* ================================= */


 /* CASE 
        WHEN condition1 THEN 'result1'
        WHEN condition  THEN 'result2'
        ELSE
    END  */

/* CREATE REPORT SHOWING TOTAL SALES FOR EACH OF THE FOLLOWING CATEGORIES:
HIGH-> SALES OVER 50, MEDIUM ->SALES 21-50, AND LOW-> ,=20 
SORT THE CATEGORIES FROM HIGHEST SALES TO LOWEST */


SELECT 
Category,
SUM(Sales) AS TotalSales
FROM(
    SELECT 
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'high'
            WHEN Sales <= 50 AND Sales > 20 THEN 'medium'
            WHEN Sales <= 20 THEN 'low'
        END Category
    FROM Sales.Orders
)t
GROUP BY Category


/* RETRIEVE EMPLOYEE DETAILS WITH GENDER DISPLAYED AS FULL TEXT*/

SELECT * FROM Sales.Employees;

SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    CASE 
        WHEN Gender = 'M'THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
        ELSE 'Not Available'
    END Gende_Full_text
FROM Sales.Employees

/* RETRIEVE CUSTOMERS DETAILS WITH ABBREVIATED COUNTRY CODE */

SELECT 
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA' THEN 'US'
        ELSE 'n/a'
    END Countryabbr,
    CASE Country
        WHEN 'India' THEN 'IND'
        WHEN 'Australlia' THEN 'AUS'
        WHEN 'South Africa' THEN 'SA'
        WHEN 'Italy' THEN 'IT'
        ELSE 'n/a'
    END Othercountries
FROM Sales.Customers


/* FIND THE AVERAGE SCORES OF CUSTOMER AND TREAT NULLS AS 0
ADDITIONALLY PROVIDE DETAILS SUCH CUSTOMERid AND lASTNAME*/

SELECT
    CustomerID,
    LastName,
    CASE
        WHEN Score IS NULL THEN 0
        ELSE Score
    END Clean,
    AVG(CASE
        WHEN Score IS NULL THEN 0
        ELSE Score
    END ) OVER() Avg_score
FROM Sales.Customers;

-- OR

SELECT * FROM Sales.Customers;

SELECT
    CustomerID,
    LastName,
    SCore,
    COALESCE(Score,0),
    AVG(COALESCE(Score,0)) OVER() AS avg_score
FROM Sales.Customers;

/* COUNT HOW MANY TIMES EACH CUSTOMER HAS MADE AN ORDER WITH SALES GREATER THAN 30 */

SELECT
    CustomerID,
    COUNT(*) NO_OF_Orders,
    SUM(CASE
        WHEN Sales > 30 THEN 1
        ELSE 0
    END) total
FROM Sales.Orders
GROUP BY CustomerID

