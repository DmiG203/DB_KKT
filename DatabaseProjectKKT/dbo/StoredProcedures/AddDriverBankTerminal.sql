-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddDriverBankTerminal] (
	 @ReturnID				int OUTPUT 
	,@PC_ID					int
	,@Terminal_ID			int				=null
	,@Description			nvarchar(50)	=null
	,@DeviceName			nvarchar(50)	=null
	,@DriverDate			date			=null
	,@DriverProviderName 	nvarchar(MAX)	=null
	,@DriverVersion			nvarchar(50)	
	,@FriendlyName			nvarchar(50)	=null
	,@HardWareID			nvarchar(MAX)	=null
	,@InfName				nvarchar(50)	=null
	,@Signer				nvarchar(MAX)	=null
	)
AS
BEGIN
	--Переменные
	Declare  @DRV_ID int
	Declare  @Term_ID int

	IF @DriverVersion IS NULL
		BEGIN
			SET @ReturnID = 0
			RETURN 0
		END;

	--проверяем наличие DRV
	SET @DRV_ID = (SELECT TOP 1 ID FROM BT_Driver_Info WHERE CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion ORDER BY ID DESC)

	--если записи нет
	IF @DRV_ID IS NULL
		BEGIN
			--добавляем запись и получаем ее ID
			INSERT INTO BT_Driver_Info  (CompID, Terminal_ID, Description, DeviceName, DriverDate, DriverProviderName, DriverVersion, FriendlyName, Add_Date, Update_Date)
									VALUES(@PC_ID, @Terminal_ID, @Description, @DeviceName, @DriverDate, @DriverProviderName, @DriverVersion, @FriendlyName, GETDATE(), GETDATE())

			SET @DRV_ID = (SELECT ID FROM BT_Driver_Info WHERE CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion)
			SET @ReturnID = @DRV_ID
		END;
	--если запись есть
	ELSE
		BEGIN
			--проверяем актуальность информации
			IF EXISTS ( SELECT TOP 1 DeviceName, DriverVersion, FriendlyName
						FROM BT_Driver_Info
						WHERE CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion
						ORDER BY ID DESC
						EXCEPT
						SELECT @DeviceName, @DriverVersion, @FriendlyName)
				BEGIN
					--добавляем запись
					INSERT INTO BT_Driver_Info  (CompID, Terminal_ID, Description, DeviceName, DriverDate, DriverProviderName, DriverVersion, FriendlyName, Add_Date, Update_Date)
											VALUES(@PC_ID, @Terminal_ID, @Description, @DeviceName, @DriverDate, @DriverProviderName, @DriverVersion, @FriendlyName, GETDATE(), GETDATE())
				END;
			ELSE
				BEGIN
					SET @Term_ID = (SELECT Terminal_ID FROM BT_Driver_Info WHERE CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion AND ID = @DRV_ID)
					-- Если ID терминала нет, то добавляем его
					IF (@Term_ID IS NULL) AND (@Terminal_ID IS NOT NULL)
						BEGIN
							UPDATE BT_Driver_Info SET Terminal_ID = @Terminal_ID, Description = @Description, DeviceName = @DeviceName, DriverDate = @DriverDate,
														DriverProviderName = @DriverProviderName, DriverVersion = @DriverVersion,
														FriendlyName = @FriendlyName, Update_Date = GETDATE()
											WHERE ID = @DRV_ID AND CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion
						END;
					-- Если ID терминала есть, но нового нет, или ничего нет, то не обновляем ID терминала
					IF ((@Term_ID IS NOT NULL) AND (@Terminal_ID IS NULL)) OR ((@Term_ID IS NULL) AND (@Terminal_ID IS NULL))
						BEGIN
							UPDATE BT_Driver_Info SET Description = @Description, DeviceName = @DeviceName, DriverDate = @DriverDate,
														DriverProviderName = @DriverProviderName, DriverVersion = @DriverVersion,
														FriendlyName = @FriendlyName, Update_Date = GETDATE()
											WHERE ID = @DRV_ID AND CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion
						END;
					-- Если ID терминала не пустые и разные, то добавляем новую запись
					IF ((@Term_ID IS NOT NULL) AND (@Terminal_ID IS NOT NULL)) AND (@Term_ID <> @Terminal_ID)
						BEGIN
							INSERT INTO BT_Driver_Info  (CompID, Terminal_ID, Description, DeviceName, DriverDate, DriverProviderName, DriverVersion, FriendlyName, Add_Date, Update_Date)
											VALUES(@PC_ID, @Terminal_ID, @Description, @DeviceName, @DriverDate, @DriverProviderName, @DriverVersion, @FriendlyName, GETDATE(), GETDATE())
						END;

					IF ((@Term_ID IS NOT NULL) AND (@Terminal_ID IS NOT NULL)) AND (@Term_ID = @Terminal_ID)
						BEGIN
							UPDATE BT_Driver_Info SET Description = @Description, DeviceName = @DeviceName, DriverDate = @DriverDate,
														DriverProviderName = @DriverProviderName, DriverVersion = @DriverVersion,
														FriendlyName = @FriendlyName, Update_Date = GETDATE()
											WHERE ID = @DRV_ID AND CompID = @PC_ID AND DeviceName = @DeviceName AND DriverVersion = @DriverVersion
						END;

				END;
			Set @ReturnID = @DRV_ID
		END;
END;

GO

