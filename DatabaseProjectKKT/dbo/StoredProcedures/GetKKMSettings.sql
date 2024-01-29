CREATE procedure [dbo].[GetKKMSettings] (
	   @Action nvarchar(MAX) = null OUTPUT 
	  ,@snKKM nvarchar(MAX)
	  ,@modelKKM nvarchar(MAX)
	  ,@WorkMode int = null OUTPUT
	  )

AS
SET NOCOUNT ON; 
BEGIN

	DECLARE  @KkmModelID int	--ID модели ККМ 
			,@KkmID int			--ID ККМ
			,@CompID int		--станция, где установлена ККМ
			,@OrgID int			--кинотеатр, где установлена ККМ
			,@KkmFFD int		--FFD
			,@FnModelID int		--ID модели ФН 
			,@FnID int			--ID ФН (забираем ФН с большим ID)

	--обнуляем @Action
	Set @Action = ''

	-- возвращем настройки кассы
	--получаем ID модели
	SET @KkmModelID = (SELECT RID FROM kkmModel WHERE Name = @modelKKM)
	IF @KkmModelID is null 
		BEGIN
			SET @Action = ISNULL(@Action,'') + 'Модель "' + @modelKKM + '" не найдена в БД'
			RETURN 1
		END
			
	--получаем ID ККМ

	IF  (SELECT count(*) FROM ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID and DateExpired = 
		(select max(DateExpired) from  ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID)) = 1
		BEGIN
			SET @KkmID = (SELECT KkmID FROM ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID and DateExpired = 
						 (select max(DateExpired) from  ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID))
			SET @FnID = (SELECT FnID FROM ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID and FnID = 
						 (select max(FnID) from  ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID))
		END
	ELSE IF (SELECT count(*) FROM ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID and DateExpired =
			(select max(DateExpired) from  ViewKkmList WHERE KkmSn = @snKKM and KkmModelID = @KkmModelID)) > 1
		BEGIN
			SET @Action = ISNULL(@Action,'') + 'Найдено несколько ККМ ' + @modelKKM + ' № ' + @snKKM + '. Продолжение невозможно. '
			RETURN 1
		END
	ELSE
		BEGIN
			SET @Action = ISNULL(@Action,'') + 'ККМ ' + @modelKKM + ' №' + @snKKM + ' не найден в базе данных. '
			RETURN 1
		END

	-- получаем все необходимые данные
			
	SET @OrgID		= isnull((SELECT TOP(1) OrgID		FROM ViewKkmList WHERE KkmID = @KkmID),0)
	SET @KkmFFD		= isnull((SELECT KkmFFD				FROM ViewKkmList WHERE KkmID = @KkmID and FnId = @FnID),0)
	SET @WorkMode	= isnull((SELECT TOP(1) WorkMode	FROM ViewKkmList WHERE KkmID = @KkmID),99)					-- если настройки в базе нет, будем возвращать 99
	SET @CompID		= isnull((SELECT TOP(1) CompID		FROM ViewKkmList WHERE KkmID = @KkmID),0)
	SET @FnModelID	= isnull((SELECT fnModelID			FROM ViewKkmList Where KkmID = @KkmID and FnId = @FnID),0)

	/*------------------------------------------------------------------------------------------------
	получаем настройки для ККМ. 
	последовательность определяется графой priority:
	------------------------------------------------------------------------------------------------*/		
	SELECT [name],[TableForSHTRIH],[Value],[RegParam],[ParametrNumAtol]
	from kkmSettings
	where RID in (
	SELECT RID
		FROM kkmSettings set_out
		Where ISNULL(set_out.[priority], -1) = (select MAX([priority]) 
												from kkmSettings set_in 
												where 
													set_out.[TableForSHTRIH] = set_in.[TableForSHTRIH] 
													and ISNULL(OrgID,		@OrgID)			= @OrgID
													and ISNULL(KkmModelID,	@KkmModelID)	= @KkmModelID
													and ISNULL(KkmFFD,		@KkmFFD)		= @KkmFFD
													and ISNULL(KkmID,		@KkmID)			= @KkmID
													and ISNULL(CompID,		@CompID)		= @CompID
													and ISNULL(WorkMode,	@WorkMode)		= @WorkMode
													and ISNULL(FnModelID,	@FnModelID)		= @FnModelID
												GROUP BY set_in.[TableForSHTRIH])
			and ISNULL(OrgID,		@OrgID)			= @OrgID
			and ISNULL(KkmModelID,	@KkmModelID)	= @KkmModelID
			and ISNULL(KkmFFD,		@KkmFFD)		= @KkmFFD
			and ISNULL(KkmID,		@KkmID)			= @KkmID
			and ISNULL(CompID,		@CompID)		= @CompID
			and ISNULL(WorkMode,	@WorkMode)		= @WorkMode
			and ISNULL(FnModelID,	@FnModelID)		= @FnModelID
	)
	order by TableForSHTRIH
	SET @Action =  ISNULL(@Action,'') + 'Настройки для ККМ ' + @modelKKM + ' ' + @snKKM + ' выданы. '
END

GO


GRANT EXECUTE
    ON OBJECT::[dbo].[GetKKMSettings] TO [cash]
    AS [dbo];
GO

