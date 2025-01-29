# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `LIBRARY_MANAGEMENT`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/RuchithaRachamalla/SQL_PROJECT_2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/RuchithaRachamalla/SQL_PROJECT_2/blob/main/ERD.png)

- **Database Creation**: Created a database named `LIBRARY_MANAGEMENT`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
/* CREATING DATABASE */

CREATE DATABASE LIBRARY_MANAGEMENT

/* CREATING BRANCH TABLE */

DROP TABLE IF EXISTS BRANCH
CREATE TABLE BRANCH
    (
	   BRANCH_ID VARCHAR(10) PRIMARY KEY, --SHOULD BE NOT NULL AND UNIQUE
	   MANAGER_ID VARCHAR(10),
	   BRANCH_ADDRESS VARCHAR(50),
	   CONTACT_NO VARCHAR(20)
	)

/* CREATING EMPLOYEE TABLE */

DROP TABLE IF EXISTS EMPLOYEE
CREATE TABLE EMPLOYEE
    (
	   EMP_ID VARCHAR(10) PRIMARY KEY, --SHOULD BE NOT NULL AND UNIQUE
	   EMP_NAME VARCHAR(30),
	   POSITION VARCHAR(15),
	   SALARY INT,
	   BRANCH_ID VARCHAR(25),
	   FOREIGN KEY(BRANCH_ID) REFERENCES BRANCH(BRANCH_ID) 
	)

/* CREATING BOOKS TABLE */

DROP TABLE IF EXISTS BOOKS
CREATE TABLE BOOKS
    (
	    ISBN VARCHAR(20) PRIMARY KEY, --SHOULD BE NOT NULL AND UNIQUE
		BOOKS_TITLE VARCHAR(70),
		CATEGORY VARCHAR(20),
		RENTAL_PRICE FLOAT,
		STATUS VARCHAR(20),
		AUTHOR VARCHAR(30),
		PUBLISHER VARCHAR(60)
	)

/* CREATING MEMBERS TABLE */

DROP TABLE IF EXISTS MEMBERS
CREATE TABLE MEMBERS
    (
	   MEMBER_ID VARCHAR(10) PRIMARY KEY, --SHOULD BE NOT NULL AND UNIQUE
       MEMBER_NAME VARCHAR(25),
	   MEMBER_ADDRESS VARCHAR(75),
	   REG_DATE DATE
	)

/* CREATING ISSUED_STATUS TABLE */

DROP TABLE IF EXISTS ISSUED_STATUS
CREATE TABLE ISSUED_STATUS
    (
       ISSUED_ID VARCHAR(10) PRIMARY KEY, --SHOULD BE NOT NULL AND UNQUIE
	   ISSUED_MEMBER_ID VARCHAR(10), 
	   ISSUED_BOOK_NAME VARCHAR(80),
	   ISSUED_DATE DATE,
	   ISSUED_BOOK_ISBN VARCHAR(30), 
	   ISSUED_EMP_ID VARCHAR(10),
	   FOREIGN KEY(ISSUED_MEMBER_ID) REFERENCES MEMBERS(MEMBER_ID),
	   FOREIGN KEY(ISSUED_BOOK_ISBN) REFERENCES BOOKS(ISBN),
	   FOREIGN KEY(ISSUED_EMP_ID) REFERENCES EMPLOYEE(EMP_ID)
	)

/* CREATING RETURN_STATUS TABLE */

DROP TABLE IF EXISTS RETURN_STATUS
CREATE TABLE RETURN_STATUS
    (
       RETURN_ID VARCHAR(10) PRIMARY KEY, --SHOULD BE NOT NULL AND UNIQUE
	   ISSUED_ID VARCHAR(10), 
	   RETURN_BOOK_NAME VARCHAR(80),
	   RETURN_DATE DATE,
	   RETURN_BOOK_ISBN VARCHAR(20),
	   FOREIGN KEY(ISSUED_ID) REFERENCES ISSUED_STATUS(ISSUED_ID) 
    )

