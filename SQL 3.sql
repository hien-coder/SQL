-- TRUY VẤN LỒNG (SUB QUERY)
-- DECLARE PARAMETER
-- UNION
-- GROUP BY
-- SLECT INTO
-- INTO INSER SELECT

USE SALES_MANAGER;
GO

-- *********** TRUY VẤN LỒNG (SUB QUERY)
-- Lấy ra tất cả điện thoại có giá bán lớn giá bán của Redmi Q7(ID = 13)
SELECT 
    Id, Name, Price
FROM 
    Products 
WHERE 
    Price > (
        SELECT 
            PRICE 
        FROM 
            Products 
        WHERE ID = 13
    );
GO

-- *********** GROUP BY
    -- HAVING tương tự như WHERE, 
    -- HAVING sẽ đi cùng GROUP BY
    -- HAVING Lọc dữ liệu sau GROUP BY còn WHERE lọc dữ liệu trước GROUP BY

-- lấy ra tổng tiền của từng đơn hàng
SELECT 
    Od.OrderId,
    SUM(P.Price * Od.Quantity) AS 'Total'
FROM
    OrderDetail AS Od INNER JOIN Products AS P
    ON Od.ProductID = P.Id
GROUP BY 
    Od.OrderId;
GO

-- lấy ra tổng tiền của đơn hàng có ID là 3
SELECT 
    Od.OrderId,
    SUM(P.Price * Od.Quantity) AS 'Total'
FROM
    OrderDetail AS Od INNER JOIN Products AS P
    ON Od.ProductID = P.Id
GROUP BY 
    Od.OrderId
HAVING 
    Od.OrderId = 3
GO


-- *********** DECLARE PARAMETER
-- Khai báo biến và sử dụng biến
DECLARE @Price AS INT 
SET @Price = 3500000
PRINT @Price
GO

-- Lưu trữ câu truy vấn vào biến
DECLARE @P AS INT
SET @P = (SELECT Price FROM Products WHERE ID = 13)
PRINT @P
GO

-- Gán giá trị vào biến ở lệnh SELECT
DECLARE @a AS INT
SELECT @a = Price FROM Products WHERE ID = 12
SELECT @a
SELECT * FROM Products WHERE Price >= @a;
GO

-- *********** UNION
-- lấy ra ID và tên của các khách hàng và nhân viên
SELECT * FROM Customers
UNION
SELECT * FROM Salesman

-- *********** Backup Data
-- SELECT INTO (tự động tạo ra 1 table mới vào copy dữ liệu sang)
SELECT * INTO ProductBackUp FROM Products
SELECT * FROM ProductBackUp

-- INSERT INTO (tạo ra một bảng rồi copy data từ bảng cũ vào bảng mới vừa tạo)
CREATE TABLE ProductsName
(
    Name NVARCHAR(255)
)

INSERT INTO ProductsName
SELECT Name from Products

SELECT * FROM ProductsName