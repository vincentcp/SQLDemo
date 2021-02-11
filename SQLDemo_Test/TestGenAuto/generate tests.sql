CREATE PROCEDURE [GenAutoTest].[generate tests]
AS
BEGIN


DECLARE @cmd nvarchar(max) = N'
CREATE OR ALTER PROCEDURE [GenAutoTest].[test 1]
AS BEGIN
EXEC tSQLt.AssertEquals @Actual=0, @Expected=0
END'

EXEC sp_executesql @cmd
SET @cmd = REPLACE(@cmd,'1','2')
EXEC sp_executesql @cmd



END