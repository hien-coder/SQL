/*  syntax 
        {ALTER | CREATE} TRIGGER <trigger name> ON <table name>
        {FOR | AFTER} {DELETE, INSERT, UPDATE}
        AS  
        BEGIN

        END
        GO

        -- FOR: sẽ được kích hoạt trước khi bất kỳ hành động nào được thực hiện trên bảng đó
        -- AFTER: sẽ được kích hoạt sau khi bất kỳ hành động nào được thực hiện trên bảng đó
*/

USE SALES_MANAGER
GO

CREATE TRIGGER TriggerByProduct ON OrderDetail 
AFTER INSERT
AS 
BEGIN
    DECLARE 
        @PrdId AS INT, 
        @QuantityInert AS INT, 
        @QuantityPrd AS INT;

    -- Lấy dữ liệu được instert
    SELECT
        @PrdId = ProductID,
        @QuantityInert = Quantity
    FROM inserted;

    -- Lây ra số lượng sản phẩm bởi Id trong bản Products
    SET @QuantityPrd = (SELECT Quantity FROM Products WHERE Id = @PrdId)

    IF @QuantityPrd > 0 AND @QuantityInert <= @QuantityPrd
        BEGIN
            -- Cập nhật lại trong bảng Product
            UPDATE Products
            SET Quantity = Quantity - @QuantityInert
            WHERE Id = @PrdId
        END
    ELSE
        PRINT N'Sản Phẩm không đủ số lượng'
END;

SELECT * FROM Products
INSERT INTO OrderDetail 
    (OrderId, ProductID, Quantity)
VALUES 
    (3, 1, 5)
SELECT * FROM Products

DROP TRIGGER TriggerByProduct;