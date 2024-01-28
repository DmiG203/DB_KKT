CREATE PROCEDURE [dbo].[SetStatusNotUseKkm]
            (
			 @KkmId			int				= null
			,@KKMsn			nvarchar(MAX)	= null
			,@KKMmodel		nvarchar(MAX)	= null
			,@NotUseType	int				= 3
			,@Comment		nvarchar(MAX)	= 'Причина добавления не указана'
			,@Action		nvarchar(MAX)	= null	output
			,@NotUseId		int				= null	output
			)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Проверки данных
	-- В процедуру должно быть передано @KkmId или @KKMsn и @KKMmodel. @KKMsn можно без @KKMmodel, если в базе только одна ККМ с таким SN
	IF @KkmId is null and @KKMsn is null									-- проверка наличия параметров
		BEGIN
			SET @Action = 'В процедуру должно быть передано @KkmId или @KKMsn'
			RETURN -1
		END

	If @KkmId is not null													-- проверяем наличие ККМ с ID @KkmId
		BEGIN
			IF not EXISTS (SELECT RID FROM KKM WHERE RID = @KkmId)
				BEGIN
					SET @Action = 'ККМ с ID ' & @KkmId & 'Нет в БД'
					RETURN -2
				END
		END 
	
	IF @KkmId is null														-- проверки наличия ККМ по серйинику 
		BEGIN
			IF (SELECT count(*) FROM Kkm WHERE Deleted = 0 and SN = @KKMsn) > 1 and @KKMmodel is null
				BEGIN
					SET @Action = 'Найдено несколько ККМ с SN ' + @KKMsn + ' укажите модель ККМ'
					RETURN -3
				END
			IF (SELECT count(*) FROM Kkm WHERE Deleted = 0 and SN = @KKMsn and ModelID = (SELECT RID FROM KkmModel WHERE Name = @KKMmodel)) > 1
				BEGIN
					SET @Action = 'Найдено несколько ККМ с SN ' + @KKMsn + ' модели ' + @KKMmodel + '. Продолжение не возможно'
					RETURN -4
				END
			IF (SELECT RID FROM Kkm WHERE Deleted = 0 and Sn = @KKMsn and ModelID = (SELECT RID FROM KkmModel WHERE Name = @KKMmodel)) is null
				BEGIN
					SET @Action = 'ККМ с SN ' + @KKMsn + ' модели ' + @KKMmodel + '. Не найдено.'
					RETURN -5
				END
				SET @KkmId = (SELECT RID FROM Kkm WHERE Deleted = 0 and Sn = @KKMsn and ModelID = (SELECT RID FROM KkmModel WHERE Name = @KKMmodel))
		END
	
	-- Пробуем найти @NotUseId. Если он есть, то касса в списке неиспользуемых
	Set @NotUseId = (SELECT RID FROM KkmNotUse WHERE KkmId = @KkmId AND (StopDate is null or StopDate = CONVERT (date, GETDATE())))

	IF @NotUseId is null													-- ККМ нет в списке неиспользуемых. Добавляем
		BEGIN 
			INSERT INTO KkmNotUse (KkmId, AddDate, Comment, NotUseType) VALUES (@KkmId, GETDATE(), @Comment, @NotUseType)
			SET @Action = 'ККМ добавлена в список неиспользуемых'
		END
	ELSE																	-- ККМ в списке неиспользуемых. Смотрим. Возможно два варианта 
		IF (SELECT StopDate FROM KkmNotUse WHERE RID = @NotUseId) = CONVERT (date, GETDATE())
			BEGIN
				UPDATE KkmNotUse SET StopDate = null, Comment = @Comment WHERE RID = @NotUseId
				SET @Action = 'ККМ возвращена в список неиспользуемых'
			END
		ELSE
			BEGIN
				UPDATE KkmNotUse SET StopDate = GETDATE() WHERE RID = @NotUseId
				SET @Action = 'ККМ исключена из списка неиспользуемых'
			END
		SET @NotUseId = (SELECT MAX(RID) FROM KkmNotUse WHERE KkmId = @KkmId)


	--If @KkmId is not null
	--	BEGIN
	--		SET @NotUseId = (SELECT RID FROM KkmNotUse WHERE KkmId = @KkmId and StopDate is null)
			
	--		-- Вызов процедуры без @AddDate и @StopDate - выдаём наличие в списке (@NotUseId)
	--		If @AddDate is null and @StopDate is null
	--			If @NotUseId is null  
	--				SET @Action = 'ККМ используется'
	--			Else 
	--				SET @Action = 'ККМ в списке неиспользуемых'
			
	--		-- есть @StopDate и ККМ уже в списке
	--		Else If @StopDate is not null and @NotUseId is not null
	--			BEGIN
	--				UPDATE KkmNotUse SET StopDate = @StopDate WHERE RID = @NotUseId
	--				SET @Action = 'ККМ убрана из списка неиспользуемых'
	--			END
			
	--		-- есть Comment, он отличается от предыдущего и ККМ уже в списке
	--		Else If @Comment is not null and @NotUseId is not null and @Comment != (SELECT Comment FROM KkmNotUse WHERE RID = @NotUseId)
	--			BEGIN 
	--				UPDATE KkmNotUse SET Comment = @Comment WHERE RID = @NotUseId
	--				SET @Action = 'Комментарий обновлен'
	--			END
			
	--		-- есть @AddDate и ККМ уже в списке
	--		Else If @AddDate is not null and @NotUseId is not null
	--			SET @Action = 'ККМ уже в списке неиспользуемых'

	--		-- есть @AddDate и ККМ в списке нет
	--		Else If @AddDate is not null and @NotUseId is null
	--			BEGIN
	--				INSERT INTO KkmNotUse (KkmId, Comment, AddDate, NotUseType) VALUES (@KkmId, @Comment, @AddDate, @NotUseType)
	--				SET @NotUseId = (SELECT RID FROM KkmNotUse Where KkmId = @KkmId and StopDate is null)
	--				SET @Action = 'ККМ добавлена в список неиспользуемых'
	--			END
	--	END
	--Else
	--	BEGIN 
	--		SET @Action = 'ККМ не найден. Работа со списком неиспользуемых запрещена'
	--		RETURN 1
	--	END
END
GO

