CREATE procedure [dbo].[AddFn] (
	   @Action			nvarchar(MAX) output
	  ,@snFnID			int = null output
	  ,@snFN			nvarchar(16)
      ,@modelFn			nvarchar(MAX)=null
      ,@SnKkm			nvarchar(MAX)=null
	  ,@ModelKkm		nvarchar(MAX)= null
	  ,@Source			nvarchar(MAX)
	  ,@FNexpired		date = null
	  ,@FreeReg			int = null
	  ,@Status			int = null
	  ,@LastDocNum		int = null
	  ,@LastDocDate		datetime = null
	  ,@UnconfirmedDoc	int = null
	  ,@KkmID			int = null output
	  ,@FirstDocDate	date = null
	  ,@FirstDocNum		int = null
	  ,@FnDeleted		bit = 0
	  )

AS
Begin
	Declare  @ModelID int
			,@SourceID  bigint
			,@ModelKkmID int

	Set @snFnID = (Select rid from fn where sn = @snFN);
	Set @ModelID = (Select rid from fnModel where mask = LEFT(@snFN,6));
	Set @Action = null
	Set @ModelKkmID = (select rid from kkmModel where kkmModel.Name = @ModelKkm)

	-- получаем ID для Source
	EXEC GetTextID 
			@text = @Source, 
			@TextID = @SourceID OUTPUT 
	
	-- если дата блокировки не передана, проставляем нулевую дату
	If @FNexpired is null 
		Set @FNexpired = convert(date, '01.01.1970',104)

	-- если модель ККМ не передана, забираем текущую можель данной кассы, только если это не ритейл
	If (@ModelKkm is null)
		BEGIN
			Set @ModelKkmID = (select ModelID from kkm where sn = @SnKkm and deleted = 0)
			if @ModelKkmID in (2) --,14)																-- исключаем ритейлы
				set @ModelKkmID = null
		END;	

	-- если статус пустой - устанавливаем 0 (новая ФН)
	If @Status is null Set @Status = 0
	
	If @ModelID is null 
		BEGIN
			Set @Action = 'Для ФН №' + isnull(@snFN,'NULL') + ' не определена модель. Сначала добавьте модель для ФН';
			RETURN 1;
		END;

	-- Получаем @KkmID. Если в этот момент не определён @ModelKkmID, KkmID мы так же не получем и запишем null
	Set @KkmID =  (Select rid from KKM where sn =  @SnKkm and kkm.modelID = @ModelKkmID);

	If @snFnID is null
		Begin
			Insert Into fn ([sn],[modelId],[kktID],[UpdateDate],[AddDate],[Source],[STATUS],[DateExpired],[FreeReg],[LastDocNum],[LastDocDate], [Deleted]) Values (@snFN,@ModelID,@KkmID,GETDATE(),GETDATE(),@Source,@Status,@FNexpired,@FreeReg,@LastDocNum,@LastDocDate,@FnDeleted);
			Set @Action = 'ФН добавлен. ';
			Set @snFnID = (Select RID from FN where Sn = @snFN);
		End;
	Else 
		BEGIN
			-- смотрим, требуется ли обновление. 
	
			/*If (@UnconfirmedDoc is not null) and @UnconfirmedDoc != isnull((select UnconfirmedDoc from fn where rid = @snFnID), -1)
				begin
					update fn set UpdateDate = getdate(), UnconfirmedDoc = @UnconfirmedDoc, source = @Source where rid = @snFnID
					Set @Action = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлено количество неотправленных чеков в ОФД. '
				end*/
			-- -- Дата блокировки
			If @FNexpired != convert(date, '01.01.1970',104) and @FNexpired != isnull((select DateExpired from fn where rid = @snFnID),'') 
				begin 
					update fn set UpdateDate = getdate(), DateExpired = @FNexpired, source = @Source where rid = @snFnID
					Set @Action = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлена дата срока жизни ФН. '
				end;
			-- -- оставшиеся перерегистрации
			If @FreeReg != isnull((select FreeReg from fn where rid = @snFnID),'')
				begin 
					update fn set UpdateDate = getdate(), FreeReg = @FreeReg, source = @Source where rid = @snFnID
					Set @Action = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлено количество свободных регистраций. '
				end;
			-- -- статус ФН (обновляем статус только на увеличение)
			if @Status > isnull((select status from fn where rid = @snFnID),-1)
				begin
					update fn set UpdateDate = getdate(), Status = @Status, source = @Source where rid = @snFnID
					Set @Action = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлен статус жизни ФН. '
				end;
			-- -- если есть данные о ККМ и они отличаются, обновим их 
			if (@KkmID is not null) and @KkmID != (isnull((select kktID from fn where rid = @snFnID), 0))
				begin
					update fn set UpdateDate = getdate(), kktID = @kkmID, source = @Source where rid = @snFnID
					Set @Action  = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлена информация о ККМ. '
				end;
		END;
		-- Записываем, если необходимо, номер/дату последнего чека и неоправленные документы:
		-- -- количество неотправленных чеков в ОФД
		IF (@UnconfirmedDoc is not null)
			IF @UnconfirmedDoc != ISNULL((SELECT UnconfirmedDoc FROM FnDocs WHERE [Type] = 2 and RID = 
										(SELECT MAX(RID) FROM FnDocs WHERE [Type] = 2 and FnId = @snFnID)),-1)
				BEGIN
					INSERT INTO FnDocs (FnID, UnconfirmedDoc, DocDate, DocNum, [Type], SourceID, UpdateDate, AddDate)
					VALUES
					(@snFnID, @UnconfirmedDoc, @FirstDocDate, @FirstDocNum, 2, @SourceID, GETDATE(), GETDATE())
					Set @Action = ISNULL(@Action,'') + 'ФН ' + @snFN + ' добавлено количество неотправленных чеков в ОФД. '
				END
		-- -- данные о послендем документе
		IF (@LastDocNum is not null) 
			IF @LastDocNum !=ISNULL((SELECT DocNum FROM FnDocs WHERE [Type] = 1 AND RID = 
									(SELECT MAX(RID) FROM FnDocs WHERE [Type] = 1 AND FnId = @snFnId)),0)
				begin
					INSERT INTO FnDocs (FnID, DocDate, DocNum, [Type], SourceID, UpdateDate, AddDate)
					VALUES
					(@snFnID, @LastDocDate, @LastDocNum, 1, @SourceID, GETDATE(), GETDATE())
					Set @Action  = ISNULL(@Action,'') + 'ФН ' + @snFN + ' добавлена информация о последнем документе ФН. '
				end;

		-- если ничего не сделали
		if @Action is null Set @Action = 'ФН существует. ';
End;

GO


GRANT EXECUTE
    ON OBJECT::[dbo].[AddFn] TO [cash]
    AS [dbo];
GO

