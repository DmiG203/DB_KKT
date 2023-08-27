

CREATE procedure [dbo].[AddKKM] (
	   @KkmID int output
	  ,@LocKkmId int output
	  ,@CompID int output
	  ,@Action nvarchar(MAX) output
	  ,@snKKM nvarchar(MAX)
	  ,@modelKKM nvarchar(MAX)
	  ,@Source nvarchar(MAX)
	  ,@CompName nvarchar(MAX)
	  ,@OP int
	  ,@comPort int = null
	  ,@comBaudRate int = null
	  ,@ShtrihDrvVer nvarchar(MAX) = null
	  ,@AtolDrvVer nvarchar(MAX) = null
	  ,@KKMSoftVer nvarchar(max) = null
/*	  ,@OSName nvarchar(max) = null
      ,@OSVer nvarchar(max) = null
      ,@OSDateInstall datetime = null
      ,@Brand nvarchar(max) = null
      ,@Model nvarchar(max) = null
      ,@sn nvarchar(max) = null
*/	  ,@MAC char(12) = null
	  ,@RNDIS bit = 0
	  ,@IpAddress char(15) = null
	  ,@IpPort int = null
	  ,@LoaderVersion int = null
	  )
AS
Begin
	Declare  @ModelID int		--ID Модели ККМ
			,@OrgId int			--ID организации места установки
			,@WorkMode int		--Режим работы ККМ
			,@KkmIdOld int		--ИД старой ККМ
			,@FnId int			--ИД ФН (для переброса со сторой ККМ)
			,@SourceID bigint   --ID текста

	--чистим некоторые переменные
	If @ShtrihDrvVer	= ''	Set @ShtrihDrvVer = null
	If @AtolDrvVer		= ''	Set @AtolDrvVer = null
	If @KKMSoftVer		= ''	Set @KKMSoftVer = null
	If @comBaudRate		= 2400	Set @comBaudRate = null
	Set @Action			= '' 

	--переопределяем некоторые значения
