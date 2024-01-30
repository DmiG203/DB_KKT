CREATE PROCEDURE [dbo].[GetRnmID]
	 @CodeNO		char(4)
	,@DateReg		datetime		= null
	,@Adds			nvarchar(max)
	,@RNM			char(16)		= null
	,@KkmSn			nvarchar(max)
	,@KkmModel		nvarchar(max)
	,@DateExpired	date			= null
	,@Status		nvarchar(max)
	,@Ofd			nvarchar(max)	= null
	,@FnSn			char(16)		= null
	,@OpKpp			char(9)
	,@OpInn			char(10)
	,@PlaceName		nvarchar(max)	= null
	,@RegMode		int             = null
	,@RNMid			int				OUTPUT
	,@bUpdate		bit				OUTPUT
    ,@Action		nvarchar(max)   OUTPUT
    ,@NumDev		nvarchar(max)   = null
AS
BEGIN
	Declare @KkmID int,
			@AddsID int,
			@OfdOrgID int,
			@FnID int,
			@OpId int

	-- обнуляем пустые входящие
	SET @Action = null
	If @RNM = ''			SET @RNM			= null
	If @DateExpired = ''	SET @DateExpired	= null
	If @Ofd = ''			SET @Ofd			= null
	If @FnSn = ''			SET @FnSn			= null
	If @PlaceName = ''		SET @PlaceName		= null
	If @bUpdate is null		SET @bUpdate = 0
	
	-- пустой РНМ не пишем, ошибку не возвращаем
	If @RNM is null 
		BEGIN
			SET @Action = 'Запись без РНМ. Пропущено'
			RETURN 0
		END
	-- Собираем данные 
	SET @KkmID = (select RID from Kkm where sn = @KkmSn and ModelID = (select RID from KkmModel where KkmModel.Name = @KkmModel))
	IF @KkmID is null
		BEGIN
			SET @Action = 'Не найден ККМ ' + @KkmModel + ' №' + RTRIM(@KkmSn) + ', сначала добавьте ККМ'
			RETURN -1
		END
	EXEC AddFn @snFN = @FnSn, @SnKkm = @KkmSn,  @ModelKkm = @KkmModel, @Source = "Добавлен при обработке РНМ", @snFnID = @FnID output, @Action = @Action output

	IF @Adds is not null
		EXEC GetAddsID @adds = @adds, @AddsID = @AddsID OUTPUT
	
	IF @Ofd is not null
		SET @OfdOrgID = (SELECT RID FROM Org WHERE Name = @Ofd)

	If @OpKpp is not null and @OpInn is not null
		SET @OpId = (SELECT RID FROM Org WHERE INN = @OpInn AND KPP = @OpKpp)
	IF @OpId is null
		BEGIN
			SET @Action = 'Не найден ОП по ИНН/КПП ' + RTRIM(@OpInn) + '/'+ RTRIM(@OpKpp)  + ', сначала добавьте ОП'
			RETURN -3
		END

    -- Обновляем или добавляем данные
	BEGIN transaction;
	IF EXISTS  (SELECT  @CodeNO, @DateReg, @AddsID, @RNM, @KkmID, @DateExpired, @Status, @OfdOrgID, @FnID, @OpID, @PlaceName, @RegMode, @NumDev
				EXCEPT
				SELECT CodeNO, [DateReg],[AddsID],[RNM],[KkmID],[DateExpired],[Status],[OfdOrgID],[FnID],[OpID],[PlaceName],[RegMode],[NumDev]
						FROM [dbo].[FNSData] 
						WHERE RNM = @RNM AND [KkmID] = @KkmID AND [DateReg] = @DateReg
				
				)
		BEGIN
			UPDATE	[dbo].[FNSData]  WITH (UPDLOCK, SERIALIZABLE)
			SET		
					[CodeNo]		= @CodeNO,
					[DateReg]		= @DateReg,
					[AddsID]		= @AddsID,
					[DateExpired]	= @DateExpired,
					[Status]		= @Status,
					[OfdOrgID]		= @OfdOrgID,
					[OpID]			= @OpId,
					[PlaceName]		= @PlaceName,
					[RegMode]		= @RegMode,
					[UpdateDate]	= GetDate()
			WHERE	[RNM] = @RNM AND [KkmID] = @KkmID AND [DateReg] = @DateReg
			
			IF @@ROWCOUNT = 0 
				BEGIN
					INSERT INTO [dbo].[FNSData]	
						([CodeNo],[DateReg],[AddsID],[RNM],[KkmID],[DateExpired],[Status],[OfdOrgID],[FnID],[OpID],[PlaceName],[RegMode],[AddDate],[UpdateDate],[NumDev])
					VALUES
						(@CodeNO, @DateReg, @AddsID, @RNM, @KkmID, @DateExpired, @Status, @OfdOrgID, @FnID, @OpId, @PlaceName, @RegMode, GETDATE(), GETDATE(), @NumDev)
					SET @Action = 'Добавлен новый РНМ'
				END
			IF @Action is null SET @Action = 'РНМ обновлен'
			SET @bUpdate = 1
		END
	COMMIT transaction;
	
	SET @RNMid = (SELECT RID FROM FNSData WHERE RNM = @RNM AND KkmID = @KkmID AND FnID = @FnID AND [DateReg] > 0) 
	IF @Action is null SET @Action = 'Обновление РНМ не требуется'
	
END
GO

