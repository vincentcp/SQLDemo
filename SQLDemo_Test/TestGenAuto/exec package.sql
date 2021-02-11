CREATE PROCEDURE [GenAutoTest].[exec package]
	@folder_name sysname
	, @project_name sysname
	, @environment_name sysname
	, @package_name nvarchar(260) = N'master.dtsx'
	, @debug bit = 0
AS
BEGIN
DECLARE
	@reference_id bigint
	, @project_id bigint
	, @execution_id bigint

SELECT @project_id=[project_id] FROM [SSISDB].[catalog].[projects] WHERE [name]=@project_name
SELECT @reference_id=[reference_id] 
FROM [SSISDB].[catalog].[environment_references] 
WHERE project_id=@project_id 
	and environment_name=@environment_name
	and reference_type='R'

EXEC [SSISDB].[catalog].[create_execution] 
	@folder_name=@folder_name
	, @project_name=@project_name
	, @package_name='master.dtsx'
	, @reference_id=@reference_id
	, @use32bitruntime=0,@runinscaleout=null
	, @useanyworker=1
	, @execution_id=@execution_id OUTPUT
IF @debug=1 SELECT @execution_id

EXEC [SSISDB].[catalog].[start_execution] @execution_id=@execution_id

WAITFOR DELAY '00:00:05'


END