--	If @Brand = 'N/A' and @Model = 'PS-3315' Set @Brand = 'POSIFLEX'

	--получаем ID места установки и выходим, если нет такого ОП в базе
	Set @OrgId = (SELECT TOP(1) org.RID FROM Org WHERE org.NumOP = @OP)
	If @OrgId is null 
		BEGIN
			SET @Action = ISNULL(@Action,'') + 'ОП ' + CAST(@OP as nvarchar) + ' нет в БД. Сначала добавьте ОП --- 48 '
			RETURN 1
		End;
	
	--проверяем наличие Модели, и выходим, если нет такой модели в базе
	Set @ModelID = (SELECT RID FROM kkmModel WHERE Name = @modelKKM)
	If @ModelID is null 
		BEGIN
			SET @Action = ISNULL(@Action,'') + 'Модель ' + @modelKKM + ' не найдена в БД. Сначала добавьте модель ККМ. '
			RETURN 1
		End;

	-- Получаем ID текста
	-- для @SourceID
	EXEC	[dbo].[GetTextID]
			@text = @Source,
			@textID = @SourceID OUTPUT
	
	--проверяем наличие ККМ, если есть, получаем его ID
	Set @KkmID = (SELECT RID FROM kkm WHERE sn = @snKKM and modelID = @ModelID)

	--получаем CompID
	EXEC	[dbo].[GetCompID]
			 @CompID = @CompID OUTPUT
			,@Source = @Source
			,@CompName = @CompName
			,@OP = @OP
			,@ShtrihDrvVer = @ShtrihDrvVer
			,@AtolDrvVer = @AtolDrvVer
			,@Action = @Action OUTPUT

	--получаем последнюю запись о месте установки ККМ
	Set @LocKkmId = (SELECT	MAX(RID) FROM LocKkm WHERE KkmId = @KkmID) --ORDER BY addDate DESC)
	----если не определены какие либо параметры, получаем их из последнего места установки:
	-- если у ККМ больше нет подключения по ком, этого не видно в БД. Плохая была идея...
	--If @LocKkmId is not null
	--	begin
	--		If @comPort is null Set @comPort = (SELECT comPort FROM LocKkm WHERE RID = @LocKkmId)
	--		IF @comBaudRate is null Set @comBaudRate = (SELECT comBaudRate FROM LocKkm WHERE RID = @LocKkmId)
	--	end;

	--если не находим ККМ
	If @KkmID is null
		Begin
			-- если ККМ с таким же серийником, но другой модели есть в базе, получим его данные
			Set @KkmIdOld = (SELECT TOP(1) RID FROM KKM WHERE sn = @snKKM ORDER BY RID DESC)
			If @KkmIdOld is not null					-- продолжаем, если нашли такой же серийник без указания модели
				begin
					-- забираем WorkMode
					Set @WorkMode = (SELECT TOP(1) WorkMode FROM KKM WHERE RID = @KkmIdOld)
					-- включаем "шифрование", если оно выключено, т.е. добавляем 1 к чётному значению
					If @WorkMode % 2 = 0
						Set @WorkMode = @WorkMode + 1
					-- забираем последнее место установки предыдущего ККМ
					Set @CompID = (SELECT TOP(1) LocKkm.compID FROM LocKkm WHERE KkmId = @KkmIdOld ORDER BY RID DESC)
				end;
			-- метим на удаление старую ККМ
			UPDATE kkm set deleted = 1, updateDate = GETDATE() WHERE RID = (SELECT TOP(1) RID FROM KKM WHERE sn = @snKKM ORDER BY RID DESC)
			--добавляем ККМ в базу
			INSERT INTO kkm(sn,modelID,updateDate,addDate,source,SoftVer, WorkMode, Deleted, MAC, RNDIS, IpAddress, ipPort, LoaderVersion) VALUES (@snKKM, @ModelID, GETDATE(), GETDATE(), @Source, @KKMSoftVer, @WorkMode, 0, @MAC, @RNDIS, @IpAddress, @IpPort, @LoaderVersion)
			--получаем ID записи
			Set @KkmID = (SELECT TOP(1) RID FROM kkm WHERE sn = @snKKM ORDER BY RID DESC)
			--вставляем запись о месте установки
			INSERT INTO LocKkm(KkmId,addDate,updateDate,source,compID,ComPort,ComBaudRate) VALUES (@KkmID,GETDATE(),GETDATE(),@Source,@CompID,@comPort,@comBaudRate)
			-- перекидываем на него лицензии
			UPDATE kkm_lic set kktID = @KkmID, updateDate = GETDATE() WHERE kktID = @KkmIdOld
			-- перекидываем на него ФН со старой кассы, если у ФН статус 0 - новая.
			set @FnId = (SELECT TOP(1) RID FROM FN WHERE kktID = @KkmID and status = 0 ORDER BY RID DESC)
			If @FnId is not null 
				UPDATE fn set kktID = @KkmID WHERE RID = @FnID

			-- возвращаем комментарий
			Set @Action = ISNULL(@Action,'') + 'ККМ добавлена. '

		End;
	Else
		-- ККМ найдена в БД
		-- проверяем необходимость обновления места установки (если нет записи или изменилась касса/порт/скорость порта, втавляем новую запись)
		begin
			-- места установки нет или не совпадает комп, COMпорт или скорость
			If	@LocKkmId is null 
				 or			@CompID != ISNULL((SELECT compID FROM LocKkm WHERE RID= @LocKkmId),'')
				 or 		@comPort != ISNULL((SELECT comPort FROM LocKkm WHERE RID= @LocKkmId),'') 
				 or 		@comBaudRate != ISNULL((SELECT comBaudRate FROM LocKkm WHERE RID= @LocKkmId),'')
				begin
					-- добавляем новую запись о месте установки
					INSERT INTO LocKkm(KkmId,addDate,updateDate,source,compID,comPort,ComBaudRate) VALUES (@KkmID,GETDATE(),GETDATE(),@Source,@compID,@comPort,@comBaudRate)
				
					If @LocKkmId is null 
						Set @Action = ISNULL(@Action,'') + 'ККМ добавлено место установки. '
					Else
						SET @Action = ISNULL(@Action,'') + 'ККМ ' + @modelKKM + ' ' + @snKKM + '. перемещен на ' + @CompName + '(ID ' + CAST(@CompID as nvarchar) + '). COM' +  CAST(ISNULL(@comPort,'') as nvarchar) + '. '
					--обновляем LocKkmId
					Set @LocKkmId = (SELECT	TOP(1) LocKkm.RID FROM LocKkm WHERE LocKkm.KkmId = @KkmID ORDER BY LocKkm.addDate DESC);
				end;

			-- если есть запись о месте установки, но в ней нет записи о кассе или о ком порте, надо эту строку обновить
			If @LocKkmId is not null
				and	(		@CompID != ISNULL((SELECT compID FROM LocKkm WHERE RID= @LocKkmId),'') 
						or  @comPort != ISNULL((SELECT ComPort FROM LocKkm WHERE RID= @LocKkmId),'') 
						or  @comBaudRate != ISNULL((SELECT ComBaudRate FROM LocKkm WHERE RID= @LocKkmId),'') 
					)
				begin 
					UPDATE LocKkm set updateDate = GETDATE(), compID = @CompID, source = @Source, ComPort = @ComPort, ComBaudRate = @comBaudRate WHERE RID = @LocKkmId 
					SET @Action = ISNULL(@Action,'') + 'место установки ККМ обновлено. '
				end;
		end;

		--обновляем LocKkmId
		Set @LocKkmId = (SELECT	TOP(1) LocKkm.RID FROM LocKkm WHERE LocKkm.KkmId = @KkmID ORDER BY LocKkm.addDate DESC);

	--обновляем данные о ККМ, если необходимо
	---- Внутренная верия ПО
	If		@KKMSoftVer is not null 
		and @KKMSoftVer != ISNULL((SELECT SoftVer FROM KKM WHERE RID = @KkmID),'')
		begin 
			UPDATE KKM set SoftVer = @KKMSoftVer, updateDate = GETDATE() WHERE RID = @KkmID
			SET @Action = ISNULL(@Action,'') + 'Версия прошивки ККМ обновлена. '
		end
	---- Добавляем MAC, если пусто
	If		@MAC is not null
		and @MAC != ISNULL((SELECT MAC FROM KKM WHERE RID = @KkmID), '') 
		begin 
			UPDATE KKM set MAC = @MAC, updateDate = GETDATE() WHERE RID = @KkmID
			SET @Action = ISNULL(@Action,'') + 'Обновлен MAC адрес ККМ. '
		end
	---- Добавляем RNDIS, если пусто
	If		@RNDIS is not null
		and @RNDIS != ISNULL((SELECT RNDIS FROM KKM WHERE RID = @KkmID), -1)
		begin 
			UPDATE KKM set RNDIS = @RNDIS, updateDate = GETDATE() WHERE RID = @KkmID
			SET @Action = ISNULL(@Action,'') + 'Обновлена информация о настройке RNDIS. '
		end
	---- Добавляем IP и порт, если не заполнено
	If		@IpAddress is not null
		and @IpAddress != ISNULL((SELECT IpAddress FROM KKM WHERE RID = @KkmID), -1)
		begin 
			UPDATE KKM set IpAddress = @IpAddress, updateDate = GETDATE() WHERE RID = @KkmID
			SET @Action = ISNULL(@Action,'') + 'Обновлена информация об IP. '
		end
	If		@IpPort is not null
		and @IpPort != ISNULL((SELECT ipPort FROM KKM WHERE RID = @KkmID), -1)
		begin 
			UPDATE KKM set ipPort = @IpPort, updateDate = GETDATE() WHERE RID = @KkmID
			SET @Action = ISNULL(@Action,'') + 'Обновлена информация об IP. '
		end
	If		@LoaderVersion is not null
		and @LoaderVersion != ISNULL((SELECT LoaderVersion FROM KKM WHERE RID = @KkmID), -1)
		begin
			UPDATE KKM set LoaderVersion = @LoaderVersion, updateDate = GETDATE() WHERE RID = @KkmID
			SET @Action = ISNULL(@Action,'') + 'Обновлена информация о загрузчике. '
		end

	--если на данный момент @Action не определён, значит никаких действий не требуется 
	If 	@Action = '' Set @Action =  'Обновление не требуется. ';
	
End;

GO

