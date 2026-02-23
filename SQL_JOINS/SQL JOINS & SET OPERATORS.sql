/* ================================= */
             -- JOINS --
/* ================================= */

-- # NO JOIN

USE MyDatabase;

/* RETRIEVE ALL DATA FROM CUSTOMERS AND ORDERS IN TWO 
DIFFERENT RESULTS*/

SELECT * FROM customers;

SELECT * FROM orders;


/* ================================= */
            -- INNNER JOINS --
/* ================================= */

/* GET ALL CUSTOMERS ALONG WITH THEIR ORDERS,
BUT ONLY FOR CUSTOMERS WHO HAVE PLACED AN ORDER */

SELECT * FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id;


/* ================================= */
            -- LEFT & RIGHT JOINS --
/* ================================= */

/* GET ALL CUSTOMERS ALLONG WITH THEIR ORDERS, INCLUDING 
THOSE WITHOUT ORDERS */

SELECT * FROM customers;

SELECT * FROM orders;

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id;

/* GET ALL CUSTOMERS ALLONG WITH THEIR ORDERS, INCLUDING 
 ORDERS WITHOUT  MATCHING CUSTOMERS */

 SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
RIGHT JOIN orders o
ON c.id = o.customer_id;


-- SAME TASK USING LEFT JOIN

SELECT * FROM customers;

SELECT * FROM orders;

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders o 
LEFT JOIN customers c
ON  o.customer_id = c.id ;


/* ================================= */
            -- FULL JOIN --
/* ================================= */

/* GET ALL CUSTOMERS AND ALL ORDERS , EVEN IF THERE'S NO MATCH */

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders o 
FULL JOIN customers c
ON  o.customer_id = c.id ;



/* ================================= */
            -- LEFT ANTI JOIN --
/* ================================= */

/* GET ALL THE CUSTOMERS WHO HAVEN'T PLACE ANY ORDER */

SELECT * FROM customers;

SELECT * FROM orders;

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

/* ================================= */
            -- RIGHT ANTI JOIN --
/* ================================= */

/* GET ALL OrDERS WITHOUT MATCHING CUSTOMERS*/

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
RIGHT JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NULL;

-- SAME TASK USING LEFT JOIN

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id 
WHERE c.id IS NULL;


/* ================================= */
            -- FULL ANTI JOIN --
/* ================================= */

/* FIND CUSTOMERS WITHOUT ORDERS AND ORDERS WITHOUT CUSTOMERS */

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
FULL JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;

/* GET ALL CUSTOMERS ALONG EITH THEIR ORDERS, BUT ONLY FOR CUSTOMERS 
WHO HAVE PLACED AN ORDER  (WITHOUT INNER JOIN) */ 

SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers c
FULL JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NOT NULL AND o.customer_id IS NOT NULL;


/* ================================= */
            -- CROSS JOIN --
/* ================================= */

-- all possible combinations = cartesian join

/* GENERATE ALL POSSIBLE COBO OF CUSTOMERS AND ORDERS */

SELECT * FROM customers
CROSS JOIN orders;


/* ================================= */
       -- JOIN MULTIPLE TABLES --
/* ================================= */

/* USING SALESDB , RETRIEVE A  LIST OF ALL OREDERS , ALONG WITH THE 
RELATED CUSTOMERS , PRODUCTS, AND EMPLOYEE DETAILS. FOR EACH ORDER DISPALY:
ORDERID, CUSTOMERS ID, PRODUCT NAME, SALES, PRICE ,SALES PERSON NAME*/

USE SalesDB;

SELECT * FROM Sales.Orders

SELECT * FROM Sales.Customers;
SELECT * FROM Sales.Employees;
SELECT * FROM Sales.Products


SELECT 
    o.OrderID, o.Sales,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    p.Product AS Product_Name,
    p.Price,
    e.FirstName,
    e.LastName
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID;


/* ================================= */
            -- SET OPERATORS --
/* ================================= */

-- # UNION, 

SELECT
    FirstName,
    LastName
FROM Sales.Customers

UNION

SELECT
    FirstName,
    LastName
FROM Sales.Employees

/* COMBINE THE DATA FROM EMPLOYEES AND CUSTOMERS 
INTO ONE TABLE */

SELECT * FROM Sales.Customers;
SELECT * FROM Sales.Employees;

SELECT
    FirstName,
    LastName
FROM Sales.Customers
UNION
SELECT 
    FirstName,
    LastName
FROM Sales.Employees

/* COMBINE THE DATA FROM EMPLOYEES AND CUSTOMERS 
INTO ONE TABLE ,INCLUDING DUPLICATES */

USE SalesDB;

-- UNION ALL

SELECT 
    FirstName,
    LastName
FROM Sales.Customers

UNION ALL

SELECT 
    FirstName,
    LastName
FROM Sales.Employees
ORDER BY FirstName;

-- EXCEPT

/* FIND THE EMPLOYEES WHO ARE NOT CUSTOMERS AT THE SAME TIME */

SELECT 
    FirstName,
    LastName
FROM Sales.Employees

EXCEPT

SELECT 
    FirstName,
    LastName
FROM Sales.Customers
ORDER BY FirstName;



/* FIND THE CUSTOMERS WHO ARE NOT EMPLOYEES AT THE SAME TIME */

SELECT 
    FirstName,
    LastName
FROM Sales.Customers

EXCEPT

SELECT 
    FirstName,
    LastName
FROM Sales.Employees
ORDER BY FirstName;

/* FIND THE CUSTOMERS WHO ARE ALSO EMPLOYEES */

SELECT 
    FirstName,
    LastName
FROM Sales.Customers

INTERSECT

SELECT 
    FirstName,
    LastName
FROM Sales.Employees
ORDER BY FirstName;

-- ORDER DATA ARE STORED IN SEPARATE TABLES (ORDERS AND ORDERSARCHIVE)
-- COMBINE ALL ORDERS DATA INTO ONE REPORT WITHOUT DUPLICATES

SELECT * FROM Sales.Orders;

SELECT * FROM Sales.OrdersArchive;

-- instead of this
SELECT * FROM Sales.Orders
UNION
SELECT * FROM Sales.OrdersArchive;

-- use columns

SELECT 
      'Orders' AS SourceTable
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
       'OrdersArchive' AS SourceTable
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID;