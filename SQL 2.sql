-- Primary Key và Foreign Key
-- ALTER
-- LIKE?
-- CAST, CONVERT
-- SUM, AVG ?
-- INNER JOIN
-- FULL OUTER JOIN
-- LEFT - RIGHT JOIN

CREATE DATABASE SALES_MANAGER;
GO

USE SALES_MANAGER;
GO

-- *********** Product Table
CREATE TABLE Products
(
    Id INT IDENTITY(1, 1) CONSTRAINT PK_prd PRIMARY KEY(ID),
    Name NVARCHAR(255) NOT NULL,
    Price INT CONSTRAINT Check_prd_price CHECK(Price >= 0) NOT NULL,
);
GO

-- *********** ALTER
ALTER TABLE Products
    ADD Quantity INT CONSTRAINT Check_quantity_prd CHECK(Quantity > 0);
GO

INSERT INTO Products
    (Name, Price, Quantity)
VALUES
    (N'Iphone 13', 12000000, 80),
    (N'Iphone 14', 18000000, 170),
    (N'Iphone 12', 10000000, 190),
    (N'Iphone X', 8000000, 140),
    (N'Samsung A10', 3000000, 100),
    (N'Samsung A11', 3300000, 100),
    (N'Samsung A12', 3500000, 100),
    (N'Samsung A54', 11000000, 100),
    (N'Samsung A34', 8300000, 150),
    (N'xiaomi note 11', 4500000, 500),
    (N'xiaomi note 11 Pro', 5500000, 300),
    (N'Redmi Q5', 4200000, 203),
    (N'Redmi Q7', 5200000, 250);
GO

-- *********** Salesman Table
CREATE TABLE Salesman
(
    Id INT IDENTITY(1, 1) CONSTRAINT PK_salesman PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL
);
GO

INSERT INTO Salesman
    (Name)
VALUES
    (N'Văn Hiền'),
    (N'Hồng Ngọc'),
    (N'Hồng Nhung'),
    (N'Ngọc Nhi');
GO

-- *********** Customers Tables
CREATE TABLE Customers
(
    Id INT IDENTITY(1, 1) CONSTRAINT PK_customer PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL
);
GO

INSERT INTO Customers
    (Name)
VALUES
    (N'Hoàng Anh'),
    (N'Văn Thanh'),
    (N'Lê Lợi'),
    (N'Minh Huệ'),
    (N'Minh Cường'),
    (N'Thanh Lịch');
GO

-- *********** Orders Tables
CREATE TABLE Orders
(
    Id INT IDENTITY(1, 1) CONSTRAINT PK_order PRIMARY KEY,
    CreateDate DATE NOT NULL,
    SalesmanID INT CONSTRAINT FK_orders_to_salesman FOREIGN KEY REFERENCES Salesman(Id),
    CustomerId INT CONSTRAINT FK_orders_to_customer FOREIGN KEY REFERENCES Customers(Id),
);
GO

INSERT INTO Orders
    (CreateDate, SalesmanID, CustomerId)
VALUES
    ('2023-04-05', 1, 3),
    ('2023-04-05', 3, 1),
    ('2023-04-05', 2, 5),
    ('2023-04-05', 2, 4),
    ('2023-04-05', 3, 4);
GO

-- *********** OrderDetail table
CREATE TABLE OrderDetail
(
    OrderId INT CONSTRAINT FK_orderDetail_to_order FOREIGN KEY REFERENCES Orders(ID),
    ProductID INT CONSTRAINT FK_orderDetail_to_products FOREIGN KEY REFERENCES Products(ID),
    Quantity INT CONSTRAINT Check_quantity_prd_orderDetail CHECK(Quantity >= 0)
);
GO

INSERT INTO OrderDetail
    (OrderId, ProductID, Quantity)
VALUES
    (1, 3, 3),
    (2, 2, 3),
    (2, 1, 5),
    (3, 5, 7),
    (4, 7, 1),
    (5, 8, 2);
GO

-- *********** LIKE 
-- % Đại diện cho không, một hoặc nhiều ký tự. ​
-- _ thể hiện một ký tự.

-- tìm kiếm sản phẩm có 2 chữ O trong tên sản phẩm
SELECT *
FROM Products
WHERE Name LIKE '%O%O%'

-- tìm kiếm sản phẩm có 'hone 13' ở cuối và đứng trước 'hone 13' là 2 ký tự bất kỳ
SELECT *
FROM Products
WHERE Name LIKE '__hone 13'

-- tìm kiếm sản phẩm có tên bắt đầu bằng 1 ký tự bất kỳ, sau ký tự đầu tiên là chữ 'e' sản phẩm 
SELECT *
FROM Products
WHERE Name LIKE '_e%'


-- *********** CONVERT, CAST
SELECT CONVERT(DATE, '20230405')
SELECT CAST('20230405' AS DATE)


-- *********** INNER JOIN
-- lấy ra thông tin đơn hàng gồm Id đơn hàng, tên khách hàng, tên nhân viên, tên sản phẩm, giá bán, số lượng, tổng tiền
SELECT
    Od.OrderId,
    C.Name AS N'Customer Name',
    S.Name AS N'Salesman Name',
    P.Name AS N'Product Name',
    P.Price,
    Od.Quantity,
    Od.Quantity * P.Price AS 'Total price'
FROM
    OrderDetail AS Od
    INNER JOIN Products AS P ON Od.ProductID = P.Id
    INNER JOIN Orders AS O ON Od.OrderId = O.Id
    INNER JOIN Salesman AS S ON O.SalesmanID = S.Id
    INNER JOIN Customers AS C ON O.CustomerId = C.Id;
GO

-- *********** FULL OUTER JOIN
SELECT * 
FROM 
    Orders AS O FULL OUTER JOIN Customers AS C
    ON O.CustomerId = C.Id;
GO

-- *********** LEFT - RIGHT JOIN
-- lấy ra tất cả các bản ghi bảng Customers và đơn hàng của từng khách hàng, khác hàng nào không có thì đơn hàng trả về null
SELECT * 
FROM 
    Customers AS C LEFT JOIN Orders AS O
    ON C.Id = O.CustomerId;
GO

-- lấy ra tất cả các bản ghi bảng Salesman và đơn hàng của từng Salesman, Salesman nào không có thì đơn hàng trả về null
SELECT * 
FROM 
    Orders AS O RIGHT JOIN Salesman AS S
    ON S.Id = O.SalesmanID;
GO

-- *********** SUM, AVG
-- Tổng số lượng đơn hàng và trung bình giá bán các sản phẩm
SELECT 
    SUM(Quantity) AS 'Quantity', 
    AVG(Price) AS 'Average' 
FROM 
    Products;
GO