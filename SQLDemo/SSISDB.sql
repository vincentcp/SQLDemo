DECLARE 
	@folder_name_project sysname = 'SQLDemo'
	, @folder_name_global sysname = 'GlobalDemo'
	, @project_name sysname = 'Integration Services Project'
	, @environment_name_project sysname = 'trialEnv'
	, @environment_name_global sysname = 'trialEnvG'
	, @folder_id_global bigint
	, @folder_id_project bigint
	, @environment_id_project bigint
	, @environment_id_global bigint
	, @project_id bigint
	, @reference_id_project bigint
	, @reference_id_global bigint
	, @validation_id bigint


-- Create folder of project and global environment if not exists
SELECT @folder_id_global=[folder_id] FROM [SSISDB].[catalog].[folders] WHERE name = @folder_name_global
IF @folder_id_global IS NULL 
	EXEC [SSISDB].[catalog].[create_folder] 
		@folder_name=@folder_name_global
		, @folder_ID = @folder_id_global OUTPUT
SELECT @folder_id_project=[folder_id] FROM [SSISDB].[catalog].[folders] WHERE name = @folder_name_project
IF @folder_id_global IS NULL 
	EXEC [SSISDB].[catalog].[create_folder] 
		@folder_name=@folder_name_project
		, @folder_ID = @folder_id_project OUTPUT
-- Assert project is present
SELECT @project_id=[project_id] FROM [SSISDB].[catalog].[projects] WHERE name=@project_name
IF @project_id IS NULL
	RAISERROR('The project is not available',16,1)
-- Create environment in project folder and in global folder
IF NOT EXISTS (SELECT TOP 1 1 FROM [SSISDB].[catalog].[environments] WHERE name = @environment_name_project and folder_id=@folder_id_project)
	EXEC [SSISDB].[catalog].[create_environment] 
		@folder_name=@folder_name_project
		, @environment_name = @environment_name_project
IF NOT EXISTS (SELECT TOP 1 1 FROM [SSISDB].[catalog].[environments] WHERE name = @environment_name_global and folder_id=@folder_id_global)
	EXEC [SSISDB].[catalog].[create_environment] 
		@folder_name=@folder_name_global
		, @environment_name = @environment_name_global

SELECT @environment_id_project=[environment_id] FROM [SSISDB].[catalog].[environments] WHERE name = @environment_name_project and folder_id=@folder_id_project
SELECT @environment_id_global=[environment_id] FROM [SSISDB].[catalog].[environments] WHERE name = @environment_name_global and folder_id=@folder_id_global
-- Reference the two environments in the project
SELECT @reference_id_project=[reference_id] 
FROM [SSISDB].[catalog].[environment_references] 
WHERE project_id=@project_id 
	and environment_name=@environment_name_project 
	and reference_type='R'
IF @reference_id_project IS NULL 
	EXEC [SSISDB].[catalog].[create_environment_reference] 
		@folder_name = @folder_name_project 
		, @project_name = @project_name
		, @environment_name = @environment_name_project
		, @reference_type = 'R'
		, @reference_id = @reference_id_project OUTPUT
/*
SELECT @reference_id_global=[reference_id] 
FROM [SSISDB].[catalog].[environment_references] 
WHERE project_id=@project_id 
	and environment_name=@environment_name_project 
	and environment_folder_name=@folder_name_global
	and reference_type='A'
IF @reference_id_global IS NULL 
	EXEC [SSISDB].[catalog].[create_environment_reference] 
		@folder_name = @folder_name_project 
		, @project_name = @project_name
		, @environment_name = @environment_name_project
		, @reference_type = 'A'
		, @environment_folder_name = @folder_name_global
		, @reference_id = @reference_id_project OUTPUT
*/
-- Set variables in global environment


IF NOT EXISTS (
	SELECT TOP 1 1 FROM [SSISDB].[catalog].[environment_variables] where environment_id=@environment_id_global and name='myFavoriteName')
	EXEC [SSISDB].[catalog].[create_environment_variable] 
		@folder_name = @folder_name_global 
		, @environment_name = @environment_name_global
		, @variable_name = 'myFavoriteName'
		, @data_type = 'String'
		, @sensitive = 0
		, @value = N''
IF NOT EXISTS (
	SELECT TOP 1 1 FROM [SSISDB].[catalog].[environment_variables] where environment_id=@environment_id_global and name='myFavoriteNumber')
	EXEC [SSISDB].[catalog].[create_environment_variable] 
		@folder_name = @folder_name_global 
		, @environment_name = @environment_name_global
		, @variable_name = 'myFavoriteNumber'
		, @data_type = 'Int64'
		, @sensitive = 0
		, @value = 0
EXEC [SSISDB].[catalog].[set_environment_variable_value] 
	@folder_name = @folder_name_global 
	, @environment_name = @environment_name_global
	, @variable_name = 'myFavoriteNumber'
	, @value = 3
EXEC [SSISDB].[catalog].[set_environment_variable_value] 
	@folder_name = @folder_name_global 
	, @environment_name = @environment_name_global
	, @variable_name = 'myFavoriteName'
	, @value = N'3'

IF NOT EXISTS (
	SELECT TOP 1 1 FROM [SSISDB].[catalog].[environment_variables] where environment_id=@environment_id_project and name='Param_conmgr_DB')
	EXEC [SSISDB].[catalog].[create_environment_variable] 
		@folder_name = @folder_name_project
		, @environment_name = @environment_name_project
		, @variable_name = 'Param_conmgr_DB'
		, @data_type = 'String'
		, @sensitive = 0
		, @value = N''

IF NOT EXISTS (
	SELECT TOP 1 1 FROM [SSISDB].[catalog].[environment_variables] where environment_id=@environment_id_project and name='Param_conmgr_ServerName')
	EXEC [SSISDB].[catalog].[create_environment_variable] 
		@folder_name = @folder_name_project
		, @environment_name = @environment_name_project
		, @variable_name = 'Param_conmgr_ServerName'
		, @data_type = 'String'
		, @sensitive = 0
		, @value = N''

EXEC [SSISDB].[catalog].[set_environment_variable_value] 
	@folder_name = @folder_name_project
	, @environment_name = @environment_name_project
	, @variable_name = 'Param_conmgr_DB'
	, @value =N'SQLDemo_DEV'
EXEC [SSISDB].[catalog].[set_environment_variable_value] 
	@folder_name = @folder_name_project
	, @environment_name = @environment_name_project
	, @variable_name = 'Param_conmgr_ServerName'
	, @value = N'localhost'

EXEC [SSISDB].[catalog].[set_object_parameter_value] 
	@object_type=20
	, @folder_name=@folder_name_project
	, @project_name=@project_name
	, @parameter_name=N'Param_conmgr_DB'
	, @value_type=R
	, @parameter_value=N'Param_conmgr_DB'

EXEC [SSISDB].[catalog].[set_object_parameter_value] 
	@object_type=20 
	, @folder_name=@folder_name_project
	, @project_name=@project_name
	, @parameter_name=N'Param_conmgr_ServerName'
	, @value_type=R
	, @parameter_value=N'Param_conmgr_ServerName'

SELECT * FROM [SSISDB].[catalog].[object_parameters]

EXEC [SSISDB].[catalog].[validate_project]
	@folder_name=@folder_name_project
	, @project_name=@project_name
--	, @validate_type=F
	, @validation_id=@validation_id OUTPUT
	, @environment_scope=A
SELECT @validation_id

