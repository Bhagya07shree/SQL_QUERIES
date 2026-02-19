USE MyDatabase;

-- RETRIEVE ALLL COSTUMERS DATA

SELECT * FROM customers;

-- RETRIEVE ALLL COSTUMERS DATA

SELECT * FROM orders;

-- RETRIEVE EACH CUSTOMER'S NAME ,COUNTRY AND SCORE

SELECT * FROM customers;

SELECT first_name,country,score
FROM customers;

------- WHERE CLAUSE ------

-- FILTERS DATA BASED ON THE CONDITION

-- RETRIEVE CUSTOMERS WITH A SCORE NOT EQUAL TO ZERO

SELECT * FROM customers;

SELECT * FROM customers
WHERE score != 0;

-- -- RETRIEVE CUSTOMERS

SELECT * FROM customers
WHERE country = 'Germany';

------- ORDER BY -------

-- SORT YOUR DATA ASCENDING OR DESCENDING

/* REYRIVE ALL THE ORDERS AND SORT THE 
RESULTS BY THE HIGHEST SCORE */

SELECT * FROM orders;

SELECT * FROM orders
ORDER BY sales DESC;


/* REYRIVE ALL THE CUSTOMERS AND SORT THE 
RESULTS BY THE LOWEST SCORE */

SELECT * FROM customers;

SELECT * FROM customers
ORDER BY score ASC;

/* RETRIEVE  ALL CUSTOMERS AND SORT THE RESULTS
BY THE COUNTRY AND THEN BY THE HIGHEST SCORE*/

SELECT * FROM customers
ORDER BY country ASC ,score DESC;

--------- GROUP BY -----------

-- COMBINES ROW WITH THE SAME COLUMN

/* FIND THE TOATL SCORE FOR EACH COUNTRY */

SELECT * FROM customers;

SELECT country, SUM(score) AS total
FROM customers
GROUP BY country
ORDER BY total;

/* FIND THE TOTAL SCORE AND TOTAL NUMBER OF CUSTOMERS 
FOR EACH COUNTRY*/

SELECT * FROM customers;

SELECT country,
COUNT(id) AS No_Of_Customer,
SUM(score) as total_score
FROM customers
GROUP BY country;


--------- HAVING -----------

-- FILTERS DATA AFTER AGGREGATION --

/* FIND THE AVERAGE SCORE FOR EACH COUNTRY CONSIDERING 
ONLY CUSTOMERS WITH A SCORE NOT EQAUL TO 0 AND RETURN ONLY
THOSE COUNTRIES WITH AN AVERAGE SCORE GREATE THAN 430 */

SELECT * FROM customers;

SELECT
country,
AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;


----------- DISTINCT --------

-- UNIQUE VALUES

/* RETURN UNIQE LIST OF ALL COUNTRIES */

SELECT DISTINCT country FROM customers;

----------- TOP(limit) -------------

SELECT TOP 3 * FROM customers;

/* RETRIEVE TOP 3 CUSTOMERS WITH HIGHEST SCORES */

SELECT TOP 3 * FROM customers
ORDER BY score DESC;

/* RETRIEVE THE LOWEST 2 CUSTOMERS BSED ON THE SCORE */

SELECT TOP 2 * FROM customers
ORDER BY score ASC;

/*  GET THE 2 MOST RECENT ORDERS*/

SELECT * FROM orders;

SELECT TOP 2 * FROM orders
ORDER BY order_date DESC;


/* ================================= */
    -- DATA DEFINITION LANGUAGE(DDL)
/* ================================= */

--  # CREATE , # ALTER, # DROP


/* CREATE NEW TABLE CALLED PERSONS WITH COLUMNS:
id,. person_name, birth_date, and phone*/

CREATE TABLE persons(
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
);

SELECT * FROM persons;

/* ADD A NEW COLUMN CALLED EMAIL TO THE PERSON TABLE */

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

/* REMOVE A NEW COLUMN CALLED EMAIL TO THE PERSON TABLE */

ALTER TABLE persons
DROP COLUMN phone;

/* DROP THE TABLE PERSON */

DROP TABLE PERSONS;


/* ================================= */
    -- DATA MANIPULATION LANGUAGE(DML)
/* ================================= */

-- # INSERT, # DELETE, # UPDATE(MODIFY)

SELECT * FROM customers;

INSERT INTO customers(id, first_name, country, score)
VALUES 
    (6, 'ANNA', 'USA', NULL),
    (7, 'Sam', NULL, 100);

INSERT INTO customers(id,first_name,country)
VALUES 
    (8, 'Bhagya', 'India'),
    (9, 'Andeaus', 'Germany'),
    (10, 'Sahara', 'Mexico');

