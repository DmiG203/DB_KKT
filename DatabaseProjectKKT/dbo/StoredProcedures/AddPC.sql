-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddPC]
(
	 @ReturnID			int				OUTPUT	--ответ процедуры
	,@OP_Number			int				= null	--Номер ОП
	,@MACAddress		nvarchar(50)	= null
	,@IP_Address		nvarchar(50)	= null
	,@Hostname			nvarchar(50)	= null
	,@OS				nvarchar(50)	= null
	,@OS_Architecture	nvarchar(50)	= null
	,@OS_Version		nvarchar(50)	= null
	,@OS_Status			nvarchar(50)	= null
	,@OS_SerialNumber	nvarchar(50)	= null
	,@OS_InstallDate	smalldatetime	= null
	,@OS_LastBootTime	smalldatetime	= null
	,@BB_Manufacturer	nvarchar(50)	= null
	,@BB_Product		nvarchar(50)	= null
	,@BB_SerialNumber	nvarchar(50)	= null
	,@BB_Version		nvarchar(50)	= null
	,@Manufacturer		nvarchar(50)	= null
	,@Model				nvarchar(50)	= null
	,@CPU1				nvarchar(50)	= null
	,@CPU2				nvarchar(50)	= null
	,@RAM				nvarchar(50)	= null
	,@RAM_TotalSize		int				= null
	)
