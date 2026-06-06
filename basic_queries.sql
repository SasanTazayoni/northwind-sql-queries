-- 1. List all customers from Germany
SELECT * FROM Customers
WHERE Country = 'Germany';

-- 2. Show all products that cost more than 20
SELECT * FROM Products
WHERE UnitPrice > 20;

-- 3. Display the first name, last name and city of all employees
SELECT FirstName, LastName, City FROM Employees;

-- 4. List all products that are out of stock
SELECT * FROM Products
WHERE UnitsInStock = 0;

-- 5. Show all orders shipped to France
SELECT * FROM Orders
WHERE ShipCountry = 'France';

-- 6. List all customers whose city starts with the letter 'B'
SELECT * FROM Customers
WHERE City LIKE 'B%';

-- 7. Display all products stored in jars or bottles
SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%jars'
   OR QuantityPerUnit LIKE '%bottles';

-- 8. Show all employees born after 1960
SELECT * FROM Employees
WHERE BirthDate > '1960-12-31';

-- 9. List all products ordered by UnitPrice from highest to lowest
SELECT * FROM Products
ORDER BY UnitPrice DESC;

-- 10. Show the company name and contact name for customers in London or Madrid
SELECT CompanyName, ContactName, City FROM Customers
WHERE City = 'London' OR City = 'Madrid';
