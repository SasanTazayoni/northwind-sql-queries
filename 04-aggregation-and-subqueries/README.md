# Aggregation & Subqueries

---

## Aggregate Functions

Aggregate functions compute a single result from a set of rows.

| Function  | Description                        |
|-----------|------------------------------------|
| `COUNT()`  | Number of rows                     |
| `SUM()`    | Total of a numeric column          |
| `AVG()`    | Average of a numeric column        |
| `MIN()`    | Smallest value                     |
| `MAX()`    | Largest value                      |

```sql
SELECT
    COUNT(OrderID)                                        AS TotalOrders,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2)  AS TotalRevenue,
    ROUND(AVG(UnitPrice), 2)                              AS AvgUnitPrice,
    MIN(UnitPrice)                                        AS CheapestProduct,
    MAX(UnitPrice)                                        AS MostExpensiveProduct
FROM [Order Details];
```

### COUNT(*) vs COUNT(column)

```sql
COUNT(*)           -- counts every row, including NULLs
COUNT(CustomerID)  -- counts only non-NULL values in that column
```

---

## GROUP BY

`GROUP BY` splits rows into groups and applies an aggregate to each group.

```sql
SELECT CustomerID,
    COUNT(OrderID)                                       AS NumberOfOrders,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalSpend
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY CustomerID
ORDER BY TotalSpend DESC;
```

> Every column in `SELECT` that is **not** inside an aggregate function must appear in `GROUP BY`.

### Grouping by multiple columns

```sql
SELECT c.CategoryName, p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Categories c
JOIN Products p        ON c.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID  = od.ProductID
GROUP BY c.CategoryName, p.ProductName
ORDER BY c.CategoryName, Revenue DESC;
```

---

## HAVING

`HAVING` filters **groups** after aggregation. Use it where you would use `WHERE` but need to reference an aggregate.

```sql
SELECT CustomerID,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalSpend
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY CustomerID
HAVING SUM(UnitPrice * Quantity * (1 - Discount)) > 10000
ORDER BY TotalSpend DESC;
```

### WHERE vs HAVING

| Clause   | Runs          | Can reference aggregates |
|----------|---------------|--------------------------|
| `WHERE`  | Before GROUP BY | No                     |
| `HAVING` | After GROUP BY  | Yes                    |

```sql
-- WHERE filters rows before grouping; HAVING filters groups after
SELECT CategoryID,
    COUNT(ProductID) AS ProductCount
FROM Products
WHERE Discontinued = 0          -- filter rows first
GROUP BY CategoryID
HAVING COUNT(ProductID) > 5;    -- then filter groups
```

---

## Subqueries

A subquery is a query nested inside another query. It is always wrapped in parentheses.

### In WHERE

```sql
-- Products priced above the average unit price
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);
```

### In FROM (derived table)

The subquery acts as a temporary table. It must be given an alias.

```sql
SELECT CustomerID, TotalSpend
FROM (
    SELECT o.CustomerID,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSpend
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
) AS CustomerSpend
WHERE TotalSpend > 5000;
```

### In SELECT (scalar subquery)

Returns a single value per row. Can be slow on large tables — a JOIN is often preferable.

```sql
SELECT ProductName,
    UnitPrice,
    (SELECT AVG(UnitPrice) FROM Products) AS AvgPrice,
    UnitPrice - (SELECT AVG(UnitPrice) FROM Products) AS DiffFromAvg
FROM Products;
```

---

## Correlated Subqueries

A correlated subquery references a column from the outer query, so it re-executes for each row.

```sql
-- Customers whose total spend is above the average spend across all customers
SELECT CustomerID
FROM Orders o
WHERE (
    SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
    FROM [Order Details] od
    WHERE od.OrderID IN (
        SELECT OrderID FROM Orders WHERE CustomerID = o.CustomerID
    )
) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(od2.UnitPrice * od2.Quantity * (1 - od2.Discount)) AS CustomerTotal
        FROM Orders o2
        JOIN [Order Details] od2 ON o2.OrderID = od2.OrderID
        GROUP BY o2.CustomerID
    ) AS Totals
);
```

> Correlated subqueries are powerful but can be slow. A CTE or derived table often performs better.

---

## EXISTS and NOT EXISTS

`EXISTS` returns true if the subquery produces at least one row. Stops as soon as a match is found — efficient for existence checks.

```sql
-- Customers who have placed at least one order
SELECT CustomerID, CompanyName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);

-- Customers who have never placed an order
SELECT CustomerID, CompanyName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);
```

---

## Common Table Expressions (CTEs)

A CTE defines a named, temporary result set with `WITH`. It makes complex subquery logic easier to read and reuse within the same query.

```sql
WITH CustomerSpend AS (
    SELECT o.CustomerID,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSpend
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
)
SELECT c.CompanyName, cs.TotalSpend
FROM Customers c
JOIN CustomerSpend cs ON c.CustomerID = cs.CustomerID
WHERE cs.TotalSpend > 5000
ORDER BY cs.TotalSpend DESC;
```

### Chaining multiple CTEs

```sql
WITH CategoryRevenue AS (
    SELECT c.CategoryName,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
    FROM Categories c
    JOIN Products p        ON c.CategoryID = p.CategoryID
    JOIN [Order Details] od ON p.ProductID  = od.ProductID
    GROUP BY c.CategoryName
),
AvgRevenue AS (
    SELECT AVG(Revenue) AS Avg
    FROM CategoryRevenue
)
SELECT CategoryName, Revenue
FROM CategoryRevenue, AvgRevenue
WHERE Revenue > Avg
ORDER BY Revenue DESC;
```

---

## Quick Reference

| Concept          | Key point |
|------------------|-----------|
| `GROUP BY`       | Every non-aggregate `SELECT` column must be listed here |
| `HAVING`         | Filters groups — use instead of `WHERE` when referencing an aggregate |
| Subquery in `WHERE` | Returns a value or list to compare against |
| Derived table    | Subquery in `FROM` — must have an alias |
| Correlated subquery | References the outer query — re-runs per row |
| `EXISTS`         | Efficient existence check — use `SELECT 1` inside |
| CTE              | Named subquery defined with `WITH` — improves readability |
