SELECT
*
FROM INFORMATION_SCHEMA.COLUMNS

-- SCALAR SUBQUERY -> SINGLE VALUE

SELECT
	AVG(Sales) avg
FROM Sales.Orders

-- ROW SUBQUERY -> MULTIPLE ROWS AND SINGLE COLUMNS

SELECT
	CustomerID
FROM Sales.Orders


-- TABLE SUBQUERY -> MULTIPLE ROWS AND MULTIPLE COLUMNS

SELECT
	OrderID,
	CustomerID,
	Sales
FROM Sales.Orders

/* FIND THE PRODUCTS THAT HAVE A PRICE HIGHER THAN THE AVERAGE 
PRICE OF ALL PRODUCTS */

SELECT * FROM Sales.Products;

SELECT 
	*
FROM(
	SELECT
		ProductID,
		Product,
		Price,
		AVG(Price) OVER() AS avg_price
	FROM Sales.Products)t
WHERE Price > avg_price

/* RANK CUSTOMERS BASED ON THEIR TOTAL AMOUNT OF SALES */

SELECT * FROM Sales.Orders;

SELECT 
	*,
	RANK() OVER(ORDER BY total DESC) AS Rank_
FROM
	(SELECT
		CustomerID,
		SUM(Sales) total
	FROM Sales.Orders
	GROUP BY CustomerID)t

/* SHOW THE PRODUCTIDS, PRODUCT NAMES, PRICES, AND THE TOTAL NUMBER OF ORDERS */

-- SCALAR QUERY

-- main query
SELECT 
	ProductID,
	Product,
	Price,
		-- suquery
		(SELECT COUNT(*) FROM Sales.Orders) AS total_sales
FROM Sales.Products


/* SHOW ALL CUSTOMERS DETAILS AND FIND THE TOTAL ORDERS OF EACH CUSTOMER */

-- main query 

SELECT 
	c.*,
	o.TotalOrders
FROM Sales.Customers c
LEFT JOIN(
	-- subquery
	SELECT 
		CustomerID,
		COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID


/* FIND THE PRODUCTS THAT HAVE A PRICE HIGHER THAN THE AVERAGE PRICE OF ALL PRODUCTS */ 

SELECT * FROM sales.Products;

SELECT
	ProductID,
	Product,
	Price,
	(SELECT AVG(Price) FROM Sales.Products) AS avg_price
FROM Sales.Products
WHERE Price > ( SELECT AVG(Price) FROM Sales.Products)


/* SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS IN GERMANY */

SELECT * FROM Sales.Orders;
SELECT * FROM Sales.Customers;

SELECT 

SELECT 
	CustomerID,
	FirstName,
	Country
FROM Sales.Customers
WHERE Country = 'Germany'

-- instead 

SELECT 
* 
FROM Sales.Orders
WHERE CustomerID IN 
				(SELECT CustomerID
				FROM Sales.Customers
				WHERE Country = 'Germany')


/* SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS IN NOT IN GERMANY */


SELECT 
* 
FROM Sales.Orders
WHERE CustomerID IN 
				(SELECT CustomerID
				FROM Sales.Customers
				WHERE Country != 'Germany')

------- 0R -------


SELECT 
* 
FROM Sales.Orders
WHERE CustomerID NOT IN 
				(SELECT CustomerID
				FROM Sales.Customers
				WHERE Country = 'Germany')

/* FIND FEMALE EMPLOYEES WHOSE SALRIES ARE GREATER THAN 
THE SALARIES OF ANY MALE EMPLOYEES*/

--main
SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F' 
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');
								


/* FIND FEMALE EMPLOYEES WHOSE SALRIES ARE GREATER THAN 
THE SALARIES OF ALL MALE EMPLOYEES*/

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F' 
-- subquery
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

/*	SHOW ALL CUSTOMERS DETAILS AND FIND THE TOTAL ORDERS OF EACH CUSTOMERS */	

SELECT * FROM Sales.Customers;

SELECT * FROM Sales.Orders;

SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) total_num_sales
FROM Sales.Customers c

/* SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS IN GERMANY */

SELECT 
*
FROM Sales.Orders o
WHERE EXISTS (
				SELECT 1
				FROM Sales.Customers c
				WHERE Country = 'Germany'
				AND
				o.CustomerID = c.CustomerID);
		
/* SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS NOT  IN GERMANY */

SELECT 
*
FROM Sales.Orders o
WHERE NOT EXISTS (
				SELECT 1
				FROM Sales.Customers c
				WHERE Country = 'Germany'
				AND
				o.CustomerID = c.CustomerID);
		