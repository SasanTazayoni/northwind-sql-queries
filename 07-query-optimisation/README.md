# Query Optimisation

---

## What is Query Optimisation?

Query optimisation is the process of rewriting or restructuring SQL queries so the database engine can return the correct result with the least amount of work — fewer rows read, less memory used, less CPU time spent.

The SQL Server **Query Optimiser** automatically generates an execution plan for every query. Your job is to write queries that give the optimiser the best chance of choosing an efficient plan, and to recognise patterns that force it into slow ones.

---

## Execution Plans

An execution plan shows exactly what SQL Server did to execute a query — which indexes it used, how it joined tables, how many rows it processed at each step.

### How to view one

In SSMS:
- **Estimated plan** — `Ctrl + L` (doesn't run the query)
- **Actual plan** — `Ctrl + M`, then run the query

Key operators to recognise:

| Operator        | Meaning                                              | Cost   |
|-----------------|------------------------------------------------------|--------|
| Index Seek      | Jumped directly to matching rows via an index        | Low    |
| Index Scan      | Read the entire index                                | Medium |
| Table Scan      | Read every row in the table (no index used)          | High   |
| Key Lookup      | Extra trip back to the base table to fetch columns   | Medium |
| Hash Match      | Join using a hash table (often seen on large tables) | Varies |
| Nested Loops    | Join by iterating — efficient for small row counts   | Varies |
| Sort             | Explicit sort step — avoids if column is indexed     | High   |

Thick arrows between operators mean a large number of rows are being passed — a warning to investigate.

### SET STATISTICS IO

Shows logical reads (pages read from cache). Fewer reads = less work.

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT o.CustomerID, COUNT(o.OrderID) AS Orders
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

---

## Use SELECT Columns, Not SELECT *

`SELECT *` forces the engine to fetch every column, even ones you don't need. It also prevents covering indexes from working.

```sql
-- Bad
SELECT * FROM Orders WHERE CustomerID = 'ALFKI';

-- Good
SELECT OrderID, OrderDate, Freight
FROM Orders
WHERE CustomerID = 'ALFKI';
```

---

## Filter Early with WHERE

The earlier you reduce the row count, the less work every subsequent step has to do. Put the most selective filter first when you have a choice.

```sql
-- Bad — joins all orders, then filters
SELECT o.OrderID, c.CompanyName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany';

-- Good — same query, but consider whether an index on Country exists
-- and make sure the WHERE is present so the engine can apply it before the join
SELECT o.OrderID, c.CompanyName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Germany';
```

---

## Avoid Functions on Indexed Columns in WHERE

Wrapping a column in a function prevents the engine from using an index on it — it must evaluate the function for every row (a scan instead of a seek).

```sql
-- Bad — function on the column, index on OrderDate is not used
SELECT OrderID FROM Orders
WHERE YEAR(OrderDate) = 1997;

-- Good — range condition, index seek is possible
SELECT OrderID FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01';
```

```sql
-- Bad
WHERE UPPER(CompanyName) = 'ALFREDS FUTTERKISTE'

-- Good — store data in consistent case, or use a case-insensitive collation
WHERE CompanyName = 'Alfreds Futterkiste'
```

---

## Avoid Implicit Type Conversions

When the data type of a parameter doesn't match the column, SQL Server converts every value in the column before comparing — killing index usage.

```sql
-- CustomerID is NCHAR(5). Bad — plain string literal causes conversion
WHERE CustomerID = 'ALFKI'

-- Good — N prefix matches the Unicode type
WHERE CustomerID = N'ALFKI'
```

---

## Use EXISTS Instead of COUNT for Existence Checks

`COUNT(*)` scans until it has counted all matching rows. `EXISTS` stops as soon as it finds the first one.

```sql
-- Bad — reads every matching row just to check if any exist
SELECT CustomerID
FROM Customers
WHERE (SELECT COUNT(*) FROM Orders o WHERE o.CustomerID = Customers.CustomerID) > 0;

-- Good — stops at the first match
SELECT CustomerID
FROM Customers c
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID);
```

---

## Avoid SELECT DISTINCT as a Crutch

`DISTINCT` forces a sort and de-duplication step. It often masks a deeper problem — usually a missing JOIN condition that is producing duplicate rows.

```sql
-- Bad — why are there duplicates? Fix the join instead
SELECT DISTINCT c.CustomerID
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Better — if you just need to know which customers have orders, use EXISTS
SELECT CustomerID
FROM Customers c
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID);
```

---

## Use Joins Instead of Subqueries Where Possible

Correlated subqueries re-execute for every row in the outer query. A JOIN typically does the same work once.

```sql
-- Bad — scalar subquery runs once per product row
SELECT ProductName,
    (SELECT CategoryName FROM Categories c WHERE c.CategoryID = p.CategoryID) AS Category
FROM Products p;

-- Good — single pass
SELECT p.ProductName, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;
```

---

## CTEs vs Subqueries vs Temp Tables

All three can produce the same result. Choose based on complexity and size.

| Option       | Best for                                        | Watch out for                         |
|--------------|-------------------------------------------------|---------------------------------------|
| Subquery     | Simple, one-off inline logic                    | Nested too deep = hard to read        |
| CTE          | Readable, multi-step logic; recursive queries   | Re-evaluated each time it's referenced (non-materialised) |
| Temp table   | Large intermediate results used more than once  | Overhead of creating/populating a table |

```sql
-- Temp table — useful when the intermediate result is large and referenced twice
SELECT o.CustomerID,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSpend
INTO #CustomerSpend
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID;

SELECT c.CompanyName, cs.TotalSpend
FROM Customers c
JOIN #CustomerSpend cs ON c.CustomerID = cs.CustomerID
WHERE cs.TotalSpend > 5000;

DROP TABLE #CustomerSpend;
```

---

## Avoid OR on Indexed Columns — Use UNION ALL

`OR` between indexed columns often forces a scan. Splitting into two seeks with `UNION ALL` can be faster.

```sql
-- May cause a scan
SELECT OrderID FROM Orders
WHERE CustomerID = 'ALFKI' OR CustomerID = 'QUICK';

-- Two seeks merged — often faster on large tables
SELECT OrderID FROM Orders WHERE CustomerID = 'ALFKI'
UNION ALL
SELECT OrderID FROM Orders WHERE CustomerID = 'QUICK';
```

---

## Paging Large Result Sets

Returning all rows and filtering in the application is wasteful. Use `OFFSET / FETCH` to page at the database level.

```sql
-- Page 3, 10 rows per page
SELECT CustomerID, CompanyName
FROM Customers
ORDER BY CustomerID
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;
```

---

## Northwind: Comparing a Slow and Fast Version

**Scenario** — total revenue per category, filtered to categories with more than £20,000 revenue.

```sql
-- Slow version
-- • SELECT * brings back every column
-- • Function on UnitPrice prevents any potential index use on that column
-- • No alias clarity
SELECT DISTINCT Categories.CategoryName,
    ROUND(SUM([Order Details].UnitPrice * [Order Details].Quantity), 2) AS Revenue
FROM Categories, Products, [Order Details]
WHERE Categories.CategoryID = Products.CategoryID
AND Products.ProductID = [Order Details].ProductID
HAVING Revenue > 20000;
```

```sql
-- Optimised version
-- • Explicit JOINs, selective column list
-- • Discount applied correctly
-- • HAVING uses the aggregate expression directly
SELECT c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Categories c
JOIN Products p        ON c.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID  = od.ProductID
GROUP BY c.CategoryName
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 20000
ORDER BY Revenue DESC;
```

---

## Optimisation Checklist

| Check | Why |
|-------|-----|
| Is there an index on every `JOIN` and `WHERE` column? | Avoids table scans |
| Does `SELECT` list only the columns needed? | Enables covering indexes, reduces I/O |
| Are there functions wrapping indexed columns in `WHERE`? | Breaks index seeks |
| Could `EXISTS` replace a `COUNT > 0` check? | Stops at first match |
| Are `DISTINCT` results masking a bad join? | Fix the root cause |
| Are correlated subqueries replaceable with joins or CTEs? | Reduces repeated execution |
| Is a large intermediate result reused? | Consider a temp table |
| Is the full result set returned when only a page is needed? | Use OFFSET / FETCH |
