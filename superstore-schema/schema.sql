-- Create Superstore Database
CREATE DATABASE Superstore;
GO

USE Superstore;
GO

-- 1. Category
CREATE TABLE Category (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Sub_Category
CREATE TABLE Sub_Category (
    sub_category_id VARCHAR(20) PRIMARY KEY,
    sub_category_name VARCHAR(100) NOT NULL,
    category_id VARCHAR(20) FOREIGN KEY REFERENCES Category(category_id)
);

-- 3. Product
CREATE TABLE Product (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    sub_category_id VARCHAR(20) FOREIGN KEY REFERENCES Sub_Category(sub_category_id)
);

-- 4. Customer
CREATE TABLE Customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(50)
);

-- 5. Location
CREATE TABLE Location (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

-- 6. [Order]
CREATE TABLE [Order] (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20) FOREIGN KEY REFERENCES Customer(customer_id),
    location_id INT FOREIGN KEY REFERENCES Location(location_id)
);

-- 7. Order_Item
CREATE TABLE Order_Item (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(20) FOREIGN KEY REFERENCES [Order](order_id),
    product_id VARCHAR(20) FOREIGN KEY REFERENCES Product(product_id),
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT
);
