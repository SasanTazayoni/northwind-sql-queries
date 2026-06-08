# Indexing

---

## What is an Index?

An index is a separate data structure the database maintains alongside a table to make lookups faster. Think of it like the index at the back of a book — instead of reading every page to find a topic, you go straight to the page number listed in the index.

Without an index, SQL Server reads every row in the table to find matches (**full table scan**). With an index on the searched column, it jumps directly to the relevant rows (**index seek**).

---

## Why Use Indexes?

- Dramatically speed up `WHERE`, `JOIN`, and `ORDER BY` operations on large tables
- Reduce the amount of data the engine has to read from disk
- Enforce uniqueness (unique indexes)

**The trade-off:** indexes consume storage and slow down `INSERT`, `UPDATE`, and `DELETE` because the index must be updated alongside the table. Don't index every column — index the columns you actually filter or join on.

---

## How Indexes Work (B-Tree)

Most SQL Server indexes use a **B-Tree (Balanced Tree)** structure. Values are stored in sorted order across a tree of pages. Searching is O(log n) — the engine traverses the tree from root to leaf rather than scanning every row.

```
            [M]
           /   \
        [D-G]  [R-T]
        / \      / \
      [D] [G]  [R] [T]   ← leaf pages (actual row pointers)
```

---

## Types of Index

### Clustered Index

Defines the **physical order** of rows on disk. The table *is* the index — the leaf level contains the actual row data. There can only be **one per table**.

```sql
-- Primary keys create a clustered index automatically
CREATE CLUSTERED INDEX IX_Orders_OrderDate
ON Orders (OrderDate);
```

> SQL Server creates a clustered index on the primary key by default.

### Non-Clustered Index

A **separate structure** that contains the indexed column values and pointers back to the full row. A table can have many non-clustered indexes.

```sql
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID);
```

### Unique Index

Enforces that no two rows have the same value in the indexed column(s). Created automatically by a `UNIQUE` constraint.

```sql
CREATE UNIQUE INDEX IX_Products_ProductName
ON Products (ProductName);
```

### Composite Index

An index on **multiple columns**. Column order matters — the index is useful for queries that filter on the leading column(s).

```sql
CREATE INDEX IX_OrderDetails_ProductOrder
ON [Order Details] (ProductID, OrderID);
```

> A query filtering on `ProductID` alone can use this index. A query filtering on `OrderID` alone cannot (it is not the leading column).

### Covering Index (INCLUDE)

Adds extra columns to the index leaf level without making them part of the sort key. Allows the engine to satisfy a query entirely from the index without touching the main table (**index covers the query**).

```sql
CREATE INDEX IX_Orders_CustomerID_Covering
ON Orders (CustomerID)
INCLUDE (OrderDate, Freight);
```

---

## Syntax

```sql
-- Create
CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] INDEX index_name
ON table_name (column1 [ASC | DESC], column2, ...)
[INCLUDE (column3, column4)];

-- Drop
DROP INDEX index_name ON table_name;

-- View indexes on a table
EXEC sp_helpindex 'Orders';

-- or query the catalog
SELECT name, type_desc, is_unique
FROM sys.indexes
WHERE object_id = OBJECT_ID('Orders');
```

---

## Northwind Examples

### Index on a frequently filtered column

`Orders.CustomerID` is joined and filtered constantly. Without an index, every query touching this column scans the whole table.

```sql
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID);

-- This query now uses an index seek instead of a table scan
SELECT OrderID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI';
```

### Composite index for a common JOIN

`[Order Details]` is almost always accessed by `OrderID` and then `ProductID`.

```sql
CREATE NONCLUSTERED INDEX IX_OrderDetails_OrderID_ProductID
ON [Order Details] (OrderID, ProductID);
```

### Covering index for a reporting query

The query below selects `OrderDate` and `Freight` for a given customer. Adding those columns to the index with `INCLUDE` means SQL Server never has to go back to the main table.

```sql
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_Cover
ON Orders (CustomerID)
INCLUDE (OrderDate, Freight);

SELECT CustomerID, OrderDate, Freight
FROM Orders
WHERE CustomerID = 'QUICK';
```

---

## When to Add an Index

| Good candidate                              | Poor candidate                        |
|---------------------------------------------|---------------------------------------|
| Column used in `WHERE` or `JOIN ON` often   | Column rarely used in filters         |
| Column used in `ORDER BY` on large tables   | Very small table (scan is fine)       |
| Foreign key columns                         | Column with very few distinct values (e.g. a boolean) |
| High-read, low-write tables                 | Table with very frequent writes       |

---

## Index Pitfalls

### Over-indexing

Every index adds overhead to writes. A table with 15 indexes on it can be slower to `INSERT` into than an unindexed one.

### Low-selectivity columns

An index on a column like `Discontinued` (only values `0` or `1`) gives the engine almost no help — it still has to read half the table. SQL Server may ignore the index entirely.

### Leading column order in composite indexes

```sql
-- Index on (CustomerID, OrderDate)
-- GOOD — uses the index:
WHERE CustomerID = 'ALFKI'
WHERE CustomerID = 'ALFKI' AND OrderDate > '1997-01-01'

-- BAD — cannot use the index efficiently:
WHERE OrderDate > '1997-01-01'   -- skips the leading column
```

### Implicit conversions break indexes

```sql
-- CustomerID is NCHAR(5). Passing a plain string causes a type conversion
-- that prevents an index seek:
WHERE CustomerID = N'ALFKI'   -- correct, uses N prefix for Unicode
WHERE CustomerID = 'ALFKI'    -- may trigger a conversion and scan
```

---

## Checking Whether an Index is Being Used

Use `SET STATISTICS IO ON` to see logical reads, or view the **execution plan** in SSMS (Ctrl+M). An **Index Seek** is efficient; a **Table Scan** or **Index Scan** means the index is not being used or doesn't exist.

```sql
SET STATISTICS IO ON;

SELECT OrderID, OrderDate
FROM Orders
WHERE CustomerID = 'ALFKI';

SET STATISTICS IO OFF;
-- Look for "logical reads" in the Messages tab — fewer is better
```

---

## Quick Reference

| Type              | Physical order | Per table   | Best for                          |
|-------------------|:--------------:|:-----------:|-----------------------------------|
| Clustered         | Yes            | 1 only      | Primary key, range scans          |
| Non-clustered     | No             | Many        | Foreign keys, filtered columns    |
| Unique            | No             | Many        | Enforcing uniqueness              |
| Composite         | No             | Many        | Multi-column filters/joins        |
| Covering (INCLUDE)| No             | Many        | Eliminating key lookups           |
