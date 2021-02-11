CREATE PROCEDURE [GenAutoTest].[test master package 1]
AS 
BEGIN

	IF object_id('[GenAutoTest].expected') IS NOT NULL DROP TABLE [GenAutoTest].expected
	
	CREATE TABLE [GenAutoTest].expected (
		[Id] INT NOT NULL PRIMARY KEY, 
		 [Name] NCHAR(10) NULL
	)
	INSERT INTO [GenAutoTest].expected 
	VALUES 
		(1,'v')
		, (2,'c')

	EXEC tSQLt.FakeTable @TableName=N'vcoppe.VC'
	EXEC tSQLt.FakeTable @TableName=N'vcoppe.CV'
	INSERT INTO vcoppe.VC
	SELECT * FROM [GenAutoTest].expected 

	EXEC tSQLt.AssertEmptyTable @TableName=N'vcoppe.CV', @Message=N'Message'

	EXEC [GenAutoTest].[exec package]
		@folder_name = 'SQLDemo'
		, @project_name = 'Integration Services Project' 
		, @environment_name = 'trialEnv'

	
	EXEC tSQLt.AssertEqualsTable 
		@expected= N'[GenAutoTest].expected'
		, @actual=N'vcoppe.VC'
		, @message=N'mymessage'
		, @FailMsg=N'FailMsg'

	EXEC tSQLt.AssertEqualsTable 
		@expected= N'[GenAutoTest].expected'
		, @actual=N'vcoppe.CV'
		, @message=N'mymessage'
		, @FailMsg=N'FailMsg'
END