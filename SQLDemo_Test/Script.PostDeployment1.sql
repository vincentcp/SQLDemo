/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
TRUNCATE TABLE vcoppe.VC 
INSERT INTO vcoppe.VC 
VALUES 
    (1,'b')
    , (2,'d')

TRUNCATE TABLE vcoppe.CV
INSERT INTO vcoppe.CV 
VALUES 
    (3,'b')
    , (4,'d')
TRUNCATE TABLE vcoppe.VCP

IF object_id('#tmp') IS NOT NULL DROP TABLE #tmp

SELECT N'EXEC '+QUOTENAME(S.name)+'.'+QUOTENAME(P.name) [command]
INTO #tmp
FROM sys.procedures P 
INNER JOIN sys.schemas S 
ON S.schema_id=P.schema_id
WHERE 
	P.name='generate tests'
DECLARE @cmd nvarchar(max)
SET ROWCOUNT 1 
SELECT @cmd=[command] FROM #tmp 
WHILE @@ROWCOUNT<>0 
BEGIN 
	SET ROWCOUNT 0
	EXEC sp_executesql @cmd
	SET ROWCOUNT 1 
	DELETE FROM #tmp WHERE [command]=@cmd
END
SET ROWCOUNT 0
DROP TABLE #tmp