```
### Insert data into tables
### 2. CRUD Operations

- **Create**: Inserted sample records into the `BOOKS` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `EMPLOYEE` table.
- **Delete**: Removed records from the `MEMBERS` table as needed.

**Task 1. Create a New Book Record**
 -- ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

```sql
INSERT INTO BOOKS VALUES('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00, 'yes','Harper Lee','J.B. Lippincott & Co.')
SELECT * FROM BOOKS
```

**Task 2: Update an Existing Member's Address "123 Main St" TO "125 Main St"**
 
 ```sql
UPDATE MEMBERS
SET MEMBER_ADDRESS = '125 Main St'
WHERE MEMBER_ID = 'C101'
SELECT * FROM MEMBERS
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID='IS121'
SELECT * FROM ISSUED_STATUS
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql
SELECT ISSUED_BOOK_NAME FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID='E101'
```

**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT ISSUED_EMP_ID,
       COUNT(*)
       FROM ISSUED_STATUS
GROUP BY 1
HAVING COUNT(*) > 1
```

**CTAS (Create Table As Select)**
**Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE BOOK_CNTS
AS
SELECT 
   B.ISBN,
   B.BOOKS_TITLE,
   COUNT(IST.ISSUED_ID) AS NO_ISSUED 
FROM BOOKS AS B 
JOIN
ISSUED_STATUS AS IST
ON IST.ISSUED_BOOK_ISBN=B.ISBN
GROUP BY 1,2

SELECT * FROM BOOK_CNTS
```

**Data Analysis & Findings**
--The following SQL queries were used to address specific questions:

**Task 7. Retrieve All Books in a Specific Category:**

```sql
SELECT * FROM BOOKS
WHERE CATEGORY='Classic'
```

**Task 8: Find Total Rental Income by Category:**

```sql
SELECT CATEGORY,
       SUM(RENTAL_PRICE) AS PRICE
FROM BOOKS
GROUP BY CATEGORY
-- BUT IF THE BOOK ISSUED MORE THAN 1 TIME, SO WE HAVE TO JOIN AND FIND  
SELECT
     B.CATEGORY,
     SUM(B.RENTAL_PRICE)
FROM BOOKS AS B 
JOIN
ISSUED_STATUS AS IST
ON IST.ISSUED_BOOK_ISBN=B.ISBN
GROUP BY 1
```

**Task 9:List Members Who Registered in the Last 180 Days**

```sql
SELECT * FROM MEMBERS
WHERE REG_DATE >= CURRENT_DATE-INTERVAL '180 days'

INSERT INTO MEMBERS VALUES('C120','Ruchi','145 Main St','2024-12-30')
INSERT INTO MEMBERS VALUES('C121','Pinky','146 Main St','2024-11-20')
```

**TasK 10:List Employees with Their Branch Manager's Name and their branch details**

```sql
SELECT 
    E1.*,
    B.MANAGER_ID,
	E2.EMP_NAME AS MANAGER
FROM EMPLOYEE AS E1
JOIN
BRANCH AS B
ON B.BRANCH_ID=E1.BRANCH_ID
JOIN
EMPLOYEE AS E2
ON B.MANAGER_ID=E2.EMP_ID
```

**Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD**

```sql
CREATE TABLE EXPENSIVE_BOOKS
AS
SELECT * FROM BOOKS
WHERE RENTAL_PRICE > 7.00

SELECT * FROM EXPENSIVE_BOOKS
```

**Task 12: Retrieve the List of Books Not Yet Returned**

```sql
SELECT * FROM ISSUED_STATUS as IST
LEFT JOIN
RETURN_STATUS as RS
ON IST.ISSUED_ID = RS.ISSUED_ID
WHERE RS.RETURN_ID IS NULL
```

## Advanced SQL Operations

**Task 13: Identify Members with Over due Books**

--Write a query to identify members who have over due books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days over due.

--ISSUED_BOOKS==MEMBERS==BOOKS==RETUEN_STATUS
--FILTER BOOKS WHICH ARE RETURN
--OVER DUE > 30

```sql
SELECT 
   IST.ISSUED_MEMBER_ID,
   M.MEMBER_NAME,
   B.BOOKS_TITLE,
   IST.ISSUED_DATE,
   CURRENT_DATE-IST.ISSUED_DATE AS OVER_DUES_DAYS
FROM ISSUED_STATUS AS IST
JOIN 
MEMBERS AS M
ON M.MEMBER_ID=IST.ISSUED_MEMBER_ID
JOIN 
BOOKS AS B
ON B.ISBN=IST.ISSUED_BOOK_ISBN
LEFT JOIN
RETURN_STATUS AS RS
ON RS.ISSUED_ID=IST.ISSUED_ID
WHERE 
RS.RETURN_DATE IS NULL 
AND 
(CURRENT_DATE-IST.ISSUED_DATE) > 30
ORDER BY 1
```

**Task 14: Update Book Status on Return**

--Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

```sql
--MANUALLY
SELECT * FROM BOOKS
WHERE ISBN='978-0-451-52994-2'

UPDATE  BOOKS
SET STATUS='no'
WHERE ISBN='978-0-451-52994-2'

SELECT * FROM ISSUED_STATUS
WHERE ISSUED_BOOK_ISBN='978-0-451-52994-2'

SELECT * FROM RETURN_STATUS
WHERE ISSUED_ID='IS130'

INSERT INTO RETURN_STATUS(RETURN_ID,ISSUED_ID,RETURN_DATE,BOOK_QUALITY)
VALUES
('RS125','IS130',CURRENT_DATE,'GOOD')
SELECT * FROM RETURN_STATUS
WHERE ISSUED_ID='IS130'

--WITH SQL STORE PROCEDURES

CREATE OR REPLACE PROCEDURE ADD_RETURN_RECORDS(P_RETURN_ID VARCHAR(10),P_ISSUED_ID VARCHAR(10),P_BOOK_QUALITY VARCHAR(10))
LANGUAGE PLPGSQL
AS $$

DECLARE
   V_ISBN VARCHAR(50);
   V_BOOK_NAME VARCHAR(80);
BEGIN
   --ALL YOUR LOGIC AND CODE
   --INSERTING INTO RETURNS BASED ON USERS INPUT
   INSERT INTO RETURN_STATUS(RETURN_ID,ISSUED_ID,RETURN_DATE,BOOK_QUALITY)
   VALUES
   (P_RETURN_ID,P_ISSUED_ID,CURRENT_DATE,P_BOOK_QUALITY);

   SELECT 
      ISSUED_BOOK_ISBN,
	  ISSUED_BOOK_NAME
	  INTO
	  V_ISBN
	  V_BOOK_NAME
   FROM ISSUED_STATUS
   WHERE ISSUED_ID=P_ISSUED_ID;
   
   UPDATE  BOOKS
   SET STATUS='YES'
   WHERE ISBN='V_ISBN';

   RAISE NOTICE 'THANK YOU FOR RETURNING THE BOOK:%',V_BOOK_NAME;
   
END;
$$

-- Testing FUNCTION add_return_records

ISSUED_ID = IS135
ISBN = WHERE ISBN = '978-0-307-58837-1'

SELECT * FROM BOOKS
WHERE ISBN = '978-0-307-58837-1'

SELECT * FROM ISSUED_STATUS
WHERE ISSUED_BOOK_ISBN = '978-0-307-58837-1'

SELECT * FROM RETURN_STATUS
WHERE ISSUED_ID = 'IS135'
--CALLING FUNCTIONS
CALL ADD_RETURN_RECORDS('RS138', 'IS135', 'Good')
--CALLING FUNCTIONS
CALL ADD_RETURN_RECORDS('RS148', 'IS140', 'Good')
```

**Task 15: Branch Performance Report**
--Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE BRANCH_REPORTS
AS
SELECT 
    B.BRANCH_ID,
    B.MANAGER_ID,
    COUNT(IST.ISSUED_ID) AS NUMBER_OF_BOOKS_ISSUED,
    COUNT(RS.RETURN_ID) AS NUMBER_OF_BOOKS_RETURNED,
    SUM(BK.RENTAL_PRICE) AS TOTAL_REVENUE
FROM ISSUED_STATUS AS IST
JOIN 
EMPLOYEE AS E
ON E.EMP_ID = IST.ISSUED_EMP_ID
JOIN
BRANCH AS B
ON E.BRANCH_ID = B.BRANCH_ID
LEFT JOIN
RETURN_STATUS AS RS 
ON RS.ISSUED_ID = IST.ISSUED_ID
JOIN 
BOOKS AS BK
ON IST.ISSUED_BOOK_ISBN = BK.ISBN
GROUP BY 1,2

SELECT * FROM BRANCH_REPORTS
```

**Task 16: CTAS: Create a Table of Active Members**

--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql
CREATE TABLE ACTIVE_MEMBERS
AS
SELECT * FROM MEMBERS
WHERE MEMBER_ID IN (SELECT 
                        DISTINCT ISSUED_MEMBER_ID   
                    FROM ISSUED_STATUS
                    WHERE 
                        ISSUED_DATE >= CURRENT_DATE - INTERVAL '2 month'
                    )

SELECT * FROM ACTIVE_MEMBERS
```

**Task 17: Find Employees with the Most Book Issues Processed**

--Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
    E.EMP_NAME,
    B.*,
    COUNT(IST.ISSUED_ID) as NO_BOOK_ISSUED
	FROM ISSUED_STATUS as IST
JOIN
EMPLOYEE as E
ON E.EMP_ID = IST.ISSUED_EMP_ID
JOIN
BRANCH as B
ON E.BRANCH_ID = B.BRANCH_ID
GROUP BY 1,2
```
## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## Author - Ruchitha Rachamalla 

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for your interest in this project!
