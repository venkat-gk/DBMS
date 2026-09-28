-- =====================================================
-- Task 2: Product & Category Management
-- Database: ProductManagementDB
-- =====================================================

-- 1. Create Database & Tables
CREATE DATABASE IF NOT EXISTS ProductManagementDB;
USE ProductManagementDB;

-- Category Table
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Product Table with Constraints (PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK)
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Category_ID INT,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE SET NULL
);

-- =====================================================
-- 2. Insert Sample Data
-- =====================================================

-- Insert Category Records
INSERT INTO Category (Category_ID, Category_Name, Description) VALUES
(1, 'Electronics', 'Devices, gadgets, and electronic accessories'),
(2, 'Clothing', 'Apparel and fashion wear for men and women'),
(3, 'Home & Kitchen', 'Appliances and tools for home and cooking'),
(4, 'Books', 'Educational, fiction, and non-fiction books');

-- Insert Product Records (12 records total, exceeding the minimum of 10)
INSERT INTO Product (Product_ID, Product_Name, Category_ID, Price, Stock_Quantity) VALUES
(101, 'Smartphone X', 1, 699.99, 50),
(102, 'Wireless Earbuds', 1, 89.99, 120),
(103, 'Gaming Laptop', 1, 1299.50, 25),
(104, 'Cotton T-Shirt', 2, 19.99, 200),
(105, 'Denim Jeans', 2, 49.99, 80),
(106, 'Running Shoes', 2, 79.99, 60),
(107, 'Blender Pro', 3, 45.00, 40),
(108, 'Coffee Maker', 3, 89.00, 30),
(109, 'Non-Stick Pan Set', 3, 65.50, 45),
(110, 'Python Programming Guide', 4, 39.99, 100),
(111, 'Sci-Fi Novel Anthology', 4, 24.99, 75),
(112, 'Smart TV 55 inch', 1, 450.00, 15);

-- =====================================================
-- 3. CRUD Operations
-- =====================================================

-- INSERT Operation: Add a new product
INSERT INTO Product (Product_ID, Product_Name, Category_ID, Price, Stock_Quantity) 
VALUES (113, 'Bluetooth Speaker', 1, 59.99, 90);

-- SELECT Operation: Retrieve all products / specific category
SELECT * FROM Product;
SELECT * FROM Product WHERE Category_ID = 1;

-- UPDATE Operation: Modify product price and stock quantity
UPDATE Product 
SET Price = 749.99, Stock_Quantity = 45 
WHERE Product_ID = 101;

-- DELETE Operation: Remove a product
DELETE FROM Product 
WHERE Product_ID = 113;

-- =====================================================
-- 4. Category-wise Analysis Queries
-- =====================================================

-- A. Display products category-wise (using JOIN)
SELECT p.Product_ID, p.Product_Name, c.Category_Name, p.Price, p.Stock_Quantity
FROM Product p
JOIN Category c ON p.Category_ID = c.Category_ID
ORDER BY c.Category_Name;

-- B. Count products in each category
SELECT c.Category_Name, COUNT(p.Product_ID) AS Total_Products
FROM Category c
LEFT JOIN Product p ON c.Category_ID = p.Category_ID
GROUP BY c.Category_ID, c.Category_Name;

-- C. Find highest-priced product
SELECT p.Product_Name, c.Category_Name, p.Price
FROM Product p
JOIN Category c ON p.Category_ID = c.Category_ID
WHERE p.Price = (SELECT MAX(Price) FROM Product);

-- D. Find categories having more than 5 products
SELECT c.Category_Name, COUNT(p.Product_ID) AS Total_Products
FROM Category c
JOIN Product p ON c.Category_ID = p.Category_ID
GROUP BY c.Category_ID, c.Category_Name
HAVING COUNT(p.Product_ID) > 5;

-- E. Calculate average product price
SELECT ROUND(AVG(Price), 2) AS Average_Product_Price FROM Product;
