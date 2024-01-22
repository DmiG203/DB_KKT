-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddBankTerminal] (
	 @ReturnID					int OUTPUT 
	,@PC_ID						int
	,@TerminalNumber			nvarchar(50)	=null
	,@LoadingParameters			datetime		=null
	,@Contactless				nvarchar(50)	=null
	,@TerminalModel 			nvarchar(50)	=null
	,@SerialNumber				nvarchar(50)	=null
	,@SoftwareVersionsUPS		nvarchar(50)	=null
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
	DECLARE  @BTS_ID	int;
	DECLARE  @BTP_ID	int;
	DECLARE  @BTD_ID	int;

	DECLARE @BTS_Sn nvarchar(50);
	DECLARE @BTP_Sn nvarchar(50);

	DECLARE  @ID_Status_Current	int;
	DECLARE  @ID_Status_Moved	int;

	IF (@PC_ID IS NOT NULL) AND (@TerminalNumber IS NULL)
		BEGIN
			SET @BTD_ID = (SELECT TOP 1 ID FROM BT_Detect WHERE CompID = @PC_ID ORDER BY ID DESC);
			IF @BTD_ID IS NULL
				BEGIN
					INSERT INTO BT_Detect ( CompID, Detected, Add_date, Update_date)
									VALUES ( @PC_ID, 0, GETDATE(), GETDATE());
				END;
			ELSE
				BEGIN
					UPDATE BT_Detect SET Detected = 0, Update_date = GETDATE() WHERE ID = @BTD_ID;
				END;
		END;
	--Проверяем, что номер терминала и ID комьютера нет пустые
	IF @TerminalNumber IS NULL OR @PC_ID IS NULL
		BEGIN
			SET @ReturnID = 0;
			RETURN 0;
		END;

	--Проверка на кривые серийники оборудования на терминалах
	--Стандартная длина 12 символов, но проверяем на < 10, вдруг есть более короткие варианты. У кривых длина ~3 символа
	IF @SerialNumber IS NOT NULL
		BEGIN
			IF LEN(@SerialNumber) < 10 
				BEGIN
					Set @SerialNumber = NULL;
				END;
		END;

	IF @PC_SerialNumber IS NOT NULL
		BEGIN
			IF LEN(@PC_SerialNumber) < 10 
				BEGIN
					Set @PC_SerialNumber = NULL;
				END;
		END;

	--Проверяем наличие банковского терминала.
	SET @BTS_ID = (SELECT TOP 1 ID FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber AND CompID = @PC_ID AND StatusID = 1 ORDER BY ID DESC)
	--Если терминала в БД нет, до добавляем записи.
	IF @BTS_ID IS NULL
		BEGIN
			--Добавляем запись в BT_Software_Info.
			INSERT INTO BT_Software_Info ( CompID, Terminal_number, Serial_number, Terminal_model, Contactless, Loading_parameters, Software_versions_UPOS, IsDeleted, Add_date, Update_date)
								  VALUES ( @PC_ID, @TerminalNumber, @SerialNumber, @TerminalModel, @Contactless, @LoadingParameters, @SoftwareVersionsUPS, 0, GETDATE(), GETDATE());
			--Получаем ID новой записи.
			SET @BTS_ID = (SELECT TOP 1 ID FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber AND CompID = @PC_ID ORDER BY ID DESC);

			--Добавляем запись в BT_Program_Info.
			INSERT INTO BT_Program_Info ( CompID, TerminalID, PC_PathFolder, PC_Model, PC_Serial_number, PC_Software_versions_UPOS, LoadParmEXE, GateDLL, Sb_kernelDLL, FullTextFromFile, Add_date, Update_date)
								 VALUES ( @PC_ID, @BTS_ID, @PC_PathFolder, @PC_Model, @PC_SerialNumber, @PC_SoftwareVersionsUPS, @LoadParmEXE, @GateDLL, @Sb_kernelDLL, @FullTextFromFile, GETDATE(), GETDATE());
			--Получаем ID новой записи.
			SET @BTP_ID = (SELECT TOP 1 ID FROM BT_Program_Info WHERE CompID = @PC_ID ORDER BY ID DESC);

			--Получаем ID записи.
			SET @BTD_ID = (SELECT TOP 1 ID FROM BT_Detect WHERE CompID = @PC_ID ORDER BY ID DESC);
			--Если записей нет
			IF @BTD_ID IS NULL
				BEGIN
					--Добавляем запись в BT_Detect.
					INSERT INTO BT_Detect ( CompID, TerminalID, Detected, Add_date, Update_date)
								   VALUES ( @PC_ID, @BTS_ID, 1, GETDATE(), GETDATE());
					--Получаем ID новой записи.
					SET @BTD_ID = (SELECT TOP 1 ID FROM BT_Detect WHERE TerminalID = @BTS_ID ORDER BY ID DESC);
				END;
			--Если запись есть, обновляем ее.
			ELSE
				BEGIN
					UPDATE BT_Detect SET Detected = 1, Update_date = GETDATE() WHERE ID = @BTD_ID;
				END;
		END;
	--Если терминал есть в БД.
	ELSE
		BEGIN
			SET @BTP_ID = (SELECT TOP 1 ID FROM BT_Program_Info WHERE CompID = @PC_ID ORDER BY ID DESC);
			SET @BTS_Sn = (SELECT TOP 1 Serial_number FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber AND CompID = @PC_ID ORDER BY ID DESC);
			SET @BTP_Sn = (SELECT TOP 1 PC_Serial_number FROM BT_Program_Info WHERE CompID = @PC_ID ORDER BY ID DESC);

			--Проверка на корректность входных и имеющихся данных
			IF (@TerminalModel IS NOT NULL) AND (@LoadParmEXE IS NOT NULL)
				BEGIN
					--Проверяем актуальность завписи в BT_Software_Info.
					IF EXISTS ( SELECT TOP 1 CompID, Terminal_number, Serial_number, Terminal_model, Contactless, Software_versions_UPOS
								FROM BT_Software_Info
								WHERE ID = @BTS_ID
								ORDER BY ID DESC
								EXCEPT
								SELECT @PC_ID, @TerminalNumber, @SerialNumber, @TerminalModel, @Contactless, @SoftwareVersionsUPS
								)
						--Если записи не совпадают
						BEGIN
							--Если все параметры есть, то добавляем новую запись.
							IF (@BTS_Sn IS NOT NULL) AND (@SerialNumber IS NOT NULL)
								BEGIN
									INSERT INTO BT_Software_Info ( CompID, Terminal_number, Serial_number, Terminal_model, Contactless, Loading_parameters, Software_versions_UPOS, IsDeleted, Add_date, Update_date)
												  VALUES ( @PC_ID, @TerminalNumber, @SerialNumber, @TerminalModel, @Contactless, @LoadingParameters, @SoftwareVersionsUPS, 0, GETDATE(), GETDATE());
									----Получаем ID новой записи.
									SET @BTS_ID = (SELECT TOP 1 ID FROM BT_Software_Info WHERE Terminal_number = @TerminalNumber AND CompID = @PC_ID ORDER BY ID DESC);
								END;
							ELSE
								BEGIN
									--Если имеющееся значение отсутсвует, то обновляем запись.
									IF (@BTS_Sn IS NULL) AND (@SerialNumber IS NOT NULL)
										BEGIN
											UPDATE BT_Software_Info SET Serial_number = @SerialNumber, Terminal_model = @TerminalModel, Contactless = @Contactless,
																		Loading_parameters = @LoadingParameters, Software_versions_UPOS = @SoftwareVersionsUPS, Update_date = GETDATE()
																  WHERE ID = @BTS_ID;
										END;
									--Если нового значения нет, то обновляем дату старой записи.
									IF (@SerialNumber IS NOT NULL)
										BEGIN
											--Если нового значения нет, то обновляем дату старой.
											UPDATE BT_Software_Info SET Update_date = GETDATE() WHERE ID = @BTS_ID;
										END;
								END;
						END;
					--Если записи совпадают, обновляем запись.
					ELSE
						BEGIN
							UPDATE BT_Software_Info SET Update_date = GETDATE() WHERE ID = @BTS_ID;
						END;

					--Проверяем актуальность завписи в BT_Program_Info.
					IF EXISTS ( SELECT TOP 1 CompID, TerminalID, PC_PathFolder, PC_Model, PC_Serial_number, PC_Software_versions_UPOS, LoadParmEXE, GateDLL, Sb_kernelDLL
								FROM BT_Program_Info
								WHERE ID = @BTP_ID
								ORDER BY ID DESC
								EXCEPT
								SELECT @PC_ID, @BTS_ID, @PC_PathFolder, @PC_Model, @PC_SerialNumber, @PC_SoftwareVersionsUPS, @LoadParmEXE, @GateDLL, @Sb_kernelDLL)
						--Если записи не совпадают
						BEGIN
							--Если все параметры есть, то добавляем новую запись.
							IF (@BTP_Sn IS NOT NULL) AND (@PC_SerialNumber IS NOT NULL)
								BEGIN
									INSERT INTO BT_Program_Info ( CompID, TerminalID, PC_PathFolder, PC_Model, PC_Serial_number, PC_Software_versions_UPOS, LoadParmEXE, GateDLL, Sb_kernelDLL, FullTextFromFile, Add_date, Update_date)
										 VALUES ( @PC_ID, @BTS_ID, @PC_PathFolder, @PC_Model, @PC_SerialNumber, @PC_SoftwareVersionsUPS, @LoadParmEXE, @GateDLL, @Sb_kernelDLL, @FullTextFromFile, GETDATE(), GETDATE());
									--Получаем ID новой записи.
									SET @BTP_ID = (SELECT TOP 1 ID FROM BT_Program_Info WHERE CompID = @PC_ID ORDER BY ID DESC);
								END;
							--Если имеющееся значение отсутсвует, то обновляем запись.
							IF (@BTP_Sn IS NULL) AND (@PC_SerialNumber IS NOT NULL)
								BEGIN
									UPDATE BT_Program_Info SET PC_PathFolder = @PC_PathFolder, PC_Model = @PC_Model, PC_Serial_number = @PC_SerialNumber,PC_Software_versions_UPOS = @PC_SoftwareVersionsUPS, 
															   LoadParmEXE = @LoadParmEXE, GateDLL = @GateDLL, Sb_kernelDLL = @Sb_kernelDLL, Update_date = GETDATE()
														 WHERE ID = @BTP_ID;		   
								END;
							--Если нового значения нет, то обновляем дату старой записи.
							IF @PC_SerialNumber IS NULL
								BEGIN
									UPDATE BT_Program_Info SET Update_date = GETDATE() WHERE ID = @BTP_ID;
								END;	
						END;
					--Если записи совпадают, обновляем запись.
					ELSE
						BEGIN
							UPDATE BT_Program_Info SET Update_date = GETDATE() WHERE ID = @BTP_ID;
						END;
				END;
			--Если входные данные неполные, то просто обновляем дату имеющихся записей
			ELSE
				BEGIN
					IF @TerminalModel IS NULL
						BEGIN
							UPDATE BT_Software_Info SET Update_date = GETDATE() WHERE ID = @BTS_ID;
						END;
					IF @LoadParmEXE IS NULL
						BEGIN
							UPDATE BT_Program_Info SET Update_date = GETDATE() WHERE ID = @BTP_ID;
						END;
				END;

			--Получаем ID записи из BT_Detect
			SET @BTD_ID = (SELECT TOP 1 ID FROM BT_Detect WHERE CompID = @PC_ID ORDER BY ID DESC)
			--Если запись есть, то обновляем ее.
			IF @BTD_ID IS NOT NULL
				BEGIN
					UPDATE BT_Detect SET Detected = 1, TerminalID = @BTS_ID, Update_date = GETDATE() WHERE ID = @BTD_ID;
				END;
			--Если записи нет, добавлем ее.
			ELSE
				BEGIN
					--Добавляем запись в BT_Detect.
					INSERT INTO BT_Detect ( CompID, TerminalID, Detected, Add_date, Update_date)
								   VALUES ( @PC_ID, @BTS_ID, 1, GETDATE(), GETDATE());
					--Получаем ID записи из BT_Detect
					SET @BTD_ID = (SELECT TOP 1 ID FROM BT_Detect WHERE CompID = @PC_ID ORDER BY ID DESC)
				END;

		END;

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

	SET @ReturnID = @BTS_ID;
END;

GO

