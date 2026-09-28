-- =====================================================
-- Week 3: Seller & Inventory Management System
-- Database: InventoryManagementDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS InventoryManagementDB;
USE InventoryManagementDB;

-- 1. Create Tables & Constraints

-- Category Table (Prerequisite for Product)
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Product Table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Category_ID INT,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE SET NULL
);

-- Seller Table
CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Phone VARCHAR(20) NOT NULL,
    Address TEXT NOT NULL
);

-- Inventory Table (Relates Product and Seller)
CREATE TABLE Inventory (
    Inventory_ID INT PRIMARY KEY,
    Product_ID INT NOT NULL,
    Seller_ID INT NOT NULL,
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    Stock_Status VARCHAR(50) NOT NULL,
    Last_Updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID) ON DELETE CASCADE,
    FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID) ON DELETE CASCADE
);

-- =====================================================
-- 2. Insert Sample Data
-- =====================================================

INSERT INTO Category (Category_ID, Category_Name, Description) VALUES
(1, 'Electronics', 'Electronic items and gadgets'),
(2, 'Clothing', 'Apparel and fashion wear'),
(3, 'Home & Kitchen', 'Home appliances and kitchenware');

INSERT INTO Product (Product_ID, Product_Name, Category_ID, Price) VALUES
(101, 'Smartphone X', 1, 699.99),
(102, 'Wireless Earbuds', 1, 89.99),
(103, 'Gaming Laptop', 1, 1299.50),
(104, 'Cotton T-Shirt', 2, 19.99),
(105, 'Denim Jeans', 2, 49.99),
(106, 'Blender Pro', 3, 45.00),
(107, 'Coffee Maker', 3, 89.00),
(108, 'Smart TV 55 inch', 1, 450.00);

INSERT INTO Seller (Seller_ID, Seller_Name, Email, Phone, Address) VALUES
(1, 'TechCorp Global', 'contact@techcorp.com', '+1-555-0192', '123 Silicon Way, CA'),
(2, 'FashionHub Retail', 'support@fashionhub.com', '+1-555-0144', '456 Trend Ave, NY'),
(3, 'HomeEssentials Inc', 'info@homeessentials.com', '+1-555-0178', '789 Market St, TX');

INSERT INTO Inventory (Inventory_ID, Product_ID, Seller_ID, Stock_Quantity, Stock_Status) VALUES
(1, 101, 1, 50, 'In Stock'),
(2, 102, 1, 120, 'In Stock'),
(3, 103, 1, 5, 'Low Stock'),
(4, 104, 2, 200, 'In Stock'),
(5, 105, 2, 80, 'In Stock'),
(6, 106, 3, 0, 'Out of Stock'),
(7, 107, 3, 30, 'In Stock'),
(8, 108, 1, 15, 'In Stock');

-- =====================================================
-- 3. Seller & Product CRUD Operations
-- =====================================================

-- Add seller details
INSERT INTO Seller (Seller_ID, Seller_Name, Email, Phone, Address) 
VALUES (4, 'Apex Gadgets', 'sales@apexgadgets.com', '+1-555-0199', '99 Innovation Dr, WA');

-- Assign products to sellers (via Inventory insertion)
INSERT INTO Inventory (Inventory_ID, Product_ID, Seller_ID, Stock_Quantity, Stock_Status) 
VALUES (9, 103, 4, 25, 'In Stock');

-- Display products supplied by each seller
SELECT s.Seller_Name, p.Product_Name, i.Stock_Quantity, i.Stock_Status
FROM Inventory i
JOIN Seller s ON i.Seller_ID = s.Seller_ID
JOIN Product p ON i.Product_ID = p.Product_ID
ORDER BY s.Seller_Name;

-- Count products supplied by each seller
SELECT s.Seller_Name, COUNT(i.Product_ID) AS Total_Products_Supplied
FROM Seller s
LEFT JOIN Inventory i ON s.Seller_ID = i.Seller_ID
GROUP BY s.Seller_ID, s.Seller_Name;

-- Update seller details
UPDATE Seller 
SET Phone = '+1-555-9999', Address = '100 Tech Blvd, CA' 
WHERE Seller_ID = 1;

-- =====================================================
-- 4. Inventory Operations Queries
-- =====================================================

-- Display available products (Stock > 0)
SELECT p.Product_Name, i.Stock_Quantity, i.Stock_Status
FROM Inventory i
JOIN Product p ON i.Product_ID = p.Product_ID
WHERE i.Stock_Quantity > 0;

-- Find out-of-stock products
SELECT p.Product_Name, s.Seller_Name
FROM Inventory i
JOIN Product p ON i.Product_ID = p.Product_ID
JOIN Seller s ON i.Seller_ID = s.Seller_ID
WHERE i.Stock_Quantity = 0 OR i.Stock_Status = 'Out of Stock';

-- Find products with stock less than 10
SELECT p.Product_Name, i.Stock_Quantity, s.Seller_Name
FROM Inventory i
JOIN Product p ON i.Product_ID = p.Product_ID
JOIN Seller s ON i.Seller_ID = s.Seller_ID
WHERE i.Stock_Quantity < 10;

-- Update stock quantity
UPDATE Inventory 
SET Stock_Quantity = 45, Stock_Status = 'In Stock' 
WHERE Inventory_ID = 3;

-- Delete discontinued inventory
DELETE FROM Inventory 
WHERE Inventory_ID = 6;

-- =====================================================
-- 5. Inventory Reports & Analytics
-- =====================================================

-- Seller-wise product report
SELECT s.Seller_Name, COUNT(i.Product_ID) AS Product_Count, SUM(i.Stock_Quantity) AS Total_Stock
FROM Seller s
LEFT JOIN Inventory i ON s.Seller_ID = i.Seller_ID
GROUP BY s.Seller_ID, s.Seller_Name;

-- Stock availability report
SELECT Stock_Status, COUNT(*) AS Status_Count
FROM Inventory
GROUP BY Stock_Status;

-- Total available products count
SELECT SUM(Stock_Quantity) AS Total_Available_Stock FROM Inventory;

-- Out-of-stock products count report
SELECT COUNT(*) AS Out_Of_Stock_Count FROM Inventory WHERE Stock_Quantity = 0;

-- Highest stocked product
SELECT p.Product_Name, i.Stock_Quantity, s.Seller_Name
FROM Inventory i
JOIN Product p ON i.Product_ID = p.Product_ID
JOIN Seller s ON i.Seller_ID = s.Seller_ID
WHERE i.Stock_Quantity = (SELECT MAX(Stock_Quantity) FROM Inventory);

-- Average inventory quantity
SELECT ROUND(AVG(Stock_Quantity), 2) AS Average_Inventory_Quantity FROM Inventory;
