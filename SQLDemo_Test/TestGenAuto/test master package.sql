CREATE PROCEDURE [GenAutoTest].[test master package]
AS 
BEGIN
	IF object_id('[GenAutoTest].expected') IS NOT NULL DROP TABLE [GenAutoTest].expected
	
	CREATE TABLE [GenAutoTest].expected (
		[Id] INT NOT NULL PRIMARY KEY, 
		 [Name] NCHAR(10) NULL
	)
	INSERT INTO [GenAutoTest].expected 
	VALUES 
		(1,'b')
		, (2,'d')

	TRUNCATE TABLE vcoppe.CV
	EXEC tSQLt.AssertEmptyTable @TableName=N'vcoppe.CV', @Message=N'Message'
	EXEC tSQLt.AssertEqualsTable 
		@expected= N'[GenAutoTest].expected'
		, @actual=N'vcoppe.VC'
		, @message=N'mymessage before run VC'
		, @FailMsg=N'FailMsg'

	EXEC [GenAutoTest].[exec package]
		@folder_name = 'SQLDemo'
		, @project_name = 'Integration Services Project' 
		, @environment_name = 'trialEnv'

	
	EXEC tSQLt.AssertEqualsTable 
		@expected= N'[GenAutoTest].expected'
		, @actual=N'vcoppe.VC'
		, @message=N'mymessage after run VC'
		, @FailMsg=N'FailMsg'

	EXEC tSQLt.AssertEqualsTable 
		@expected= N'[GenAutoTest].expected'
		, @actual=N'vcoppe.CV'
		, @message=N'mymessage after run CV'
		, @FailMsg=N'FailMsg'
END