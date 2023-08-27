CREATE procedure [dbo].[AddFn] (
	   @Action nvarchar(MAX) output
	  ,@snFnID int = null output
	  ,@snFN nvarchar(16)
      ,@modelFn nvarchar(MAX)=null
      ,@SnKkm nvarchar(MAX)=null
	  ,@ModelKkm nvarchar(MAX)= null
	  ,@Source nvarchar(MAX)
	  ,@FNexpired date = null
	  ,@FreeReg int = null
	  ,@Status int = null
	  ,@LastDocNum int = null
	  ,@LastDocDate datetime = null
	  ,@UnconfirmedDoc int = null
	  ,@KkmID  int = null output
	  )

AS
Begin
	Declare  @ModelID int
			--,@KkmID  int
			,@ModelKkmID int

	Set @snFnID = (Select rid from fn where sn = @snFN);
	Set @ModelID = (Select rid from fnModel where mask = LEFT(@snFN,6));
	Set @Action = null
	Set @ModelKkmID = (select rid from kkmModel where kkmModel.Name = @ModelKkm)

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
			Insert Into fn ([sn],[modelId],[kktID],[UpdateDate],[AddDate],[Source],[STATUS],[DateExpired],[FreeReg],[LastDocNum],[LastDocDate]) Values (@snFN,@ModelID,@KkmID,GETDATE(),GETDATE(),@Source,@Status,@FNexpired,@FreeReg,@LastDocNum,@LastDocDate);
			Set @Action = 'ФН добавлен. ';
			Set @snFnID = (Select RID from FN where Sn = @snFN);
		End;
	Else 
		-- смотрим, требуется ли обновление. 
		-- -- количество неотправленных чеков в ОФД
		If (@UnconfirmedDoc is not null) and @UnconfirmedDoc != isnull((select UnconfirmedDoc from fn where rid = @snFnID), -1)
			begin
				update fn set UpdateDate = getdate(), UnconfirmedDoc = @UnconfirmedDoc, source = @Source where rid = @snFnID
				Set @Action = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлено количество неотправленных чеков в ОФД. '
			end
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
		-- -- данные о последнем документе
		if @LastDocNum is not null and @LastDocNum !=ISNULL((select LastDocNum from fn where rid = @snFnId),0)
			begin
				update fn set UpdateDate = getdate(), source = @Source, LastDocNum = @LastDocNum, LastDocDate = @LastDocDate where rid = @snFnID
				Set @Action  = isnull(@Action,'') + 'ФН ' + @snFN + ' обновлена информация о последнем документе ФН. '
			end;
		-- -- если данные о ККМ не записаны, и они есть, запишем
		if (@KkmID is not null) and ((select kktID from fn where rid = @snFnID) is null)
			begin
				update fn set UpdateDate = getdate(), kktID = @kkmID, source = @Source where rid = @snFnID
				Set @Action  = isnull(@Action,'') + 'ФН ' + @snFN + ' добавлена информация о ККМ. '
			end;

		-- если ничего не сделали
		if @Action is null Set @Action = 'ФН существует. ';
End;

GO

