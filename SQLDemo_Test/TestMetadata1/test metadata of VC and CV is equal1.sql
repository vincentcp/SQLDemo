CREATE PROCEDURE [TestMetadata1].[test metadata of VC and CV is equal1]
AS
BEGIN
	EXEC tSQLt.AssertResultSetsHaveSameMetadata 
		'select top(0) Id from vcoppe.CV', 'select top(0) Id from vcoppe.VC'
END
