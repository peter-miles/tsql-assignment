USE TSQL_ASSIGNMENT;
GO

IF OBJECT_ID('ADD_CUSTOMER') IS NOT NULL
DROP PROCEDURE ADD_CUSTOMER;
-- 2016 or later
-- DROP IF EXISTS PROCEDURE ADD_CUSTOMER; 
GO -- to separate above code

CREATE PROCEDURE ADD_CUSTOMER @PCUSTID INT, @PCUSTNAME NVARCHAR(100) AS 

BEGIN
    BEGIN TRY

        IF @PCUSTID < 1 OR @PCUSTID > 499
            THROW 50020, 'Customer ID out of range', 1 -- use 1 everytime 

        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS) -- if within range insert record into table
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK'); -- end 2 values default

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

EXEC ADD_CUSTOMER @pcustid = 1, @pcustname = 'customer';

select * from customer;