AS
BEGIN
	DECLARE @CompID int;	--ID из таблицы Димы
	DECLARE @Source nvarchar(50);
	DECLARE @OrgID  int;
	DECLARE @PC_ID	int;	--ID записи в таблице
	DECLARE @OS_ID	int;
	DECLARE @Hw_ID	int;
	DECLARE @Bb_ID	int;
	DECLARE @Mf_ID	int;
	DECLARE @ID_Status_Current	int;
	DECLARE @ID_Status_Moved	int;
	DECLARE @OSInstallDate		smalldatetime;
	DECLARE @CPU_ID int;

	SET @Source = 'Artemka';
	--Проверка наличия хостнейма и MAC-адреса. По хостнейму получаем ID записи из таблиц Димы. 
	IF @Hostname IS NULL OR @MACAddress IS NULL 
		BEGIN
			SET @ReturnID = 0;
			RETURN 0;
		END;
	--Получаем CompID по hastname.
	EXEC [dbo].[GetCompID]
		 @CompID	= @CompID OUTPUT
		,@Source	= @Source
		,@CompName	= @Hostname
		,@OP		= @OP_Number

	SET @ReturnID = @CompID;
	--Если CompID null, выходим.
	IF  @CompID	IS NULL 
		BEGIN
			SET @ReturnID = 0;
			RETURN 0;
		END;

	--Получение ID ОП
	SET @OrgID = (SELECT OrgID FROM Computers WHERE RID = @CompID);

	-->>>Проверка записи в PC_Info.<<<-------------------------------------------------------------
	IF  @OrgID		IS NOT NULL 
	AND @IP_Address IS NOT NULL
		BEGIN
			--Получаем ID записи.
			SET @PC_ID = (SELECT ID FROM PC_Info WHERE CompID = @CompID AND OrgID = @OrgID AND IP = @IP_Address AND MAC = @MACAddress);
			--Если записи нет, добавляем ее.
			IF @PC_ID IS NULL
				BEGIN
					INSERT INTO PC_Info (CompID, IP, MAC, OrgID, StatusID, Add_date, Update_date)
								 VALUES (@CompID, @IP_Address, @MACAddress, @OrgID, NULL, GETDATE(), GETDATE());
					--Получаем ID новой записи.
					SET @PC_ID = (SELECT ID FROM PC_Info WHERE CompID = @CompID AND OrgID = @OrgID AND IP = @IP_Address AND MAC = @MACAddress);
				END;
			--Если запись есть, обновляем ее.
			ELSE
				BEGIN
					UPDATE PC_Info SET Update_date = GETDATE() WHERE ID = @PC_ID;
				END;
		END;
	--Проверка и установка статуса
	SET @ID_Status_Current	= (SELECT ID FROM Statuses WHERE Name = 'Current')
	SET @ID_Status_Moved	= (SELECT ID FROM Statuses WHERE Name = 'Moved')
	--Если найдена только 1 запись с указанным МАС-адресом
	IF (SELECT COUNT(ID) FROM PC_Info WHERE MAC = @MACAddress) = 1
		--Устанавливаем статус "текущий".
		BEGIN
			UPDATE PC_Info SET StatusID = @ID_Status_Current WHERE MAC = @MACAddress AND ID = @PC_ID;
		END;
	--Если записей несколько
	ELSE
		BEGIN
			--Изменяем статус на "переехал" у записей с указанным МАС-адресом и статусом "текущий"
			UPDATE PC_Info SET StatusID = @ID_Status_Moved WHERE MAC = @MACAddress AND StatusID = @ID_Status_Current AND ID <> @PC_ID;
			--Исменяем статус на "текущий" у новой записи.
			UPDATE PC_Info SET StatusID = @ID_Status_Current WHERE MAC = @MACAddress AND ID = @PC_ID;
			
		END;
	--Если есть несколько записей с одинаковым IP, то все старые помечаем как Moved
	IF (SELECT COUNT(ID) FROM PC_Info WHERE IP = @IP_Address) > 1
		BEGIN
			--Меняем статус если была замена на новое устройство
			UPDATE PC_Info SET StatusID = @ID_Status_Moved WHERE ID IN (
				SELECT pci.ID 
				FROM PC_Info pci
				LEFT JOIN (	SELECT pc.CompID, pc.IP, MAX(pc.Update_date) update_date
							FROM PC_Info pc
							LEFT JOIN PC_Manufacturer_Info m ON m.PC_ID = pc.ID
							WHERE pc.IP = @IP_Address
							GROUP BY pc.CompID, pc.IP) t ON t.CompID = pci.CompID AND t.update_date = pci.Update_date
				WHERE pci.IP = @IP_Address AND pci.StatusID = 1
				AND t.CompID IS NULL)
		END;

	-->>>Проверка записи в PC_OS_Info.<<<-------------------------------------------------------------
	--Получаем ID записи.
	SET @OS_ID = (SELECT TOP 1 ID FROM PC_OS_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);	
	--Если записи нет, добавляем ее.
	IF @OS_ID IS NULL
		BEGIN
			INSERT INTO PC_OS_Info (PC_ID, MAC, Hostname, OS, Arch, Version, Status, Serial_number, Install_date, lastBootTime, Add_date, Update_date)
							VALUES (@PC_ID, @MACAddress, @Hostname, @OS, @OS_Architecture, @OS_Version, @OS_Status, @OS_SerialNumber, @OS_InstallDate, @OS_LastBootTime, GETDATE(), GETDATE());
			--Получаем ID новой записи.
			SET @OS_ID = (SELECT TOP 1 ID FROM PC_OS_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
		END;
	--Если запись есть...
	ELSE
		BEGIN
			SET @OSInstallDate = (SELECT Install_date FROM PC_OS_Info WHERE ID = @OS_ID);
			--проверка актуальности.
			IF EXISTS  (SELECT TOP 1 MAC, Hostname, OS, Arch, Version, Status, Serial_number, Install_date
						FROM PC_OS_Info
						WHERE PC_ID = @PC_ID AND ID = @OS_ID
						ORDER BY ID DESC
						EXCEPT
						SELECT @MACAddress, @Hostname, @OS, @OS_Architecture, @OS_Version, @OS_Status, @OS_SerialNumber, @OS_InstallDate)
				--если неактуальны, добавляем новую запись.
				BEGIN
					IF (@OSInstallDate IS NOT NULL) AND (@OS_InstallDate IS NOT NULL)
						BEGIN
							INSERT INTO PC_OS_Info (PC_ID, MAC, Hostname, OS, Arch, Version, Status, Serial_number, Install_date, lastBootTime, Add_date, Update_date)
									VALUES (@PC_ID, @MACAddress, @Hostname, @OS, @OS_Architecture, @OS_Version, @OS_Status, @OS_SerialNumber, @OS_InstallDate, @OS_LastBootTime, GETDATE(), GETDATE());
							--Получаем ID новой записи.
							SET @OS_ID = (SELECT TOP 1 ID FROM PC_OS_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
						END;
					IF (@OSInstallDate IS NULL) AND (@OS_InstallDate IS NOT NULL)
						BEGIN
							UPDATE PC_OS_Info SET Hostname = @Hostname, OS = @OS, Arch = @OS_Architecture, Version = @OS_Version, Status = @OS_Status, Serial_number = @OS_SerialNumber, Install_date = @OS_InstallDate, lastBootTime = @OS_InstallDate, Update_date = GETDATE()
											WHERE ID = @OS_ID;
						END;
					IF (@OS_InstallDate IS NULL)
						BEGIN
							UPDATE PC_OS_Info SET Update_date = GETDATE() WHERE ID = @OS_ID;
						END;
				END;
			--если актуальны, обновляем новую запись.
			ELSE
				BEGIN
					UPDATE PC_OS_Info SET lastBootTime = @OS_LastBootTime, Update_date = GETDATE() WHERE ID = @OS_ID;
				END;
		END;

	-->>>Проверка записи в PC_Hardware_Info.<<<-------------------------------------------------------------
	--Проверяем наличие CPU в Info_CPU
	IF @CPU1 IS NOT NULL
		BEGIN
			EXEC [dbo].[AddInfoCPU]
				 @CPU_ID	= @CPU_ID OUTPUT
				,@CPU_Name	= @CPU1
		END
	IF @CPU2 IS NOT NULL
		BEGIN
			EXEC [dbo].[AddInfoCPU]
				 @CPU_ID	= @CPU_ID OUTPUT
				,@CPU_Name	= @CPU2
		END;

	--Получаем ID записи.
	SET @Hw_ID = (SELECT TOP 1 ID FROM PC_Hardware_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
	--Если записи нет, добавляем ее.
	IF @Hw_ID IS NULL
		BEGIN
			INSERT INTO PC_Hardware_Info ( PC_ID, CPU1, CPU2, RAM, RAM_total_size, Add_date, Update_date)
								  VALUES ( @PC_ID, @CPU1, @CPU2, @RAM, @RAM_TotalSize, GETDATE(), GETDATE());
			--Получаем ID новой записи.
			SET @Hw_ID = (SELECT TOP 1 ID FROM PC_Hardware_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
		END;
	--Если запись есть...
	ELSE
		BEGIN
			--проверка актуальности.
			IF EXISTS  (SELECT TOP 1  CPU1, @CPU2, RAM, RAM_total_size 
						FROM PC_Hardware_Info
						WHERE ID = @Hw_ID AND PC_ID = @PC_ID
						ORDER BY ID DESC
						EXCEPT
						SELECT @CPU1, @CPU2, @RAM, @RAM_TotalSize)
				--если неактуальны, добавляем новую запись.
				BEGIN
					INSERT INTO PC_Hardware_Info ( PC_ID, CPU1, CPU2, RAM, RAM_total_size, Add_date, Update_date)
								  VALUES ( @PC_ID, @CPU1, @CPU2, @RAM, @RAM_TotalSize, GETDATE(), GETDATE());
					--Получаем ID новой записи.
					SET @Hw_ID = (SELECT TOP 1 ID FROM PC_Hardware_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
				END;
			--если актуальны, обновляем новую запись.
			ELSE
				BEGIN
					UPDATE PC_Hardware_Info SET Update_date = GETDATE() WHERE ID = @Hw_ID;
				END;
		END;

	-->>>Проверка записи в PC_Baseboard_Info.<<<-------------------------------------------------------------
	--Ручное определение производителя.
	IF @BB_Product = 'PS-3315' AND @BB_Manufacturer = 'N/A'
		BEGIN
			Set @BB_Manufacturer = 'POSIFLEX'
		END;
	--Получаем ID записи.
	SET @Bb_ID = (SELECT TOP 1 ID FROM PC_Baseboard_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
	--Если записи нет, добавляем ее.
	IF @Bb_ID IS NULL
		BEGIN
			INSERT INTO PC_Baseboard_Info ( PC_ID, Manufacturer, Product, Serial_number, Version, Add_date, Update_date)
								   VALUES ( @PC_ID, @BB_Manufacturer, @BB_Product, @BB_SerialNumber, @BB_Version, GETDATE(), GETDATE());
			--Получаем ID новой записи.
			SET @Bb_ID = (SELECT TOP 1 ID FROM PC_Baseboard_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
		END;
	--Если запись есть...
	ELSE
		BEGIN
			--проверка актуальности.
			IF EXISTS ( SELECT TOP 1 Manufacturer, Product, Serial_number, Version
						FROM PC_Baseboard_Info
						WHERE ID = @Bb_ID AND PC_ID = @PC_ID
						ORDER BY ID DESC
						EXCEPT 
						SELECT @BB_Manufacturer, @BB_Product, @BB_SerialNumber, @BB_Version)
				--если неактуальны, добавляем новую запись.
				BEGIN
					INSERT INTO PC_Baseboard_Info ( PC_ID, Manufacturer, Product, Serial_number, Version, Add_date, Update_date)
										   VALUES ( @PC_ID, @BB_Manufacturer, @BB_Product, @BB_SerialNumber, @BB_Version, GETDATE(), GETDATE())
					--Получаем ID новой записи.
					SET @Bb_ID = (SELECT TOP 1 ID FROM PC_Baseboard_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
				END;
			--если актуальны, обновляем новую запись.
			ELSE
				BEGIN
					UPDATE PC_Baseboard_Info SET Update_date = GETDATE() WHERE ID = @Bb_ID;
				END;
		END;

	-->>>Проверка записи в PC_Manufacturer_Info.<<<-------------------------------------------------------------
	--Ручное определение производителя.
	IF @Model = 'PS-3315' AND @Manufacturer = 'N/A'
		BEGIN
			Set @Manufacturer = 'POSIFLEX'
		END;
	IF @BB_Manufacturer = 'AMI Corporation' AND @BB_Product = 'Aptio CRB' AND @Manufacturer = 'To be filled by O.E.M.' AND @Model = 'To be filled by O.E.M.'
		BEGIN
			SET @Manufacturer = 'SEWOO'
		END;
	--Получаем ID записи.
	SET @Mf_ID = (SELECT TOP 1 ID FROM PC_Manufacturer_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
	--Если записи нет, добавляем ее.
	IF @Mf_ID IS NULL
		BEGIN
			INSERT INTO PC_Manufacturer_Info ( PC_ID, Manufacturer, Model, Add_date, Update_Date)
									  VALUES ( @PC_ID, @Manufacturer, @Model, GETDATE(), GETDATE());
			--Получаем ID новой записи.
			SET @Mf_ID = (SELECT TOP 1 ID FROM PC_Manufacturer_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
		END;
	--Если запись есть...
	ELSE
		BEGIN
			--проверка актуальности.
			IF EXISTS ( SELECT TOP 1 Manufacturer, Model
						FROM PC_Manufacturer_Info
						WHERE ID = @Mf_ID AND PC_ID = @PC_ID
						ORDER BY ID DESC
						EXCEPT 
						SELECT @Manufacturer, @Model)
				--если неактуальны, добавляем новую запись.
				BEGIN
					INSERT INTO PC_Manufacturer_Info ( PC_ID, Manufacturer, Model, Add_date, Update_Date)
											  VALUES ( @PC_ID, @Manufacturer, @Model, GETDATE(), GETDATE());
					--Получаем ID новой записи.
					SET @Mf_ID = (SELECT TOP 1 ID FROM PC_Manufacturer_Info WHERE PC_ID = @PC_ID ORDER BY ID DESC);
				END;
			--если актуальны, обновляем новую запись.
			ELSE
				BEGIN
					UPDATE PC_Manufacturer_Info SET Update_date = GETDATE() WHERE ID = @Mf_ID;
				END;
		END;
END;

GO

