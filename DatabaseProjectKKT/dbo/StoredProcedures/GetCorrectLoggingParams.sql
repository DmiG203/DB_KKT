-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCorrectLoggingParams] (
	 @DisplayMode				int OUTPUT 
	,@Log_level					int OUTPUT 
	,@Logging_type				int OUTPUT 
	,@Logging_files_count		int OUTPUT 
	,@Logging_max_file_size		int OUTPUT 
	,@PC_ID						int				
	,@Config_ID					int
	)
AS
BEGIN
	IF @PC_ID IS NOT NULL AND @Config_ID IS NOT NULL
		BEGIN
			SET @DisplayMode			= (SELECT DisplayMode			FROM Premiera_Config WHERE CompID = @PC_ID AND ID = @Config_ID)
			SET @Log_level				= (SELECT POS_log_level			FROM Premiera_Config WHERE CompID = @PC_ID AND ID = @Config_ID)
			SET @Logging_type			= (SELECT Logging_type			FROM Premiera_Config WHERE CompID = @PC_ID AND ID = @Config_ID)
			SET @Logging_files_count	= (SELECT Logging_files_count	FROM Premiera_Config WHERE CompID = @PC_ID AND ID = @Config_ID)
			SET @Logging_max_file_size	= (SELECT Logging_max_file_size FROM Premiera_Config WHERE CompID = @PC_ID AND ID = @Config_ID)
		END;
	ELSE
		BEGIN
			SET @DisplayMode			= -1
			SET @Log_level				= -1
			SET @Logging_type			= -1
			SET @Logging_files_count	= -1
			SET @Logging_max_file_size	= -1
			RETURN 0
		END;
END;

GO

