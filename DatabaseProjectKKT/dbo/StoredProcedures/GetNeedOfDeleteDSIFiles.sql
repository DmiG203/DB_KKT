-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetNeedOfDeleteDSIFiles] (
	 @IsNeedOfDelete	bit OUTPUT 
	,@PC_ID				int				
	,@Config_ID			int
	)
AS
BEGIN
	IF @PC_ID IS NOT NULL AND @Config_ID IS NOT NULL
		BEGIN
			SET @IsNeedOfDelete = (SELECT Is_need_of_delete_dsi_files FROM Premiera_Config WHERE CompID = @PC_ID AND ID = @Config_ID)
		END;
	ELSE
		BEGIN
			SET @IsNeedOfDelete = 0
			RETURN 0
		END;
END;

GO

