IF OBJECT_ID('ADD_CUSTOMER') IS NOT NULL
DROP PROCEDURE ADD_CUSTOMER;
GO

CREATE PROCEDURE ADD_CUSTOMER @PCUSTID INT, @PCUSTNAME NVARCHAR(100) AS 
BEGIN
    BEGIN TRY
        IF @PCUSTID < 1 OR @PCUSTID > 499
            THROW 50020, 'Customer ID out of range', 1

        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS) 
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK'); 
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 2627 
            THROW 50010, 'Duplicate customer ID', 1
        ELSE IF ERROR_NUMBER() = 50020
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;
END;
GO

IF OBJECT_ID('DELETE_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_CUSTOMERS;
GO 

CREATE PROCEDURE DELETE_ALL_CUSTOMERS AS 
BEGIN
    BEGIN TRY
        DELETE FROM CUSTOMER WHERE CUSTID > 0 AND CUSTID < 500;
        SELECT @@ROWCOUNT;
    END TRY
    BEGIN CATCH
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
        END; 
    END CATCH
END;
GO

IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT;
GO

CREATE PROCEDURE ADD_PRODUCT @PPRODID INT, @PPRODNAME NVARCHAR(100), @PPRICE MONEY AS
BEGIN
    BEGIN TRY
        IF @PPRODID < 1000 OR @PPRODID > 2500
            THROW 50040, 'Product ID out of range', 1

        IF @PPRICE < 0 OR @PPRICE > 999.99
            THROW 50050, 'Price out of range', 1

        INSERT INTO PRODUCT(PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
        VALUES(@PPRODID, @PPRODNAME, @PPRICE, 0)
    END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 2627 
            THROW 50030, 'Duplicate product ID', 1
        ELSE IF ERROR_NUMBER() = 50040
            THROW
        ELSE IF ERROR_NUMBER() = 50050
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;
END;
GO

IF OBJECT_ID('DELETE_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_PRODUCTS;
GO 

CREATE PROCEDURE DELETE_ALL_PRODUCTS AS 
BEGIN
    BEGIN TRY
        DELETE FROM PRODUCT WHERE PRODID > 999 AND PRODID < 2501;
        SELECT @@ROWCOUNT;
    END TRY
    BEGIN CATCH
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
        END; 
    END CATCH
END;
GO

IF OBJECT_ID('GET_CUSTOMER_STRING') IS NOT NULL
DROP PROCEDURE GET_CUSTOMER_STRING;
GO 

CREATE PROCEDURE GET_CUSTOMER_STRING @PCUSTID INT, @PRETURNSTRING NVARCHAR(1000) OUTPUT AS 
BEGIN
    BEGIN TRY            
        IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @PCUSTID)
            THROW 50260, 'Customer ID not found', 1

        DECLARE @OCUSTNAME NVARCHAR(100), @OSTATUS NVARCHAR(7), @OSALES_YTD MONEY;
        SELECT @OCUSTNAME = CUSTNAME, @OSTATUS = STATUS, @OSALES_YTD = SALES_YTD FROM CUSTOMER WHERE CUSTID = @PCUSTID;
        SET @PRETURNSTRING = CONCAT('Customer ID: ', @PCUSTID, ' Name: ', @OCUSTNAME, ' Status: ', @OSTATUS, ' Sales YTD: ', @OSALES_YTD);
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50060
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;
END;
GO

IF OBJECT_ID('UPD_CUST_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_CUST_SALESYTD;
GO 

CREATE PROCEDURE UPD_CUST_SALESYTD @PCUSTID INT, @PAMT MONEY AS 
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @PCUSTID)
            THROW 50070, 'Customer ID not found', 1

        IF @PAMT < -999.99 OR @PAMT > 999.99
            THROW 50080, 'Amount out of range', 1

        UPDATE CUSTOMER SET SALES_YTD += @PAMT WHERE CUSTID = @PCUSTID
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50070
            THROW
        ELSE IF ERROR_MESSAGE() = 50080
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;
GO

IF OBJECT_ID('GET_PROD_STRING') IS NOT NULL
DROP PROCEDURE GET_PROD_STRING;
GO 

CREATE PROCEDURE GET_PROD_STRING @PPRODID INT, @PRETURNSTRING NVARCHAR(1000) OUTPUT AS 
BEGIN
    BEGIN TRY            
        IF NOT EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @PPRODID)
            THROW 50090, 'Product ID not found', 1

        DECLARE @OPRODNAME NVARCHAR(7), @OSELLING_PRICE MONEY, @OSALES_YTD MONEY;
        SELECT @OPRODNAME = PRODNAME, @OSELLING_PRICE = SELLING_PRICE, @OSALES_YTD = SALES_YTD FROM PRODUCT WHERE PRODID = @PPRODID;
        SET @PRETURNSTRING = CONCAT('Product ID: ', @PPRODID, ' Name: ', @OPRODNAME, ' Price: ', @OSELLING_PRICE, ' Sales YTD: ', @OSALES_YTD);
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50090
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;
END;
GO

IF OBJECT_ID('UPD_PROD_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_PROD_SALESYTD;
GO 

CREATE PROCEDURE UPD_PROD_SALESYTD @PPRODID INT, @PAMT MONEY AS 
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @PPRODID)
            THROW 50100, 'Product ID not found', 1

        IF @PAMT < -999.99 OR @PAMT > 999.99
            THROW 50110, 'Amount out of range', 1

        UPDATE PRODUCT SET SALES_YTD += @PAMT WHERE PRODID = @PPRODID
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50100
            THROW
        ELSE IF ERROR_MESSAGE() = 50110
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;
GO

IF OBJECT_ID('UPD_CUST_STATUS') IS NOT NULL
DROP PROCEDURE UPD_CUST_STATUS;
GO 

CREATE PROCEDURE UPD_CUST_STATUS @PCUSTID INT, @PSTATUS NVARCHAR(7) AS 
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @PCUSTID)
            THROW 50120, 'Customer ID not found', 1

        IF @PSTATUS != 'OK' OR @PSTATUS != 'SUSPEND'
            THROW 50130, 'Invalid Status value', 1

        UPDATE CUSTOMER SET STATUS = @PSTATUS WHERE CUSTID = @PCUSTID
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50120
            THROW
        ELSE IF ERROR_MESSAGE() = 50130
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;
GO

