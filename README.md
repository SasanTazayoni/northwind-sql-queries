# Northwind SQL Queries

![MySQL](./tech/mysql.png) ![VSCode](./tech/vscode.png)

> All queries in this project are written against the **Northwind** database. The SQL to set it up can be found here: [instnwnd.sql](https://github.com/microsoft/sql-server-samples/blob/master/samples/databases/northwind-pubs/instnwnd.sql)

---

## Setup Instructions

### Option: SQL Server Express

It may be best to document the process as you go.

---

### Part 1 - Install SQL Server Express

1. Download [SQL Server Express](https://www.microsoft.com/en-us/download/details.aspx?id=104781)
2. Run the installer
3. Choose **Basic** installation
4. Choose where you want it to be installed
5. Wait for the install to finish
6. When done, make a note of the information provided — particularly the **connection string**. It should look similar to:
   ```
   Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=True;
   ```

---

### Part 2 - GUI Interface: SQL Server Management Studio or VSCode

You need a GUI to interact with SQL Server Express more easily. You can use either **SQL Server Management Studio (SSMS)** or **VSCode with the SQL Server Extension**.

#### Option A: SQL Server Management Studio (SSMS)

1. Download [SQL Server Management Studio](https://learn.microsoft.com/en-us/ssms/install/install)
2. Run the `.exe`
3. Leave all tick boxes at their defaults
4. Wait for the install to finish (this can take some time)
5. When prompted, enter the following connection details:
   - **Server Name:** `localhost\SQLEXPRESS`
   - **Authentication:** `Windows Authentication`
   - Tick **"Trust server certificate"**
   - Click **OK**

#### Option B: VSCode

The process is very similar to SSMS. You will need to install the **SQL Server Extension** from the VSCode marketplace.

---

### Part 3 - Create a Database and Test It

#### Create a Database (SSMS)

1. Right-click **Databases** in the Object Explorer
2. Click **New Database**
3. Name it `se-training-db` (or similar)
4. Click **OK**

#### Create and Test a Table

1. Click **New Query**
2. Run the following script to create a table:
   ```sql
   CREATE TABLE users (
       user_id INT PRIMARY KEY,
       name NVARCHAR(100),
       email NVARCHAR(100)
   );
   ```
3. Click **Execute**
4. Verify the table was created by running:
   ```sql
   SELECT * FROM dbo.users;
   ```

If the query runs successfully, you're good to go!

For more detail on each topic see the topic folders:

- [01-data-modelling](./01-data-modelling/)
- [02-basic-queries](./02-basic-queries/)
- [03-joins](./03-joins/)
- [04-aggregation-and-subqueries](./04-aggregation-and-subqueries/)
- [05-case-statements-and-stored-procedures](./05-case-statements-and-stored-procedures/)
- [06-indexing](./06-indexing/)
- [07-query-optimisation](./07-query-optimisation/)
