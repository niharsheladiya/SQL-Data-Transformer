-- SQLBook: Code
-- Welcome to Data Transformer Project


SHOW DATABASES;


CREATE DATABASE DataTransformer;


SHOW DATABASES;


USE DataTransformer;



DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;





-- 1) Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    RegistrationDate DATE
);





-- 2) Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);








-- 3) Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);









-- SECTION 1 : SAMPLE DATA  


INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
(1, 'John', 'Doe',   'john.doe@email.com',   '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');


INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
(1, 'Mark',  'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee',     'HR',    '2021-03-20', 55000.00);









-- SECTION 2 : QUERIES TO PERFORM


--1:- INNER JOIN
SELECT o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.RegistrationDate
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID;
        







--2:- LEFT JOIN
SELECT c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.RegistrationDate,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID;







--3:- RIGHT JOIN
SELECT o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.RegistrationDate
FROM Customers c
RIGHT JOIN Orders o
    ON c.CustomerID = o.CustomerID







--4:- FULL OUTER JOIN
SELECT c.CustomerID AS CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.RegistrationDate,
    o.OrderID,
    o.CustomerID AS OrderCustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID

UNION

SELECT c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.RegistrationDate,
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o
    ON c.CustomerID = o.CustomerID;






--5:- SUBQUERY CUSTOMERS
SELECT c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.RegistrationDate
FROM Customers c
WHERE c.CustomerID IN (
            SELECT o.CustomerID
            FROM Orders o
            WHERE o.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
        );







---6:- SUBQUERY EMPLOYEES

SELECT EmployeeID,
    FirstName,
    LastName,
    Department,
    HireDate,
    Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);








--7:- DATE FUNCTION
SELECT OrderID,
    OrderDate,
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    MONTHNAME(OrderDate) AS OrderMonthName
FROM Orders;







--8:- DATE FUNCTION
SELECT OrderID,
    OrderDate,
    CURDATE() AS CurrentDate,
    DATEDIFF(CURDATE(), OrderDate) AS DaysSinceOrder
FROM Orders;







--9:- DATE FORMATTING
SELECT OrderID,
    OrderDate,
    DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedOrderDate   
FROM Orders;








--10:- STRING FUNCTION

-- Customers
SELECT CustomerID,
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;




-- Employees
SELECT EmployeeID,
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;










--11:- STRING FUNCTION
SELECT CustomerID,
    FirstName AS OriginalFirstName,
    REPLACE(FirstName, 'John', 'Jonathan') AS NewFirstName
FROM Customers;








--12:- STRING FUNCTION
-- Customers
SELECT CustomerID,
    UPPER(FirstName) AS FirstNameUpper,
    LOWER(LastName) AS LastNameLower
FROM Customers;

-- Employees
SELECT EmployeeID,
    UPPER(FirstName) AS FirstNameUpper,
    LOWER(LastName)  AS LastNameLower
FROM Employees;







--13:- STRING FUNCTION
SELECT CustomerID,
    Email AS OriginalEmail,
    TRIM(Email) AS TrimmedEmail,
    LENGTH(Email) AS LengthBefore,
    LENGTH(TRIM(Email))  AS LengthAfter
FROM Customers;








--14:- WINDOW FUNCTION
SELECT OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RunningTotal
FROM Orders
ORDER BY OrderDate, OrderID;







--15:- WINDOW FUNCTION
SELECT OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM Orders
ORDER BY AmountRank;






--16:- CASE EXPRESSION
SELECT OrderID,
    CustomerID,
    TotalAmount,
        CASE
            WHEN TotalAmount > 1000 THEN 10
            WHEN TotalAmount > 500  THEN 5
            ELSE 0
        END AS DiscountPercent,
        ROUND(TotalAmount * CASE
                                WHEN TotalAmount > 1000 THEN 0.10
                                WHEN TotalAmount > 500  THEN 0.05
                                ELSE 0
                            END , 2) AS DiscountAmount,
        ROUND(TotalAmount * (1 - CASE
                                WHEN TotalAmount > 1000 THEN 0.10
                                WHEN TotalAmount > 500  THEN 0.05
                                ELSE 0
                            END) , 2) AS FinalAmount
FROM Orders;







--17:- CASE EXPRESSION
SELECT EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
        CASE
            WHEN Salary >= 60000 THEN 'High'
            WHEN Salary >= 40000 THEN 'Medium'
            ELSE 'Low'
        END AS SalaryCategory
FROM Employees;




