IF OBJECT_ID('ADD_SIMPLE_SALE') IS NOT NULL
DROP PROCEDURE ADD_SIMPLE_SALE;
GO 

CREATE PROCEDURE ADD_SIMPLE_SALE @PCUSTID INT, @PPRODID INT, @PQTY INT AS 
BEGIN
    BEGIN TRY
        IF @PQTY < 1 OR @PQTY > 999
            THROW 50140, 'Sale Quantity outside valid range', 1
        
        DECLARE @STATUS NVARCHAR(100);
        SELECT @STATUS = STATUS FROM CUSTOMER WHERE CUSTID = @PCUSTID;
        IF @STATUS != 'OK'
            THROW 50150, 'Customer status is not OK', 1
        
        IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @PCUSTID)
            THROW 50160, 'Customer ID not found', 1

        IF NOT EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @PPRODID)
            THROW 50170, 'Product ID not found', 1
        
        DECLARE @PRODPRICE MONEY;
        SELECT @PRODPRICE = SELLING_PRICE FROM PRODUCT WHERE PRODID = @PPRODID;
        SET @PRODPRICE *= @PQTY;

        EXEC UPD_CUST_SALESYTD @PCUSTID = @PCUSTID, @PAMT = @PRODPRICE;
        EXEC UPD_PROD_SALESYTD @PPRODID = @PPRODID, @PAMT = @PRODPRICE;
    END TRY
    BEGIN CATCH
    IF ERROR_MESSAGE() = 50140
        THROW
    ELSE IF ERROR_MESSAGE() = 50150
        THROW
    ELSE IF ERROR_MESSAGE() = 50160
        THROW
    ELSE IF ERROR_MESSAGE() = 50170
        THROW
    ELSE
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
        END; 
    END CATCH
END;
GO

IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;
GO 

