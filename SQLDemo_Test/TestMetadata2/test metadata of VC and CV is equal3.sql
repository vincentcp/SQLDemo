CREATE PROCEDURE [TestMetadata2].[test metadata of VC and CV is equal3]
AS
BEGIN
	EXEC tSQLt.AssertResultSetsHaveSameMetadata 
		'select top(0) * from vcoppe.CV', 'select top(0) * from vcoppe.VCP'
END
