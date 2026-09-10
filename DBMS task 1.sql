DROP DATABASE IF EXISTS Flipkart_Ecommerce;
CREATE DATABASE Flipkart_Ecommerce;
USE Flipkart_Ecommerce;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    Address VARCHAR(255) NOT NULL
);

CREATE TABLE Seller (
    SellerID INT PRIMARY KEY,
    SellerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    Address VARCHAR(255) NOT NULL
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    SellerID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    FOREIGN KEY (SellerID) REFERENCES Seller(SellerID),
    CHECK (Price >= 0),
    CHECK (Stock >= 0)
);

CREATE TABLE `Order` (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    CHECK (Quantity > 0),
    CHECK (TotalAmount >= 0)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    CHECK (Amount >= 0)
);

INSERT INTO Customer VALUES
(1,'Arun Kumar','arun@gmail.com','9876543210','Chennai'),
(2,'Priya Raj','priya@gmail.com','9876543211','Madurai'),
(3,'Rahul Sharma','rahul@gmail.com','9876543212','Coimbatore'),
(4,'Divya Suresh','divya@gmail.com','9876543213','Salem'),
(5,'Karthik Mohan','karthik@gmail.com','9876543214','Trichy'),
(6,'Meena Devi','meena@gmail.com','9876543215','Tirunelveli'),
(7,'Vijay Raj','vijay@gmail.com','9876543216','Thoothukudi'),
(8,'Anitha Kumar','anitha@gmail.com','9876543217','Erode'),
(9,'Sanjay Babu','sanjay@gmail.com','9876543218','Vellore'),
(10,'Nisha Priya','nisha@gmail.com','9876543219','Tanjore');

INSERT INTO Seller VALUES
(1,'RetailNet','retailnet@gmail.com','9000000001','Bangalore'),
(2,'TechKart Seller','techkart@gmail.com','9000000002','Chennai'),
(3,'Fashion Point','fashionpoint@gmail.com','9000000003','Mumbai'),
(4,'Home Store','homestore@gmail.com','9000000004','Delhi'),
(5,'Mobile World','mobileworld@gmail.com','9000000005','Hyderabad');

INSERT INTO Product VALUES
(101,1,'Samsung Galaxy M15','Mobiles',13999.00,25),
(102,2,'HP Laptop 15','Laptops',54999.00,15),
(103,3,'Men Cotton T-Shirt','Fashion',599.00,100),
(104,4,'Prestige Mixer Grinder','Home Appliances',2499.00,40),
(105,5,'boAt Bluetooth Earbuds','Electronics',1299.00,75),
(106,1,'Realme Smart Watch','Wearables',2999.00,30),
(107,2,'Sony Headphones','Electronics',4999.00,20),
(108,3,'Women Jeans','Fashion',1599.00,60),
(109,4,'LG Washing Machine','Home Appliances',28999.00,10),
(110,5,'iPhone 15','Mobiles',69999.00,12);

INSERT INTO `Order` VALUES
(1001,1,101,1,'2026-09-01',13999.00,'Delivered'),
(1002,2,103,2,'2026-09-02',1198.00,'Shipped'),
(1003,3,102,1,'2026-09-03',54999.00,'Processing'),
(1004,4,104,1,'2026-09-04',2499.00,'Delivered'),
(1005,5,105,2,'2026-09-05',2598.00,'Shipped'),
(1006,6,106,1,'2026-09-06',2999.00,'Processing'),
(1007,7,107,1,'2026-09-07',4999.00,'Delivered'),
(1008,8,108,1,'2026-09-08',1599.00,'Shipped'),
(1009,9,109,1,'2026-09-09',28999.00,'Processing'),
(1010,10,110,1,'2026-09-10',69999.00,'Delivered');

INSERT INTO Payment VALUES
(501,1001,'2026-09-01','UPI',13999.00,'Paid'),
(502,1002,'2026-09-02','Card',1198.00,'Paid'),
(503,1003,'2026-09-03','UPI',54999.00,'Paid'),
(504,1004,'2026-09-04','Card',2499.00,'Paid'),
(505,1005,'2026-09-05','Cash on Delivery',2598.00,'Paid'),
(506,1006,'2026-09-06','UPI',2999.00,'Paid'),
(507,1007,'2026-09-07','Card',4999.00,'Paid'),
(508,1008,'2026-09-08','UPI',1599.00,'Paid'),
(509,1009,'2026-09-09','Card',28999.00,'Pending'),
(510,1010,'2026-09-10','UPI',69999.00,'Paid');

SELECT * FROM Customer;
SELECT * FROM Seller;
SELECT * FROM Product;
SELECT * FROM `Order`;
SELECT * FROM Payment;

SELECT ProductName, Category, Price
FROM Product
WHERE Price > 5000;

SELECT *
FROM `Order`
WHERE OrderStatus = 'Delivered';

SELECT
    c.CustomerName,
    p.ProductName,
    o.Quantity,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN Product p ON o.ProductID = p.ProductID;

SELECT
    p.ProductName,
    p.Category,
    p.Price,
    s.SellerName
FROM Product p
JOIN Seller s ON p.SellerID = s.SellerID;

SELECT
    o.OrderID,
    c.CustomerName,
    o.TotalAmount,
    o.OrderStatus,
    py.PaymentMethod,
    py.PaymentStatus
FROM `Order` o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Payment py ON o.OrderID = py.OrderID;

SELECT SUM(TotalAmount) AS TotalSales
FROM `Order`;

SELECT AVG(Price) AS AveragePrice
FROM Product;

SELECT MAX(Price) AS HighestPrice
FROM Product;

SELECT MIN(Price) AS LowestPrice
FROM Product;

SELECT COUNT(*) AS TotalProducts
FROM Product;

UPDATE Product
SET Price = 1299.00
WHERE ProductID = 105;

UPDATE Product
SET Stock = 70
WHERE ProductID = 105;

UPDATE `Order`
SET OrderStatus = 'Shipped'
WHERE OrderID = 1003;

UPDATE Payment
SET PaymentStatus = 'Paid'
WHERE PaymentID = 509;

INSERT INTO Customer VALUES
(11,'Ravi Kumar','ravi@gmail.com','9876543220','Nagercoil');

SELECT * FROM Customer
WHERE CustomerID = 11;

UPDATE Customer
SET Address = 'Kanyakumari'
WHERE CustomerID = 11;

DELETE FROM Customer
WHERE CustomerID = 11;

CREATE VIEW CustomerOrderView AS
SELECT
    c.CustomerID,
    c.CustomerName,
    p.ProductName,
    o.Quantity,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN Product p ON o.ProductID = p.ProductID;

SELECT * FROM CustomerOrderView;

CREATE VIEW SellerProductView AS
SELECT
    s.SellerID,
    s.SellerName,
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    p.Stock
FROM Seller s
JOIN Product p ON s.SellerID = p.SellerID;

SELECT * FROM SellerProductView;

SHOW TABLES;