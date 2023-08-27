-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddPremieraConfig] (
	 @ReturnID					int OUTPUT 
	,@PC_ID						int				
	,@Path						nvarchar(MAX)	= null
	,@Unit_ID					int				= null
	,@DisplayMode				int				= null
	,@IO_DLL					nvarchar(50)	= null
	,@POS_Log_Level				int				= null
	,@Logging_Type				int				= null
	,@Logging_Files_Count		int				= null
	,@Logging_Max_File_Size		int				= null
	)
AS
BEGIN
	DECLARE @Config_ID int
	IF @Unit_ID IS NULL
		BEGIN
			SET @Config_ID = 0
			RETURN 0
		END;
	--проверяем наличие информации
	SET @Config_ID = (SELECT ID FROM Premiera_Config WHERE CompID = @PC_ID)
	--если записи нет, добавляем запись и получаем ее ID
	IF @Config_ID IS NULL
		BEGIN
			INSERT INTO Premiera_Config (CompID, Path, Unit_ID, DisplayMode, IO_DLL, POS_log_level, Logging_type, Logging_files_count, Logging_max_file_size, Confirmation_of_changes, Is_need_of_change, Is_need_of_delete_dsi_files, Add_date, Update_date)
				VALUES(@PC_ID, @Path, @Unit_ID, @DisplayMode, @IO_DLL, @POS_Log_Level, @Logging_Type, @Logging_Files_Count, @Logging_Max_File_Size, 'Never', 0, 0,  GETDATE(), GETDATE())
			SET @Config_ID = (SELECT ID FROM Premiera_Config WHERE CompID = @PC_ID AND Unit_ID = @Unit_ID)
			SET @ReturnID = @Config_ID
		END;
	--если запись есть
	ELSE
		BEGIN
			--если обходимость обновления инфы в конфиге на компьютере <> 1, тогда обновляем все значения
			If (SELECT Is_need_of_change FROM Premiera_Config WHERE ID = @Config_ID) = 0 
			OR (SELECT Is_need_of_change FROM Premiera_Config WHERE ID = @Config_ID) IS NULL
			OR (SELECT Is_need_of_change FROM Premiera_Config WHERE ID = @Config_ID) = ''
				BEGIN
					--проверяем ее актуальность
					IF EXISTS ( SELECT Path, Unit_ID, DisplayMode, IO_DLL, POS_log_level, Logging_type, Logging_files_count, Logging_max_file_size
								FROM Premiera_Config
								WHERE CompID = @PC_ID AND ID = @Config_ID
								EXCEPT
								SELECT @Path, @Unit_ID, @DisplayMode, @IO_DLL, @POS_Log_Level, @Logging_Type, @Logging_Files_Count, @Logging_Max_File_Size)
						BEGIN
							UPDATE Premiera_Config SET Path = @Path, Unit_ID = @Unit_ID, DisplayMode = @DisplayMode, IO_DLL = @IO_DLL, POS_log_level = @POS_Log_Level,
													   Logging_type = @Logging_Type, @Logging_Files_Count = @Logging_Files_Count, Logging_max_file_size = @Logging_Max_File_Size, Update_date  = GETDATE()
								WHERE CompID = @PC_ID AND ID = @Config_ID
						END;
					ELSE
						BEGIN
							UPDATE Premiera_Config SET Update_date = GETDATE() WHERE CompID = @PC_ID AND ID = @Config_ID
						END;
				END;
			--если обходимость обновления инфы в конфиге на компьютере = 1, тогда обновляем все, кроме логирования и DisplayMode
			ELSE
				BEGIN
					--проверяем ее актуальность
					IF EXISTS ( SELECT Path, Unit_ID, IO_DLL
								FROM Premiera_Config
								WHERE CompID = @PC_ID AND ID = @Config_ID
								EXCEPT
								SELECT @Path, @Unit_ID, @IO_DLL)
						BEGIN
							UPDATE Premiera_Config SET Path = @Path, Unit_ID = @Unit_ID, IO_DLL = @IO_DLL, Update_date  = GETDATE()
								WHERE CompID = @PC_ID AND ID = @Config_ID
						END;
					ELSE
						BEGIN
							UPDATE Premiera_Config SET Update_date = GETDATE() WHERE CompID = @PC_ID AND ID = @Config_ID
						END;
				END;
			SET @ReturnID = @Config_ID
		END;

END;

GO

