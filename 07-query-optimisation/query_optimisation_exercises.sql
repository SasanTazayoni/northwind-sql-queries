-- ============================================================
-- 1. Basic Filter
-- Improve the performance of this query.
-- Hint: add an index and remove the wildcard
-- ============================================================

-- Question:
SELECT *
FROM Orders
WHERE CustomerID = 'ALFKI';

-- Answer:
CREATE INDEX IX_Orders_CustomerID
ON Orders (CustomerID);

SELECT OrderID
FROM Orders
WHERE CustomerID = 'ALFKI';

-- ============================================================
-- 2. Function Issue
-- Improve the performance of this query.
-- Hint: tighten the filter to avoid wrapping the column in a function
-- ============================================================

-- Question:
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 1997;

-- Answer:
SELECT OrderID
FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01';

-- ============================================================
-- 3. Sorting Bottleneck
-- Improve the performance of this query.
-- Hint: create an index to avoid a table scan on the ORDER BY
-- ============================================================

-- Question:
SELECT *
FROM Orders
WHERE CustomerID = 'ALFKI'
ORDER BY OrderDate;

-- Answer:
CREATE INDEX IDX_Orders_CustomerID_OrderDate ON Orders(CustomerID, OrderDate);

SELECT CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI'
ORDER BY OrderDate;

-- ============================================================
-- 4. JOIN Performance
-- Improve the performance of this query.
-- Hint: create indexes to enable index seeks on the JOIN
-- ============================================================

-- Question:
SELECT *
FROM Orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID;

-- Answer:
CREATE INDEX IDX_Orders_CustomerID ON Orders(CustomerID);
CREATE INDEX IDX_Customers_CustomerID ON Customers(CustomerID);

SELECT c.ContactName, o.OrderID, o.CustomerID
FROM Orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID;

-- ============================================================
-- 5. Covering Index
-- Improve the performance of this query.
-- Hint: avoid key lookups by creating a covering index using INCLUDE
-- ============================================================

-- Question:
SELECT CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI';

-- Answer:
CREATE INDEX IDX_Orders_CustomerID ON Orders(CustomerID) INCLUDE (OrderDate);

SELECT CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI';

-- ============================================================
-- 6. Aggregation
-- Improve the performance of this query.
-- Hint: create an index to support the GROUP BY
-- ============================================================

-- Question:
SELECT CustomerID, COUNT(*)
FROM Orders
GROUP BY CustomerID;

-- Answer:
CREATE INDEX IDX_Orders_CustomerID ON Orders(CustomerID);

SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID;

-- ============================================================
-- 7. Broken Search Pattern
-- Improve the performance of this query.
-- Hint: remove the leading wildcard as it prevents index use
-- ============================================================

-- Question:
SELECT *
FROM Customers
WHERE CompanyName LIKE '%market%';

-- Answer:
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE CompanyName LIKE 'market%';
