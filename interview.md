# Interview Questions & Answers

Interview-ready answers for data and database fundamentals. Kept punchy and memorable; the SQL topics are taught in depth across this repo's numbered folders ([01-data-modelling](01-data-modelling/README.md) → [07-query-optimisation](07-query-optimisation/README.md)). MongoDB and data-pipeline topics appear here too for completeness — they're covered hands-on in the sibling `starwars-mongodb-and-cloud-computing` and `AMI-Amigos-Cloud-Project` repos.

Each answer follows the same shape: a one-line framing summary, supporting points, and a **Remember:** hook to lock it in.

## Contents

**Data fundamentals**

- [What makes data good quality?](#what-makes-data-good-quality)
- [What is the difference between data analysis and data engineering?](#what-is-the-difference-between-data-analysis-and-data-engineering)
- [What is OLTP and what is OLAP?](#what-is-oltp-and-what-is-olap)
- [What is an API, and why is the JSON format so popular?](#what-is-an-api-and-why-is-the-json-format-so-popular)
- [What is ACID?](#what-is-acid)
- [Why is Python the go-to language for data professionals?](#why-is-python-the-go-to-language-for-data-professionals)

**Relational databases & SQL**

- [What type of database is SQL and MongoDB, and why would you use each?](#what-type-of-database-is-sql-and-mongodb-and-why-would-you-use-each)
- [Why use SQL, and why is it so popular?](#why-use-sql-and-why-is-it-so-popular)
- [What is the difference between a primary key and a foreign key?](#what-is-the-difference-between-a-primary-key-and-a-foreign-key)
- [What is normalisation?](#what-is-normalisation)
- [What are the different types of SQL JOIN?](#what-are-the-different-types-of-sql-join)
- [What is the difference between WHERE and HAVING?](#what-is-the-difference-between-where-and-having)
- [Why use subqueries?](#why-use-subqueries)
- [What is a CTE, and how does it compare to a subquery?](#what-is-a-cte-and-how-does-it-compare-to-a-subquery)
- [What is a window function?](#what-is-a-window-function)
- [What is an index, and why does it matter?](#what-is-an-index-and-why-does-it-matter)

**NoSQL & MongoDB**

- [How do you store data in MongoDB?](#how-do-you-store-data-in-mongodb)
- [How do relationships work in MongoDB?](#how-do-relationships-work-in-mongodb)

**Data pipelines**

- [Explain a basic ETL workflow involving MongoDB](#explain-a-basic-etl-workflow-involving-mongodb)
- [What is an ETL pipeline vs ELT? When would you use each?](#what-is-an-etl-pipeline-vs-elt-when-would-you-use-each)
- [What is idempotency, and why does it matter in data pipelines?](#what-is-idempotency-and-why-does-it-matter-in-data-pipelines)
- [Why is automation important?](#why-is-automation-important)

---

## Data fundamentals

### What makes data good quality?

**Good-quality data is data you can trust to make a decision — and a data engineer's job is to catch quality problems in the pipeline before they reach analysts or models.**

- **Accurate:** reflects reality correctly, with no incorrect values
- **Complete:** no missing fields that should be present
- **Consistent:** the same entity is represented the same way everywhere, with no conflicting records
- **Timely:** current enough to be useful for the decision being made
- **Valid:** values fall within expected ranges and formats
- **Unique:** no unintended duplication of records

> **Remember:** accurate, complete, consistent, timely, valid, unique. Poor data quality is invisible until it causes a wrong decision — which is exactly why catching it in the pipeline is a core part of the data engineer's job.

### What is the difference between data analysis and data engineering?

**Data engineering builds the systems that deliver reliable data; data analysis interprets that data to answer business questions. One asks "how do we get good data here," the other asks "what does the data tell us."**

**Data engineering** — building and maintaining the systems that collect, move, and store data: pipelines, infrastructure, warehouses.

- Focused on getting reliable data to where it's needed, at scale
- Typically works with Python, SQL, cloud infrastructure, and pipeline tooling

**Data analysis** — querying and interpreting data to answer business questions: trends, patterns, insights, visualisations.

- Focused on what the data means and what decisions it supports
- Typically works with SQL, BI tools like Tableau or Power BI, and statistical interpretation

> **Remember:** engineer builds the pipes and makes the data trustworthy; analyst reads the data and extracts meaning. In practice the line is blurry — engineers write analytical queries, and analysts increasingly need to understand pipelines.

### What is OLTP and what is OLAP?

**Two complementary database workloads — OLTP runs the day-to-day operations (recording transactions), while OLAP analyses the accumulated data for insight. Most data pipelines move data from one to the other.**

**OLTP (Online Transaction Processing)** — handles large numbers of short, fast transactions in real time. _Examples: PostgreSQL, MySQL, bank payment systems_

- Records individual events as they happen — inserts, updates, deletes
- Optimised for speed and accuracy on individual records
- This is the operational, "live" database that runs the application

**OLAP (Online Analytical Processing)** — designed for complex queries across large volumes of historical data. _Examples: Redshift, Snowflake, BigQuery_

- Analyses patterns across millions of transactions rather than recording them
- Optimised for reading and aggregating large datasets, not fast single-record writes
- This is the analytical database that powers reporting, dashboards, and business intelligence

> **Remember:** OLTP writes the data (fast, small, real-time — running the business); OLAP reads it (heavy, aggregated, historical — understanding the business). A common data-engineering job is moving data from OLTP systems into an OLAP warehouse via ETL/ELT.

### What is an API, and why is the JSON format so popular?

**An API (Application Programming Interface) is a defined way for two systems to communicate — and JSON is the format they most often use to exchange the data, because it's lightweight, readable, and works across every language.**

**API (Application Programming Interface)** — a defined contract for how two systems talk to each other. It specifies what requests you can make, what format to send them in, and what to expect back.

- Lets systems communicate without knowing each other's internal workings — you use the interface, not the implementation
- REST APIs are the common style: send an HTTP request to a URL and get data back, usually as JSON
- This is how modern applications and services integrate — and how data pipelines pull data from external sources

**Why JSON is so popular:**

- Lightweight, human-readable, and language-agnostic
- Almost every programming language can parse and generate it natively
- Maps naturally to objects and arrays — the basic data structures in most languages
- Simpler and less verbose than XML
- It's the default format for REST APIs, so it's everywhere in modern data pipelines

> **Remember:** an API is the contract for how systems talk; JSON is the language they usually speak. JSON won because it's readable, universal, and maps straight onto the objects and arrays programmers already use.

### What is ACID?

**ACID is a set of four properties that guarantee database transactions are processed reliably even when things go wrong — a crash, a power failure, or many users hitting the database at once.**

- **Atomicity:** a transaction is all or nothing. Either every operation completes or none do. If the system crashes halfway through, the database rolls back to the state before the transaction started
- **Consistency:** a transaction can only move the database from one valid state to another. All schema constraints and relationships must hold before and after; a transaction that would violate one is rejected entirely
- **Isolation:** concurrent transactions execute as if run one at a time. One transaction's changes aren't visible to others until committed, which prevents dirty reads (seeing another transaction's uncommitted changes)
- **Durability:** once committed, a transaction stays committed. Even if the system crashes immediately after, the data survives — achieved through write-ahead logging, where changes are written to a log before being applied

Why it matters for data engineering: a standard data lake on S3 has no ACID guarantees — two writers can corrupt the same file simultaneously, and a failed job can leave partial data behind. Delta Lake, Apache Iceberg, and Apache Hudi all exist specifically to add ACID compliance on top of cheap object storage.

> **Remember:** Atomicity, Consistency, Isolation, Durability — the guarantees that let you trust a database when things go wrong. Saying a system is "ACID compliant" means it can be trusted even under crashes and concurrency. It's also the key thing traditional SQL databases give you that a raw data lake doesn't.

### Why is Python the go-to language for data professionals?

**Python combines simple, readable syntax with an enormous data ecosystem — it's the one language that spans data engineering, data science, and machine learning at once.**

- Simple, readable syntax — you focus on the problem, not the language
- An enormous ecosystem: Pandas, NumPy, PySpark, Boto3, PyMongo, and more
- Strong community support and constant development
- The language of data science, machine learning, and data engineering simultaneously
- First-class support from most cloud platforms and data tools

> **Remember:** Python's strength is being "good enough" at everything and unbeatable on ecosystem — the same language cleans data, builds pipelines, and trains models, so teams don't switch tools between stages.

---

## Relational databases & SQL

### What type of database is SQL and MongoDB, and why would you use each?

**They represent the two main database families — SQL is relational, MongoDB is document-based NoSQL — and the choice comes down to the shape of your data and how much consistency you need.**

**SQL (relational / RDBMS)** — stores data in tables of rows and columns, with a fixed schema and defined relationships between tables. Data is normalised across related tables and joined back together when queried. _Examples: PostgreSQL, MySQL, SQL Server_

- Strong consistency: ACID transactions keep data valid even under concurrent writes or failure — essential for money and orders
- Enforced schema: structure is defined up front, protecting integrity and catching bad data early
- Powerful querying: joins combine related tables, and SQL is a mature, standard, widely-known language
- Best for: structured data with clear relationships: financial transactions, banking, e-commerce orders, inventory, user accounts

**MongoDB (document / NoSQL)** — stores data as flexible, JSON-like documents (BSON) grouped into collections, with no fixed schema. Related data is often nested within a single document rather than split across tables. It's specifically the document type within the wider NoSQL family (which also includes key-value stores like Redis, wide-column stores like Cassandra, and graph databases like Neo4j).

- Flexible schema: documents in one collection can have different fields, so the model can evolve without migrations
- Natural fit for nested data: hierarchical structures are stored as-is, not spread across joined tables
- Scales horizontally: designed to shard across servers, handling large volumes and high write throughput
- Best for: semi-structured or evolving data: content management, product catalogues with varying attributes, user profiles, event/logging data, IoT streams, and JSON straight from APIs

> **Remember:** SQL = relational, tables, fixed schema, strict consistency (think a bank ledger). MongoDB = NoSQL document store, flexible and nested, built to scale (think a product catalogue where every item has different attributes). Naming the specific NoSQL sub-type — document — rather than just "NoSQL" shows sharper knowledge, and the real signal is choosing based on the data, not treating either as universally better.

### Why use SQL, and why is it so popular?

**SQL is popular because of the language itself — declarative, readable, and near-universal — independent of any one database.** (When to choose a relational database over NoSQL is a separate question — see the [SQL vs MongoDB entry](#what-type-of-database-is-sql-and-mongodb-and-why-would-you-use-each).)

- **Declarative, not procedural:** you describe what result you want, and the database's query planner works out how to get it efficiently
- Human-readable and relatively easy to learn compared to general-purpose programming languages
- **Near-universal:** it works across virtually every relational system, and the core syntax transfers between them
- **Battle-tested:** decades of investment mean it's heavily optimised and supported everywhere
- **Expressive:** joins, aggregations, window functions, and subqueries handle complex operations concisely
- So entrenched that even non-relational systems like Spark and BigQuery expose SQL interfaces, because the demand is universal

> **Remember:** SQL's staying power is about the language, not the storage — declarative ("say what, not how"), readable, and portable. It's so entrenched that non-relational tools bolt a SQL layer on top rather than fight it.

### What is the difference between a primary key and a foreign key?

**Both are about identity and relationships in a relational database — a primary key uniquely identifies rows within a table; a foreign key links one table to another.**

**Primary key** — a column (or combination of columns) that uniquely identifies every row in a table.

- Cannot be null and cannot be duplicated — guarantees every record is distinguishable

**Foreign key** — a column in one table that references the primary key of another table.

- Enforces referential integrity: you can't have a foreign key value that doesn't exist in the referenced table
- It's the mechanism that links related tables together

> **Remember:** primary key = unique ID within a table; foreign key = a pointer to another table's primary key. Example: in an Orders table, `customer_id` is a foreign key referencing the `id` primary key in the Customers table.

_Full detail: [01-data-modelling — Core Concepts](01-data-modelling/README.md#core-concepts)._

### What is normalisation?

**Organising a database to reduce redundancy and improve integrity — by splitting data across multiple related tables rather than storing everything in one flat table.**

- **First Normal Form (1NF):** eliminate repeating groups; each column holds a single value
- **Second Normal Form (2NF):** remove partial dependencies; every non-key column depends on the whole primary key (this only bites when the primary key is composite / made of multiple columns)
- **Third Normal Form (3NF):** remove transitive dependencies; non-key columns depend only on the primary key, not on other non-key columns
- The payoff: normalised databases are easier to maintain, update, and keep consistent

> **Remember:** normalisation removes redundancy by splitting data across related tables (1NF → 2NF → 3NF). The tradeoff is more joins and slower reads — which is why data warehouses often deliberately denormalise for query performance.

_Full detail: [01-data-modelling — Normalisation Rules](01-data-modelling/README.md#normalisation-rules)._

### What are the different types of SQL JOIN?

**A JOIN combines rows from two tables based on a related column. The four main types differ in which unmatched rows they keep.**

- **INNER JOIN:** returns only rows that have a match in both tables. The default and most common; unmatched rows from either side are dropped
- **LEFT JOIN (LEFT OUTER):** returns all rows from the left table, plus matching rows from the right. Where there's no match, the right-side columns are `NULL`. Used to keep every record from your main table regardless of matches
- **RIGHT JOIN (RIGHT OUTER):** the mirror image: all rows from the right table, plus matches from the left. Rarer in practice, since you can usually rewrite it as a LEFT JOIN by swapping the table order
- **FULL OUTER JOIN:** returns all rows from both tables, matching where possible and filling `NULL`s where not. Used to see everything from both sides, including what didn't match

> **Remember:** INNER = matches only; LEFT = everything from the left + matches; RIGHT = everything from the right + matches; FULL = everything from both. A useful interview note: a LEFT JOIN with a `WHERE right_table.id IS NULL` filter is the standard way to find rows in one table with no match in the other.

_Full detail: [03-joins — Types of JOIN](03-joins/README.md#types-of-join)._

### What is the difference between WHERE and HAVING?

**Both filter, but at different stages — WHERE filters individual rows before aggregation; HAVING filters groups after aggregation.**

- `WHERE` filters rows before any aggregation happens — applied to individual records
- `HAVING` filters groups after aggregation, used with `GROUP BY`
- `WHERE` can't reference aggregate functions like `SUM` or `COUNT` — those don't exist yet at the point `WHERE` runs
- `HAVING` can reference aggregates, because it runs after they're calculated

> **Remember:** WHERE = before grouping (individual rows); HAVING = after grouping (aggregated groups). Example: `WHERE revenue > 1000` filters individual rows; `HAVING SUM(revenue) > 1000` filters groups whose total exceeds the threshold.

_Full detail: [04-aggregation-and-subqueries — HAVING](04-aggregation-and-subqueries/README.md#having)._

### Why use subqueries?

**A subquery is a query nested inside another — used when you need the result of one query to feed into another, and can't get there in a single flat query.**

- Useful when one query's output is the input to another
- Common uses: filtering by an aggregate result, comparing a row to a calculated value, or finding records that do (or don't) exist in another dataset
- `IN` handles multiple matches, so a subquery returning many rows works with `IN` where `=` would fail
- Can often be rewritten as a JOIN or CTE for better readability and performance at scale

```sql
SELECT * FROM Orders WHERE customer_id IN (SELECT id FROM Customers WHERE country = 'UK')
```

> **Remember:** subqueries let one query feed another. In production, CTEs are usually preferred over deeply nested subqueries — they're easier to read, debug, and maintain.

_Full detail: [04-aggregation-and-subqueries — Subqueries](04-aggregation-and-subqueries/README.md#subqueries)._

### What is a CTE, and how does it compare to a subquery?

**A CTE (Common Table Expression) is a named, temporary result set defined with a `WITH` clause at the top of a query, which you can then reference like a table. It's the readable alternative to nesting subqueries.**

- Defined once with `WITH name AS (...)`, then referenced by name in the main query
- Makes complex queries readable — you build up logic in named, ordered steps rather than nesting queries inside each other
- Can be referenced multiple times in the same query, unlike a subquery which would have to be repeated
- Supports recursion (recursive CTEs) for hierarchical data like org charts or category trees

```sql
WITH uk_customers AS (SELECT id FROM Customers WHERE country = 'UK')
SELECT * FROM Orders WHERE customer_id IN (SELECT id FROM uk_customers)
```

**CTE vs subquery:** they often produce the same result, but a CTE is named and sits at the top, while a subquery is inline and anonymous. For anything beyond one simple level of nesting, CTEs are preferred in production because they're easier to read, debug, and maintain.

> **Remember:** a CTE is a named, reusable query step defined with `WITH`. Same power as a subquery, far more readable — which is why deeply nested subqueries get rewritten as CTEs in real pipelines.

_Full detail: [04-aggregation-and-subqueries — Common Table Expressions (CTEs)](04-aggregation-and-subqueries/README.md#common-table-expressions-ctes)._

### What is a window function?

**A window function performs a calculation across a set of rows related to the current row, without collapsing them into a single result — unlike a GROUP BY aggregate, every row is kept.**

- **The key difference from GROUP BY:** aggregation collapses rows into one per group; a window function adds a computed column while keeping every row
- Defined with `OVER (...)`, optionally `PARTITION BY` (to group the window) and `ORDER BY` (to order within it)
- Common uses: running totals, moving averages, and ranking rows within a group
- Ranking functions: `ROW_NUMBER` (unique sequential number), `RANK` (gaps after ties), `DENSE_RANK` (no gaps after ties)

```sql
RANK() OVER (PARTITION BY department ORDER BY salary DESC)
```

This ranks employees by salary within each department, while still returning every employee row.

> **Remember:** window functions calculate across related rows but keep every row — GROUP BY collapses, a window function annotates. The classic use case is "rank within a group" or "running total," where you need the aggregate and the detail rows at once.

### What is an index, and why does it matter?

**An index is a data structure a database maintains to speed up reads — like the index at the back of a book, it lets the database jump straight to matching rows instead of scanning the whole table.**

- Without an index, finding rows means a full table scan — reading every row; with one, the database looks up matches directly
- Usually built on the columns you filter or join on frequently (`WHERE`, `JOIN`, `ORDER BY`)
- Primary keys are indexed automatically; you add others deliberately based on query patterns
- Most commonly a B-tree structure, which keeps values sorted for fast lookups and range queries
- The tradeoff: indexes speed up reads but slow down writes (each insert/update must also update the index) and take extra storage

> **Remember:** an index trades write speed and storage for much faster reads. Index the columns you filter and join on — but not everything, since over-indexing punishes writes. It's the first thing to reach for when a query is slow.

_Full detail: [06-indexing — What is an Index?](06-indexing/README.md#what-is-an-index)._

---

## NoSQL & MongoDB

> _Covered hands-on in the sibling `starwars-mongodb-and-cloud-computing` repo._

### How do you store data in MongoDB?

**Data is stored as BSON documents grouped into collections — flexible, self-contained records rather than fixed rows in a table.**

- Stored as documents — JSON-like objects called BSON (Binary JSON) — held in collections
- Each document is a self-contained record that can include nested objects and arrays
- Documents in the same collection don't need to share the same structure — a flexible schema
- Each document automatically gets a unique `_id` field of type ObjectId, unless you specify one
- Collections are roughly equivalent to tables in a relational database, but without an enforced column structure

> **Remember:** documents (BSON) live in collections with no enforced schema, and every document gets a unique ObjectId `_id` by default. A collection is like a table, minus the fixed structure.

### How do relationships work in MongoDB?

**MongoDB has no enforced joins, so you model relationships in one of two ways — embedding or referencing — and referential integrity is your application's responsibility, not the database's.**

- **Embedding:** nest related data directly inside a document as a subdocument or array. Good when the related data is always accessed together and doesn't change independently (e.g. comments inside a blog-post document)
- **Referencing:** store the ObjectId of another document as a field and look it up when needed. Good when the related data is large, shared across documents, or changes independently (e.g. an order storing a `customer_id` that points to a document in the customers collection)
- Unlike relational databases, there are no enforced foreign keys — maintaining referential integrity is up to the application

> **Remember:** embed for data that's owned and read together; reference for data that's shared, large, or changes independently. The tradeoff is that SQL enforces integrity for you, whereas MongoDB shifts that responsibility to your code.

---

## Data pipelines

### Explain a basic ETL workflow involving MongoDB

**The standard Extract–Transform–Load pattern, extended to export the results and push them to cloud storage — built to be idempotent, so running it twice gives the same output.**

- **Extract:** pull data from a source, such as a public API using Python's `requests` library
- **Transform:** clean and reshape the data: resolving API URLs into MongoDB ObjectIds and stripping unnecessary fields
- **Load:** insert the transformed data into MongoDB using PyMongo's `insert_many()`, after resetting the collection with `delete_many({})` for idempotency
- **Export:** use `bson.json_util.dumps` to serialise the MongoDB documents, including their ObjectId fields, into valid JSON
- **Push to S3:** upload the serialised JSON to AWS S3 using boto3's `put_object()`, keeping the data in memory with no intermediate file
- The result is a repeatable pipeline — running it twice gives the same output: extract, transform, load, export, store

> **Remember:** the extra detail that makes this a strong answer is idempotency (`delete_many({})` before load so re-runs are clean), serialising ObjectIds properly with `bson.json_util`, and pushing to S3 in memory. It's ETL that ends in cloud storage, not just a load into Mongo.

### What is an ETL pipeline vs ELT? When would you use each?

**Both move data from sources into a destination through Extract, Transform, and Load — the difference is the order: ETL transforms before loading, ELT loads first and transforms inside the destination.**

The three steps:

- **Extract** — pull data from one or more sources (APIs, databases, files, streams)
- **Transform** — clean, reshape, enrich, and validate it
- **Load** — write the data to a destination like a data warehouse or database

**ETL (Extract → Transform → Load)** — transform the data before it lands in the destination.

- Best when the destination is a traditional warehouse with limited compute, or when data must be cleaned/validated before storage (e.g. for compliance)
- Suits smaller volumes and cases where only refined data should ever reach the warehouse
- Example: a classic on-premise data warehouse fed by a dedicated transformation tool

**ELT (Extract → Load → Transform)** — load the raw data first, then transform it inside the destination.

- Best with modern cloud warehouses (Snowflake, BigQuery, Redshift) that have huge, cheap, scalable compute to do the transformation in place
- Suits large volumes and keeps the raw data available, so you can re-transform later without re-extracting
- Example: loading raw data into BigQuery, then transforming it with SQL (often via a tool like dbt)

> **Remember:** ETL = transform then load (clean before it lands — older, on-premise world). ELT = load then transform (dump raw, transform in-warehouse — the modern cloud default, since cloud compute is cheap and scalable).

### What is idempotency, and why does it matter in data pipelines?

**Idempotency means an operation produces the same result whether it runs once or many times — running it again doesn't duplicate or corrupt anything.**

- A pipeline is idempotent if re-running it leaves the data in the same correct state, rather than adding duplicates
- It matters because pipelines fail and get retried — a job might crash halfway and run again, and you don't want double-counted data
- Common techniques: resetting a target before loading (e.g. `delete_many({})` before insert), using `UPSERT`/`MERGE` to update-or-insert rather than blindly appending, or writing to a specific partition that gets overwritten
- Example: a nightly job that overwrites today's partition is idempotent — run it five times and the result is identical

> **Remember:** idempotent = safe to re-run. It's a core reliability property in data engineering because retries are inevitable, and it's what lets you recover from a failure by simply running the job again.

### Why is automation important?

**Automation replaces manual, repetitive work with reliable, repeatable processes — which matters because manual steps don't scale, and they're where errors and delays creep in.**

- **Consistency and fewer errors:** a machine runs the same steps the same way every time, removing the human mistakes that manual processes inevitably introduce
- **Scale:** manual work that's fine for ten records collapses at ten million — automation is the only way to handle real data volumes
- **Speed and freeing up people:** pipelines run on a schedule without someone triggering them, freeing engineers to work on higher-value problems rather than repetitive tasks
- **Reliability and recoverability:** an automated, idempotent pipeline can be re-run safely after a failure, where a manual process would have to be painstakingly redone
- **Auditability:** automated steps are defined in code, so they're documented, version-controlled, and traceable — you can see exactly what ran and when

> **Remember:** automation trades one-off manual effort for consistency, scale, and reliability. In data engineering it's the whole point of a pipeline — you build it once and it runs correctly every time, instead of someone repeating the same steps by hand.