CREATE PROCEDURE ADD_LOCATION @PLOCCODE NVARCHAR(5), @PMINQTY INT, @PMAXQTY INT AS 
BEGIN
    BEGIN TRY
        IF @PLOCCODE != 5
            THROW 50190, 'Location Code length invalid', 1
        
        IF @PMINQTY < 0 OR @PMINQTY > 999
            THROW 50200, 'Minimum Qty out of range', 1

        IF @PMAXQTY < 0 OR @PMAXQTY > 999
            THROW 50210, 'Maximum  Qty out of range', 1

        IF @PMINQTY > @PMAXQTY
            THROW 50220, 'Minimum Qty larger than Maximum Qty', 1

        INSERT INTO LOCATION (LOCID, MINQTY, MAXQTY)
        VALUES (@PLOCCODE, @PMINQTY, @PMAXQTY);
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 2627 
            THROW 50180, 'Duplicate location ID', 1
        ELSE IF ERROR_NUMBER() = 50190
            THROW
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
        END; 
    END CATCH
END;
GO

IF OBJECT_ID('ADD_COMPLEX_SALE') IS NOT NULL
DROP PROCEDURE ADD_COMPLEX_SALE;
GO 

CREATE PROCEDURE ADD_COMPLEX_SALE @PCUSTID INT, @PPRODID INT, @PQTY INT, @PDATE NVARCHAR(100) AS 
BEGIN
    BEGIN TRY
        IF @PQTY < 1 OR @PQTY > 999
            THROW 50230, 'Sale Quantity outside valid range', 1
        
        DECLARE @STATUS NVARCHAR(100);
        SELECT @STATUS = STATUS FROM CUSTOMER WHERE CUSTID = @PCUSTID;
        IF @STATUS != 'OK'
            THROW 50240, 'Customer status is not OK', 1

        IF LEN(@PDATE) != 8
            THROW 50250, 'Date not valid', 1
        
        IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @PCUSTID)
            THROW 50260, 'Customer ID not found', 1

        IF NOT EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @PPRODID)
            THROW 50270, 'Product ID not found', 1  

        INSERT INTO SALE (SALEID, CUSTID, PRODID, QTY, SALEDATE)
        VALUES (SALE_SEQ, @PCUSTID, @PPRODID, PQTY, SALEDATE);
    END TRY
    BEGIN CATCH
    IF ERROR_MESSAGE() = 50230
        THROW
    ELSE IF ERROR_MESSAGE() = 50240
        THROW
    ELSE IF ERROR_MESSAGE() = 50250
        THROW
    ELSE IF ERROR_MESSAGE() = 50260
        THROW
    ELSE IF ERROR_MESSAGE() = 50270
        THROW
    ELSE
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
        END; 
    END CATCH
END;
GO

IF OBJECT_ID('COUNT_RPODUCT_SALES') IS NOT NULL
DROP PROCEDURE COUNT_RPODUCT_SALES;
GO 

CREATE PROCEDURE COUNT_RPODUCT_SALES @PDAYS INT AS 
BEGIN
    BEGIN TRY
        SELECT COUNT(SALEID) FROM SALE WHERE SALEDATE >= (GETDATE() - @PDAYS);
    END TRY
    BEGIN CATCH
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
        END; 
    END CATCH
END;
GO

IF OBJECT_ID('DELETE_CUSTOMER') IS NOT NULL
DROP PROCEDURE DELETE_CUSTOMER;
GO 

CREATE PROCEDURE DELETE_CUSTOMER @PCUSTID INT AS 
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @PCUSTID)
                THROW 50290, 'Customer ID not found', 1

        IF EXISTS (SELECT * FROM SALE WHERE CUSTID = @PCUSTID)
                THROW 50300, 'Customer cannot be deleted as sales exist', 1
            
        DELETE FROM CUSTOMER WHERE CUSTID = @PCUSTID;
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50290
            THROW
        ELSE IF ERROR_MESSAGE() = 50300
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;
GO

IF OBJECT_ID('DELETE_PRODUCT') IS NOT NULL
DROP PROCEDURE DELETE_PRODUCT;
GO 

CREATE PROCEDURE DELETE_PRODUCT @PPRODID INT AS 
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @PPRODID)
                THROW 50310, 'Product ID not found', 1

        IF EXISTS (SELECT * FROM SALE WHERE PRODID = @PPRODID)
                THROW 50320, 'Product cannot be deleted as sales exist', 1
            
        DELETE FROM PRODUCT WHERE PRODID = @PPRODID;
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() = 50310
            THROW
        ELSE IF ERROR_MESSAGE() = 50320
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;
GO