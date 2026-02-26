/* ====================================================== 
                -- TYPES OF SQL FUNCTIONS --

  1. SINGLE ROW FUNCTIONS           2. MULTI ROW
  -- STRING FUNCTIONS               -- AGRREGATE FUNCTIONS
  -- NUMERIC                        -- WINDOW FUNCTIONS
  -- DATE & TIME                    
  -- NULL
 ========================================================= */

 /* ================================= */
             -- STRING FUNCTIONS --
 /* ================================= */

-- CONCAT()

/*SHOW A LIST OF CUSTOMERS FIRST NAMES TOGETHER WITH THEIR COUNTRY IN ONE COLUMN*/

USE MyDatabase;

SELECT 
    first_name,
    country,
    CONCAT(first_name,' , ', country) AS name_country
FROM customers;

-- UPPER(), LOWER()

/* TRANSFORM THE CUSTOMERS FIRST NAME TO LOWERCASE */

SELECT 
    first_name,
    LOWER(first_name) AS name
FROM customers;

/* TRANSFORM THE CUSTOMERS FIRST NAME TO UPPER CASE */

SELECT 
    first_name,
    UPPER(first_name) AS name
FROM customers;

-- TRIM()

/* FIND THE CUSTOMERS WHOSE FIRST NAME CONTAINS LEADING OR TRAILING SPAACES*/

SELECT 
    first_name
FROM customers
WHERE first_name != TRIM(first_name);

-- OR --

SELECT 
    first_name,
    LEN(first_name) AS len_name,
    LEN(TRIM(first_name)) AS trim_len_name,
    LEN(first_name) - LEN(TRIM(first_name)) AS flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name))

-- REPLACE()

SELECT
    '123-456-789' AS phone_num,
    REPLACE('123-456-789' ,'-', '') AS clean_phone


-- REPLACE FILE EXTENCE FROM txt to csv

SELECT
    'report.txt' AS data,
    REPLACE('report.txt', '.txt', '.csv') AS clean_data


-- LEN()

SELECT
    first_name,
    LEN(TRIM(first_name)) as len_of_name
FROM customers

-- LEFT(), RIGHT()

/* RETRIVE FIRST TWO CHARACTERS OF EACH FIRST NAME */

SELECT
    first_name,
    LEFT(TRIM(first_name), 2) as first_2_char
FROM customers;

/* RETRIVE LAST TWO CHARACTERS OF EACH FIRST NAME */

SELECT
    first_name,
    RIGHT(TRIM(first_name), 2) as last_2_char
FROM customers;

-- SUBSTRING

SELECT
    first_name,
    SUBSTRING(TRIM(first_name), 2, LEN(first_name))
FROM customers;



/* ================================= */
        -- NUMERIC FUNCTIONS --
/* ================================= */

-- ROUND()

SELECT 
    3.516,
    ROUND(3.516,2) AS round_2,
    ROUND(3.516,1) AS round_1,
    ROUND(3.516,0) AS round_0


-- ABS()

SELECT
-10,
ABS(-10),
ABS(10)


/* ================================= */
      -- DATE & TIME FUNCTIONS --
/* ================================= */

USE SalesDB;

SELECT 
    OrderID,
    CreationTime,
    GETDATE() today
FROM Sales.Orders;

-- PART EXTRACTION --

-- DAY(date), MONTH(part, date), YEAR(part, date)

SELECT
    OrderID,
    CreationTime,
    YEAR(CreationTime) year,
    MONTH(CreationTime) month,
    DAY(CreationTime) date
FROM Sales.Orders

-- DATEPART(part, date)[week, quarter]

SELECT
    OrderID,
    CreationTime,
    DATEPART(year,CreationTime) Year_dp,
    DATEPART(month,CreationTime) Month_dp,
    DATEPART(day,CreationTime) Day_dp,
    DATEPART(quarter,CreationTime) quarter_dp,
    DATEPART(WEEK,CreationTime) week_dp,
    DATEPART(HOUR,CreationTime) hour_dp,
    DATEPART(weekday,CreationTime) weekday_dp
FROM Sales.Orders


-- DATENAME(part, date) [output is in string format]

SELECT
    OrderID,
    CreationTime,
    DATENAME(month, CreationTime) as month,
    DATENAME(WEEKDAY, CreationTime) as weekday,
    DATENAME(DAY, CreationTime) as day, -- string
    DATENAME(YEAR, CreationTime) as year, -- string
    DATENAME(DAYOFYEAR, CreationTime) as day_of_year
FROM Sales.Orders

-- DATETRUNC(part, date)

SELECT
    OrderID,
    CreationTime,
    DATETRUNC(HOUR,CreationTime) hour_dt,
    DATETRUNC(DAy,CreationTime) day_dt,
    DATETRUNC(MONTH,CreationTime) month_dt,
    DATETRUNC(YEAR,CreationTime) year_dt
FROM Sales.Orders

/* REturn number of orders in a month */

SELECT
    DATETRUNC(MONTH,CreationTime) AS Creation,
    COUNT(*) as No_of_orders
FROM Sales.Orders
GROUP BY  DATETRUNC(MONTH,CreationTime);


-- EOMONTH(date) [ end of month)

SELECT
    OrderID,
    CreationTime,
    EOMONTH( CreationTime) EndOfMonth,
    CAST(DATETRUNC(month, CreationTime) AS Date) StartOfMonth
