-- **************** STORED PROCEDURE ******************
	-- Tái sử dụng
	-- Thực thi nhanh hơn vì Stored Procedure sẽ được biên dịch và lưu vào bộ nhớ khi được tạo ra

USE SALES_MANAGER
GO

-- ********* Tạo PROCEDURE

-- Tạo procedure lấy sản phẩm bởi Id
CREATE PROCEDURE FindProductById(
	@Id AS INT
)
AS
BEGIN
	SELECT *
	FROM Products
	WHERE Id = @Id
END;
GO

EXEC FindProductById 3;
GO

-- Tạo procedure tìm kiếm sản phẩm theo tên
CREATE PROCEDURE FindProductByName(
	@Name AS VARCHAR(255)
)
AS
BEGIN
	SELECT *
	FROM Products
	WHERE Name LIKE CONCAT('%', @Name, '%');
END;
GO

EXECUTE FindProductByName N'o';
GO

-- ********* Sửa PROCEDURE 
ALTER PROCEDURE FindProductByName(
	@Name AS VARCHAR(255),
	@Total AS INT OUTPUT
)
AS
BEGIN
	SELECT *
	FROM Products
	WHERE Name LIKE CONCAT('%', @Name, '%');

	SET @Total = @@ROWCOUNT
END;
GO

BEGIN
	DECLARE @Total AS INT;
	EXEC FindProductByName N'o', @Total OUTPUT;
	SELECT @Total AS 'Total'
END;

-- ********* Xóa PROCEDURE 
-- DROP PROCEDURE FindProductByName;