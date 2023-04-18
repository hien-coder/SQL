-- BEGIN – END
-- IF – ELSE
-- Temporary Table
-- VIEW
-- CTE-Common Table Expression
-- CASE WHERE

USE SALES_MANAGER;
GO

-- *********** BEGIN-END và IF - ELSE
-- lấy ra tên và giá bán của sản phẩm bằng Id
BEGIN 
    DECLARE @id AS INT = 1

    DECLARE @Quantity AS INT 
    SET @Quantity = (SELECT Quantity FROM Products WHERE Id = @id)

    IF @Quantity = 0
        PRINT N'Sản phẩm đã hết hàng'
    ELSE
        SELECT 
            Name, Quantity 
        FROM
            Products 
        WHERE Id = @id
END;
GO

-- lấy ra tên, giá bán, Số lượng của sản phẩm có giá bán cao nhất
BEGIN 
    DECLARE @maxPrice AS INT
    SET @maxPrice = (SELECT MAX(Price) FROM Products)

    IF @maxPrice < 0
        PRINT N'Giá bán của sản phẩm có giá bán cao nhất đang âm !'
    ELSE IF @maxPrice = 0
        PRINT N'Giá bán tất cả sản phẩm đều bằng 0 !'
    ELSE
        SELECT 
            Name, Price, Quantity 
        FROM 
            Products 
        WHERE 
            Price = @maxPrice;
END;
GO

-- *********** Temporary Table (Được tạo ra trong 1 phiên làm việc)
-- Local Temporary Table: 
    -- chỉ tồn tại trong một phiên làm việc
    -- chỉ sử dụng được bởi người dùng truy cập cùng phiên làm việc đó.
SELECT * INTO #SalesmantLocalTemp FROM Salesman;
SELECT * FROM #SalesmantLocalTemp;
GO

-- Global Temporary Table(Hạn chế dùng, có thể dẫn đến rủi ro về dữ liệu): 
    -- chỉ tồn tại trong một phiên làm việc 
    -- Có thể được sử dụng bởi nhiều người dùng khách nhau truy cập cùng phiên làm việc đó.
SELECT * INTO ##SalesmantGlobalTemp FROM Salesman;
SELECT * FROM ##SalesmantGlobalTemp;
GO

-- *********** VIEW
    -- Chức năng tương tự như một bảng
    -- là một bảng ảo
    -- Được sử dụng để truy xuất dữ liệu.

-- Khác nhau giữa view và table
    -- Table chứa dữ liệu, còn View không.
    -- Table được lưu trữ trên đĩa cứng, View chỉ tồn tại trong bộ nhớ tạm.
    -- Table có thể được sử dụng để thêm, xóa và sửa đổi dữ liệu, View chỉ được sử dụng để truy xuất dữ liệu.

-- Tạo 1 view để hiển thị đơn hàng
CREATE VIEW ShowInfoOders AS
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

-- Hiển thị tất cả đơn hàng
SELECT * FROM ShowInfoOders;

-- Tổng tiền các đơn hàng
SELECT SUM([Total price]) FROM ShowInfoOders;
GO

-- Sửa VIEW 
ALTER VIEW ShowInfoOders AS
SELECT
    Od.OrderId,
    O.CustomerId,
    C.Name AS N'CustomerName',
    O.SalesmanID,
    S.Name AS N'SalesmanName',
    P.Name AS N'ProductName',
    P.Price,
    Od.Quantity,
    Od.Quantity * P.Price AS 'TotalPrice'
FROM
    OrderDetail AS Od
    INNER JOIN Products AS P ON Od.ProductID = P.Id
    INNER JOIN Orders AS O ON Od.OrderId = O.Id
    INNER JOIN Salesman AS S ON O.SalesmanID = S.Id
    INNER JOIN Customers AS C ON O.CustomerId = C.Id;
GO

SELECT * FROM ShowInfoOders;
GO

-- xóa View 
-- DROP VIEW ShowInfoOders

-- ***********  CTE-Common Table Expression
    -- CTE có thể được xem như một bảng chứa dữ liệu tạm thời.
    -- Tạo truy vấn đệ quy (recursive query).
    -- Sử dụng được nhiều CTE trong một truy vấn duy nhất
    -- Nó không được lưu trữ 
    -- Chỉ kéo dài trong suốt thời gian của câu truy vấn.
WITH ProductCTE AS
(
    SELECT Id, Name, Price FROM Products
)
SELECT * FROM ProductCTE;
GO

-- *********** CASE WHERE
CREATE TABLE #Employee (
    Name NVARCHAR(255),
    Level NVARCHAR(50)
);
GO

INSERT INTO #Employee 
    (Name, Level)
VALUES
    (N'Văn Hiền', 'Intern'),
    (N'Thanh Huyền', 'Fresher'),
    (N'Hồng Ngọc', 'Junior'),
    (N'Thanh Tùng', null);
GO

SELECT
    Name,
    Level,
    CASE 
        WHEN Level = 'Intern' THEN 2000000
        WHEN Level = 'Fresher' THEN 5000000
        WHEN Level = 'Junior' THEN 12000000
        ELSE 0
    END AS 'Salary'
FROM 
    #Employee;
GO