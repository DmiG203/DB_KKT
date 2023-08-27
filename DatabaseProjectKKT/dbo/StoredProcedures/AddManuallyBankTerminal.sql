-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddManuallyBankTerminal] (
	 @ReturnID					int OUTPUT 
	,@ReturnMsg					nvarchar(MAX) OUTPUT 
	,@Hostname					nvarchar(50)
	,@TerminalNumber			nvarchar(50)
	,@LoadingParameters			datetime		=null
	,@Contactless				nvarchar(50)	=null
	,@TerminalModel 			nvarchar(50)	=null
	,@SerialNumber				nvarchar(50)	=null
	,@SoftwareVersionsUPS		nvarchar(50)	=null
	--
	,@PC_PathFolder				nvarchar(MAX)	=null
	,@PC_Model					nvarchar(50)	=null
	,@PC_SerialNumber			nvarchar(50)	=null
	,@PC_SoftwareVersionsUPS	nvarchar(50)	=null
	,@LoadParmEXE				nvarchar(50)	=null
	,@GateDLL					nvarchar(50)	=null
	,@Sb_kernelDLL				nvarchar(50)	=null
	,@FullTextFromFile			nvarchar(MAX)	=null
	)
AS
BEGIN
	DECLARE @CompID				int;	--ID из таблицы Димы
	DECLARE @Check_BT_ID		int;
	DECLARE @BTS_ID				int;
	DECLARE @BTP_ID				int;
	DECLARE @ID_Status_Current	int;
	DECLARE @ID_Status_Moved	int;

	IF @Hostname IS NOT NULL
		BEGIN
			--Получаем CompID по hastname.
			SET @CompID = (SELECT MAX(RID) FROM Computers WHERE ComputerName = @Hostname)
		END;
	ELSE
		BEGIN
			SET @ReturnMsg = 'Не указан hostname комьютера!';
			SET @ReturnID = 0;
		END;

	--Если CompID null, выходим.
	IF  @CompID	IS NULL 
		BEGIN
			SET @ReturnMsg = 'Не найден компьютер по указанному hostname!'
			SET @ReturnID = 0;
			RETURN 0;
		END;


	--Проверка входных значений.
	IF (@CompID IS NOT NULL) AND (@TerminalNumber IS NOT NULL)
		BEGIN
			--Проверяем наличие данного терминала.
			SET @Check_BT_ID = (SELECT ID FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber)
			IF @Check_BT_ID IS NOT NULL
				BEGIN
					SET @ReturnMsg = 'Терминал с номером ' + @TerminalNumber + ' уже существует!';
					SET @ReturnID = 0;
					RETURN 0;
				END;
			ELSE
				BEGIN
					--Добавляем запись в BT_Software_Info.
					INSERT INTO BT_Software_Info ( CompID, Terminal_number, Serial_number, Terminal_model, Contactless, Loading_parameters, Software_versions_UPOS, IsDeleted, Add_date, Update_date)
										  VALUES ( @CompID, @TerminalNumber, @SerialNumber, @TerminalModel, @Contactless, @LoadingParameters, @SoftwareVersionsUPS, 0, GETDATE(), GETDATE());
					--Получаем ID новой записи.
					SET @BTS_ID = (SELECT TOP 1 ID FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber AND CompID = @CompID ORDER BY ID DESC);

					SET @ReturnMsg = 'Терминал ' + @TerminalNumber + ' добавлен.';
					SET @ReturnID = @BTS_ID;

					IF (@PC_PathFolder			IS NOT NULL) 
					OR (@PC_Model				IS NOT NULL)
					OR (@PC_SerialNumber		IS NOT NULL)
					OR (@PC_SoftwareVersionsUPS IS NOT NULL)
					OR (@LoadParmEXE			IS NOT NULL)
					OR (@GateDLL				IS NOT NULL)
					OR (@Sb_kernelDLL			IS NOT NULL)
					OR (@FullTextFromFile		IS NOT NULL)
						BEGIN
							--Добавляем запись в BT_Program_Info.
							INSERT INTO BT_Program_Info ( CompID, TerminalID, PC_PathFolder, PC_Model, PC_Serial_number, PC_Software_versions_UPOS, LoadParmEXE, GateDLL, Sb_kernelDLL, FullTextFromFile, Add_date, Update_date)
												 VALUES ( @CompID, @BTS_ID, @PC_PathFolder, @PC_Model, @PC_SerialNumber, @PC_SoftwareVersionsUPS, @LoadParmEXE, @GateDLL, @Sb_kernelDLL, @FullTextFromFile, GETDATE(), GETDATE());
							--Получаем ID новой записи.
							SET @BTP_ID = (SELECT TOP 1 ID FROM BT_Program_Info WHERE CompID = @CompID ORDER BY ID DESC);
						END

					--Проверка и установка статуса
					SET @ID_Status_Current	= (SELECT ID FROM Statuses WHERE Name = 'Current')
					SET @ID_Status_Moved	= (SELECT ID FROM Statuses WHERE Name = 'Moved')
					--Если найдена только 1 запись с указанным номером терминала
					IF (SELECT COUNT(ID) FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber) = 1
						--Устанавливаем статус "текущий".
						BEGIN
							UPDATE BT_Software_Info SET StatusID = @ID_Status_Current WHERE Terminal_number = @TerminalNumber AND ID = @BTS_ID;
						END;
					--Если записей несколькo
					ELSE
						BEGIN
							--Изменяем статус на "переехал" у записей с указанным МАС-адресом и статусом "текущий"
							UPDATE BT_Software_Info SET StatusID = @ID_Status_Moved WHERE Terminal_number = @TerminalNumber AND StatusID = @ID_Status_Current AND ID <> @BTS_ID;
							--Исменяем статус на "текущий" у новой записи.
							UPDATE BT_Software_Info SET StatusID = @ID_Status_Current WHERE Terminal_number = @TerminalNumber AND ID = @BTS_ID;
						END;
				END;
		END;

	
END

GO

