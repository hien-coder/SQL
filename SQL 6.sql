-- **************** FUNCTION ******************
    -- FUNCTION có kết quả trả về 
    -- Tái sử dụng
    -- Function trong SQL có thể được lưu ở nhiều địa điểm khác nhau

-- Một số địa điểm phổ biến để lưu trữ function trong SQL là:
    -- Schema: Function được lưu trong schema của database. Nếu bạn có quyền truy cập vào schema, bạn có thể sử dụng function.
    -- Code file: Function được lưu trữ trong một file code như SQL script, stored procedure hoặc package. Khi cần sử dụng function, bạn chỉ cần chạy script hoặc gọi procedure.
    -- User-defined library: Nếu bạn có một số function được sử dụng thường xuyên trong nhiều ứng dụng, bạn có thể lưu chúng trong một thư viện riêng biệt. Thư viện này có thể được xây dựng và quản lý bởi các nhà phát triển hoặc DBA.
    -- Application code: Nếu function được sử dụng trong một ứng dụng đặc biệt, chúng có thể được lưu trữ trong code của ứng dụng.

USE SALES_MANAGER
GO

-- ********* Tạo FUCNTION
-- tạo function lấy tổng tiền đơn hàng theo Id

-- return Scalar-value
CREATE FUNCTION dbo.GetTotalOrderAmount(
    @Id AS INT
)
RETURNS INT 
AS
BEGIN
    DECLARE @Result AS INT;
    SET @Result = (
        SELECT SUM(TotalPrice)
        FROM ShowInfoOders
        GROUP BY OrderId
        HAVING OrderId = @Id
    );

    RETURN @Result;
END;
GO

SELECT dbo.GetTotalOrderAmount(1) AS 'TotalAmount';
GO

-- return Table-valued
CREATE FUNCTION dbo.GetOrderInfoByCustomerId(
    @CustomerId AS INT
)
RETURNS TABLE
AS
    RETURN 
        SELECT 
            OrderId, 
            CustomerId, 
            CustomerName, 
            ProductName,
            Quantity
        FROM ShowInfoOders 
        WHERE CustomerId = @CustomerId
GO

SELECT * FROM dbo.GetOrderInfoByCustomerId(1);
GO

-- ********* Sửa FUCNTION
ALTER FUNCTION dbo.GetOrderInfoByCustomerId(
    @CustomerId AS INT
)
RETURNS TABLE
AS
    RETURN 
        SELECT 
            OrderId, 
            CustomerId, 
            CustomerName, 
            ProductName,
            Price,
            Quantity,
            TotalPrice
        FROM ShowInfoOders 
        WHERE CustomerId = @CustomerId
GO

SELECT * FROM dbo.GetOrderInfoByCustomerId(1);
GO

-- ********* Xóa FUCNTION
-- DROP FUNCTION dbo.GetTotalOrderAmount;