FROM Sales.Orders


/* HOW MANY ORDERS WERE PLACED EACH YEAR */

SELECT
    DATETRUNC(YEAR,OrderDate) year,
    COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR,OrderDate)

-- or 

SELECT
    YEAR(OrderDate) year,
    COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)



/* HOW MANY ORDERS WERE PLACED EACH YEAR, month */

SELECT
    DATENAME(month,OrderDate) month,
    COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

/* SHOW ALL ORDERS THAT WERE PLACED DURING THE MONTH OF FEBRUARY */

SELECT * FROM Sales.Orders;

SELECT 
*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2



/* ================================= */
         -- FORMAT & CASING --
/* ================================= */

-- FORMAT( value, format,[culture])

SELECT
    OrderID,
    CreationTime,
    FORMAT(CreationTime, 'dd') dd,
    FORMAT(CreationTime, 'ddd') ddd,
    FORMAT(CreationTime, 'dddd') dddd,
    FORMAT(CreationTime, 'MM') MM,
    FORMAT(CreationTime, 'MMM') MMM,
    FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders

-- USA FORMAT

SELECT 
    OrderID,
    CreationTime,
    FORMAT(CreationTime,'dd/MM/yyyy') INDIA_format,
    FORMAT(CreationTime,'MM-dd-yyyy') usa_format,
    FORMAT(CreationTime,'dd-MM-yyyy') euro_format
FROM Sales.Orders;


/* SHOW CREATION TIME USING THE FOLLOWING FORMAT */

-- DAY WED JAN Q1 2025 12:34:56 PM

USE SalesDB;

SELECT 
    OrderID,
    CreationTime,
    'DAY' + ' ' + FORMAT(CreationTime,'ddd MMM') + 
    ' Q' + DATENAME(QUARTER,CreationTime) + ' ' +
    FORMAT(CreationTime,' yyyy hh:mm:ss tt ') CUSTOM_fORMAT
FROM Sales.Orders;

-- CONVERT(data-type, value, ['style'])

SELECT 
    CONVERT(INT, '123') AS [string to INT],
    CONVERT(DATE,'2026-03-20') AS [ string to date],
    CreationTime,
    CONVERT(DATE,CreationTime) AS [Datetime to Date]
FROM Sales.Orders


SELECT
    CreationTime,
    CONVERT(DATE,CreationTime) AS [Datetime to Date],
    CONVERT(VARCHAR, CreationTime,32) AS [USA std. Style:32],
    CONVERT(VARCHAR,CreationTime,34) AS [EURO std. STYLE:34]
FROM Sales.Orders


-- CAST( value, data_type)

SELECT 
    CAST('123' AS INT) AS [string to int],
    CAST(123 AS VARCHAR) AS [int to string],
    CAST('2025-08-25' AS DATE) AS [ string to date],
    CAST('2025-08-25' AS datetime2) AS [ string to datetime]


SELECT 
    CreationTime,
    CAST(CreationTime AS DATE) AS [ datetime to date]
FROM Sales.Orders;


/* ================================= */
         -- DATE CALCULATION --
/* ================================= */

-- DATEADD(part(year,month,day), interval(2,3,-4), date)

SELECT
    OrderID,
    OrderDate,
    DATEADD(day, -10, OrderDate) AS tendaybefore,
    DATEADD(month, 5, OrderDate) AS fivemonthlater,
    DATEADD(year, 3, OrderDate) AS threeyearlater
FROM Sales.Orders;


-- DATEDIFF(part, start_date, end_date)

/* CALCULATE THE AGE OF EMPLOYEES */

SELECT * FROM Sales.Employees;

SELECT
    EmployeeID,
    FirstName,
    BirthDate,
    DATEDIFF(year, BirthDate, GETDATE()) AS Age
FROM Sales.Employees


/* FIND THE AVERAGE SHIPPING DURATION IN DAYS FOR EACH MONTH */

SELECT * FROM Sales.Orders;

SELECT
    MONTH(OrderDate) AS month,
    AVG(DATEDIFF(day, OrderDate, ShipDate)) AS [avg no of days]
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- TIME GAP ANALYSIS
/* FIND THE NUMBER OF DAYS BETWEEN EACH ORDER AND THE PREVIOUS ORDER */

SELECT 
    OrderID,
    OrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) PreviouOrderDate,
    DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) [num of days]
FROM Sales.Orders



/* ================================= */
         -- DATE Validation --
/* ================================= */

-- ISDATE(value)

SELECT 
    ISDATE('2003') datecheck1,
    ISDATE('2003-07-9') datecheck2,
    ISDATE('2003/07/09') datecheck3,
    ISDATE('03/07/2009') datecheck4,
    ISDATE('213') datecheck5,
    ISDATE('03-20-2009') datecheck4


/* IDENTIFY WHETHER THE DATE IS VALID OR NOT */

SELECT
        OrderDate,
        ISDATE( OrderDate) in_date_format,
        CASE WHEN ISDATE( OrderDate) = 1 THEN CAST(Orderdate AS Date)
        END newOrderDate
FROM 
(
    SELECT '2025-08-20' AS OrderDate UNION
    SELECT '2025-08-21' UNION
    SELECT '2025-08-23' UNION
    SELECT '2025-08'
    )t

-- WHERE ISDATE( OrderDate) = 0
-- WHERE ISDATE( OrderDate) = 1



