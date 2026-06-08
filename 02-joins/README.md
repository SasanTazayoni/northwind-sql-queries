# SQL JOINs

JOINs combine rows from two or more tables based on a related column between them.

---

## Types of JOIN

### INNER JOIN (default JOIN)

Returns only rows where there is a match in **both** tables.

```sql
SELECT c.CustomerID, o.OrderID
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;
```

> Customers with no orders will not appear. Orders with no matching customer will not appear.

---

### LEFT JOIN

Returns **all rows from the left table**, and matched rows from the right table. Unmatched right-side columns come back as `NULL`.

```sql
SELECT c.CustomerID, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
```

> Customers with no orders **will** appear, with `NULL` in the order columns.

**Common use — find rows with no match:**

```sql
SELECT c.CustomerID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
```

---

### RIGHT JOIN

Returns **all rows from the right table**, and matched rows from the left table. The mirror image of LEFT JOIN — rarely needed since you can always swap the table order and use LEFT JOIN instead.

```sql
SELECT c.CustomerID, o.OrderID
FROM Orders o
RIGHT JOIN Customers c ON c.CustomerID = o.CustomerID;
```

---

### FULL OUTER JOIN

Returns **all rows from both tables**. Where there is no match, the missing side is `NULL`.

```sql
SELECT c.CustomerID, o.OrderID
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;
```

> Useful for finding unmatched rows on either side in one query.

---

### CROSS JOIN

Returns the **Cartesian product** — every row in the left table paired with every row in the right table. No ON condition.

```sql
SELECT c.CustomerID, e.EmployeeID
FROM Customers c
CROSS JOIN Employees e;
```

> Rarely used in practice. With 91 customers and 9 employees this produces 819 rows.

---

### SELF JOIN

A table joined to **itself**. Useful for hierarchical or comparative data. Requires two aliases.

```sql
SELECT e.FirstName + ' ' + e.LastName AS Employee,
       m.FirstName + ' ' + m.LastName AS Manager
FROM Employees e
LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeID;
```

---

## Joining More Than Two Tables

Chain JOINs one after another. Each JOIN introduces a new table and its ON condition.

```sql
SELECT o.OrderID, c.ContactName, e.FirstName + ' ' + e.LastName AS EmployeeName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID;
```

---

## Aliases

Aliases (`c`, `o`, `od`, etc.) shorten table names and are required when the same table appears more than once.

```sql
FROM Categories c
JOIN Products p   ON c.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
```

Bracket notation `[Order Details]` is needed for table names containing spaces.

---

## ON vs WHERE

| Clause | Purpose |
|--------|---------|
| `ON`   | Defines how the tables are linked — part of the JOIN |
| `WHERE`| Filters the result set after the join has happened |

Putting a filter in `ON` vs `WHERE` produces different results on outer joins:

```sql
-- LEFT JOIN: keeps all customers, only shows orders from 1997
SELECT c.CustomerID, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID AND YEAR(o.OrderDate) = 1997;

-- LEFT JOIN + WHERE: only keeps customers who had an order in 1997 (behaves like INNER JOIN)
SELECT c.CustomerID, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1997;
```

---

## Quick Reference

| JOIN type       | Left-only rows | Right-only rows | Matched rows |
|-----------------|:--------------:|:---------------:|:------------:|
| INNER JOIN      |                |                 | yes          |
| LEFT JOIN       | yes            |                 | yes          |
| RIGHT JOIN      |                | yes             | yes          |
| FULL OUTER JOIN | yes            | yes             | yes          |
| CROSS JOIN      | —              | —               | all pairs    |
