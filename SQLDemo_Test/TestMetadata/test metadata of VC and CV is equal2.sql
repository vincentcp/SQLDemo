CREATE PROCEDURE [TestMetadata].[test metadata of VC and CV is equal2]
AS
BEGIN
	EXEC tSQLt.AssertResultSetsHaveSameMetadata 
		'select top(0) * from vcoppe.CV', 'select top(0) * from vcoppe.VC'
END
