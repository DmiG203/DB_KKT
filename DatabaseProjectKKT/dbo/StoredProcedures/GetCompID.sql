-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCompID]
(
	   @Action nvarchar(MAX)  = '' output	--ответ процедуры
	  ,@CompID int output					--id Computer
	  ,@CompName nvarchar(max)				--Имя компа, на котором установлен ККМ
	  ,@OP int	 = null						--Номер ОП
      ,@Source nvarchar(MAX)
	  ,@ShtrihDrvVer nvarchar(max) = null
	  ,@AtolDrvVer nvarchar(max) = null
	  )
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE  @OpId int						-- id места установки ККМ (ОП)
			,@SourceID bigint				--ID текста
			,@CompType int					-- Тип компа

	-- Получаем ID текста
	-- для @SourceID
	EXEC	[dbo].[GetTextId]
			@text = @Source,
			@textID = @SourceID OUTPUT

	-- Тип компа из имени:
	Set @CompType = 0
	
	-- Сервера
	If @CompType = 0 AND @CompName like 'BAR-[0-9][0-9][0-9]' or @CompName like 'CINEMA-[0-9][0-9][0-9]'
		Set @CompType = 1

	--Кассы
	If @CompType = 0 AND (@CompName like 'BAR-%[0-9]-%___' OR @CompName like 'CASH-%[0-9]-%___')
		Set @CompType = 2

	--Оф станция
	If @CompType = 0 AND @CompName like 'BARO-%[0-9]-%___'
		Set @CompType = 3

	--Киоски
	If @CompType = 0 AND @CompName like 'SELFSRV-%[0-9]-%___' 
		Set @CompType = 4
	
	--Рабочие станции (под эту маску попадает почти всё, так что в конце)
	If @CompType = 0 AND @CompName like '%-%___'
		Set @CompType = 5


	-- @CompName не может быть пустым
	If @CompName is null
		begin
			Set @Action = 'Имя компьютера не может быть пустым '
			RETURN 1
		end;
	else
		begin
			-- получаем ID компьютера
			Set @CompID = (Select rid from Computers where ComputerName = @CompName)

			-- получаем ID подразделения
			If @OP is not null
				begin
					-- @OpID необходим только если он не записан в карточке компа или компа нет вовсе, поэтому берём первый ID, если таких хзаписей несколько.
					-- В других случаях необходимо брать OpID из карточки компа. Подрузамевается, что если есть несколько записей с одним NumOp - распределение будет ручным
					Set @OpId = (Select MIN(rid) from Org Where Org.NumOP = @OP)
					If @OpId is null																--не нашли? Выходим
						begin
							Set @Action = 'ОП ' + CAST(@OP as nvarchar) + ' не найдено в БД. Сначала добавьте ОП'
							RETURN 1
						end;
				end;

			-- @OpID необходим только если он не записан в карточке компа или компа нет вовсе, поэтому 

			-- если @ComputerName нет, заводим новый
			If @CompID is null 
				begin
					INSERT INTO Computers([ComputerName],[OrgID],[addDate],[updateDate],[SourceID],[shtrihDrvVer],[atolDrvVer], [ComputerType]) VALUES (@CompName,@OpId,GETDATE(),GETDATE(),@SourceID,@shtrihDrvVer,@atolDrvVer,@CompType)
					Set @CompID = (Select rid from Computers where ComputerName = @CompName)
					Set @Action = isnull(@Action,'') + 'Добавлен ' + @CompName + '. '
				end;
			Else		-- если есть комп, смотрим его данные на предмет обновления
				begin
					-- если нет ОП в компьютере - записываем:
					if @OpId is not null and  (select OrgId from Computers where RID = @CompID) is null
						begin 
							update Computers set updateDate = GetDate(), [SourceID] = @SourceID, OrgID = @OpId where RID = @CompID
							Set @Action = isnull(@Action,'') + 'Для ' + @CompName + ' прописано ОП. '
						end;

					-- если не совпадает версия драйвера - обновляем
					If @shtrihDrvVer is not null and ISNULL((select shtrihDrvVer from Computers where RID = @CompID),'') != @shtrihDrvVer
						begin
							update Computers set updateDate = GetDate(), [SourceID] = @SourceID, shtrihDrvVer = @ShtrihDrvVer where RID = @CompID
							Set @Action = isnull(@Action,'') + 'Для ' + @CompName + ' обновлена версия драйвера Штриха. '
						end;
					If @AtolDrvVer is not null and ISNULL((select AtolDrvVer from Computers where RID = @CompID),'') != @AtolDrvVer
						begin
							update Computers set updateDate = GetDate(), [SourceID] = @SourceID, AtolDrvVer = @AtolDrvVer where RID = @CompID
							Set @Action = isnull(@Action,'') + 'Для ' + @CompName + ' обновлена версия драйвера Штриха. '
						end;

					-- если не совпадает тип компа, обновляем
					If (select ComputerType from Computers where RID = @CompID) != @CompType
						begin 
							update Computers set UpdateDate = GETDATE(), [SourceID] = @SourceID, ComputerType = @CompType where RID = @CompID
							Set @Action = isnull(@Action,'') + 'Для ' + @CompName + ' Обновлен тип компьютера. '
						end;
				end;
			end;

			-- обновляем дату запуска (считаем, что запрос = запуск, хотя это не совсем верно...)
			update Computers set LastStart = GETDATE() where [RID] = @CompID
END

GO

