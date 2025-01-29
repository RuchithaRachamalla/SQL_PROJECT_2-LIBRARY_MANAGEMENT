SELECT * FROM MEMBERS
SELECT * FROM BRANCH
SELECT * FROM EMPLOYEE
SELECT * FROM BOOKS
SELECT * FROM ISSUED_STATUS
SELECT * FROM RETURN_STATUS

--PROJECT TASKS

--Task 1. Create a New Book Record -- '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO BOOKS VALUES('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00, 'yes','Harper Lee','J.B. Lippincott & Co.')
SELECT * FROM BOOKS

--Task 2: Update an Existing Member's Address "123 Main St" TO "125 Main St"
 
UPDATE MEMBERS
SET MEMBER_ADDRESS = '125 Main St'
WHERE MEMBER_ID = 'C101'
SELECT * FROM MEMBERS

--Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID='IS121'
SELECT * FROM ISSUED_STATUS

--Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT ISSUED_BOOK_NAME FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID='E101'

--Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT ISSUED_EMP_ID,
       COUNT(*)
       FROM ISSUED_STATUS
GROUP BY 1
HAVING COUNT(*) > 1

--CTAS (Create Table As Select)
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

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

--Data Analysis & Findings
--The following SQL queries were used to address specific questions:

--Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM BOOKS
WHERE CATEGORY='Classic'

--Task 8: Find Total Rental Income by Category:

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

--Task 9:List Members Who Registered in the Last 180 Days

SELECT * FROM MEMBERS
WHERE REG_DATE >= CURRENT_DATE-INTERVAL '180 days'

INSERT INTO MEMBERS VALUES('C120','Ruchi','145 Main St','2024-12-30')
INSERT INTO MEMBERS VALUES('C121','Pinky','146 Main St','2024-11-20')

--TasK 10:List Employees with Their Branch Manager's Name and their branch details

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

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold7USD

CREATE TABLE EXPENSIVE_BOOKS
AS
SELECT * FROM BOOKS
WHERE RENTAL_PRICE > 7.00

SELECT * FROM EXPENSIVE_BOOKS

--Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM ISSUED_STATUS as IST
LEFT JOIN
RETURN_STATUS as RS
ON IST.ISSUED_ID = RS.ISSUED_ID
WHERE RS.RETURN_ID IS NULL;