-- INSERT DATA FROM CUSTOMERS INTO PERSONS

INSERT INTO persons(id, person_name, birth_date,phone)
SELECT
id, first_name, NULL, 'Unknown'
FROM customers;

SELECT * FROM persons;

-- CHANGE THE SCORE OF CUSTOMER WITH ID 6 TO 0

UPDATE customers
SET score = 0
WHERE id = 6;

SELECT * FROM customers;

-- CHANGE THE SCORE OF THE CUSTOMER 7 TO 507
-- AND UPDATE THE COUNTRY TO UK

UPDATE customers
SET 
    score = 507,
    country = 'UK'
WHERE id = 7;
 

 -- UPDATE ALL CUSTOMERS WITH A NULL SCORE BY SETTING THEIR SCORE TO 0

 UPDATE customers
 SET score = 0
 WHERE score IS NULL;

 SELECT * FROM customers;

 -- DELETE ALL THE CUSTOMER WITH AN ID > 5

 DELETE FROM customers
 WHERE id > 5;

 SELECT * FROM customers;


 -- DELETE ALL THE DATA FROM THE TABLE PERSONS

 --DELETE FROM persons OR

 TRUNCATE TABLE persons;

 SELECT * FROM persons;



 /* ================================= */
            -- FILTERING DATA
/* ================================= */

-- # 1. COMAPARISON OPERATORS --

SELECT * FROM customers;

-- RETRIEVE ALL CUSTOMERS FROM GERMANY

SELECT * FROM customers
WHERE country = 'Germany';

-- RETRIEVE ALL CUSTOMERS WHO ARE NOT  FROM GERMANY

SELECT * FROM customers
WHERE country != 'Germany';

-- RETRIVE ALL CUSTOMERS WITH A SCORE GREATER THAN 500

SELECT * FROM customers
WHERE score > 500;

-- RETRIVE ALL CUSTOMERS WITH A SCORE 500 and more

SELECT * FROM customers
WHERE score >= 500;

-- RETRIVE ALL CUSTOMERS WITH A SCORE LESSER THAN 500

SELECT * FROM customers
WHERE score < 500;

-- RETRIVE ALL CUSTOMERS WITH A SCORE 500 and LESS

SELECT * FROM customers
WHERE score <= 500;


-- #2. LOGICAL OPERATORS (AND , OR , NOT) --

/* RETRIEVE ALL CUSTOMERS WHO ARE FROM THE USA AND 
 HAVE A SCORE GREATER THAN 500 */

 SELECT * FROM customers
 WHERE country = 'USA' AND score > 500;

 /* RETRIEVE ALL CUSTOMERS WHO ARE FROM THE USA 
  OR HAVE A SCORE GREATER THAN 500 */

 SELECT * FROM customers
 WHERE country = 'USA' OR score > 500;

 /* RETRIVE ALL CUSTOMERS WITH A SCORE NOT LESS THAN 500 */

 SELECT * FROM customers 
 WHERE  NOT score < 500;

 SELECT * FROM customers 
 WHERE score >= 500;


 -- #3. RANGE OPERATORS (BETWEEN)  --

 /* RETRIEVE ALL CUSTOMERS WHOSE SCORE FALLA IN THE RANGE BETWEEN
 100 AND 500 */ 

 SELECT * FROM customers
 WHERE score BETWEEN 100 AND 500;

 SELECT * FROM customers
 WHERE score >= 300 AND score <= 500;

 -- #3. MEMBERSHIP OPERATORS (IN , NOT IN) --

 /* RETRIEVE ALL THE CUSTOMERS FROM EITHER GERMANY OR USA*/

 SELECT * FROM customers
 WHERE country = 'Germany' OR country = 'USA';

 -- instead use IN 
 SELECT * FROM customers
 WHERE country IN ('Germany', 'USA');

 /* RETRIEVE ALL THE CUSTOMERS FROM NEITHER GERMANY NOR from USA*/

 SELECT * FROM customers
 WHERE country  NOT IN ('Germany', 'USA');


 -- # 4.SEARCH OPERATORS (LIKE)

 --FIND ALL CUSTOMER WHOSE NAME STARTS  WITH 'M'

 SELECT * FROM customers
 WHERE first_name LIKE 'M%';

--FIND ALL CUSTOMER WHOSE NAME ENDS  WITH 'M'

SELECT * FROM customers
WHERE first_name LIKE '%n';


--FIND ALL CUSTOMER WHOSE NAME CONTAINS  'r'

SELECT * FROM customers
WHERE first_name LIKE '%r%';

-- --FIND ALL CUSTOMER WHOSE NAME HAS 'r' IN THE 3RD POSITION

SELECT * FROM customers
WHERE first_name LIKE '__r%';








