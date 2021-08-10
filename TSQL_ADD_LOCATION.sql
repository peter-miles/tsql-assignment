USE TSQL_ASSIGNMENT;
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

EXEC ADD_LOCATION;

SELECT * FROM TABLE_NAME;