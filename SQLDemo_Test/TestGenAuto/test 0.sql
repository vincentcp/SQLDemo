CREATE PROCEDURE [GenAutoTest].[test 0]
AS
BEGIN 
EXEC tSQLt.AssertEquals @Actual=1, @Expected=1
END