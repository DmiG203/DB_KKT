
CREATE procedure [dbo].[UpdateRepReg] (
	   @RepRegID int = null output
	  ,@Action nvarchar(MAX) = null output
	  ,@FnId int  = null output
	  ,@snFn nvarchar(16)
      ,@DateRep datetime
      ,@cashier nvarchar(MAX) = null
      ,@adds nvarchar(MAX) = null
      ,@FPD nvarchar(MAX)
      ,@FD int = null
	  ,@RegTypeId int = null
	  ,@Source nvarchar(MAX)
	  ,@WorkMode int = null
	  )
AS
Begin
	Declare @addsId int,
			@statusFn int = 0,
			@AddFn int = 0

	--обнуляем пустые переменные 
	If @cashier = '' set @cashier = null
	If @adds = '' set @adds = null
	If @FD = '' set @FD = null
	If @WorkMode='' set @WorkMode = null

/*	If @FD is Null
		begin
			Set @Action = 'Нет номера отчета, нельзя добавить'
			return 0
		end;
*/

	--Получаем FnId
	Set @FnId =  (Select rid from fn where sn =  @snFn)
	If @FnId is null
		Begin
			Set @Action = 'Нет такой ФНки! ;('
			return 1
		End

	--определяем тип отчета, если он не был передан в процедуру
	If @RegTypeId is null
		If @FD = 1 Set @RegTypeId = 1
		Else Set @RegTypeId = 2
	--определяем статус fn, который будет после добавления отчета (0 - новый, 1 - в работе, 2 - закрыт)
	If @RegTypeId = 3 
		Set @statusFn = 2
	Else 
		Set @statusFn = 1


	--по номеру Fn и FPD отчета получаем RID отчета, если он есть в базе
	Set @RepRegID = (Select TOP(1) rid from RepReg where fnID = @FnId and cast(fpd as bigint) = cast(@FPD as bigint) order by RID)
	If @RepRegID is null 
		begin
			Insert Into RepReg (DateRep,	cashier,	addsId,		fnID,	FPD,	FD,		RepTypeID,	source,		AddDate,	UpdateDate,	WorkMode) 
						Values (@DateRep,	@cashier,	@addsId,	@FnId,	@FPD,	@FD,	@RegTypeId,	@Source,	GETDATE(),	GETDATE(),	@WorkMode)
				
			Set @RepRegID = (Select TOP(1) rid from RepReg where fnID = @FnId and cast(fpd as bigint) = cast(@FPD as bigint) order by RID)  
			Set @Action = 'Отчет добавлен'
			return 0
		end

	--получаем ID адреса, если адрес передали
	If @adds is not null
		Exec GetAddsId @adds, @addsId = @addsId OUTPUT
	 
	-- если отчет уже есть, смотрим нужно ли обновить
	-- проверяем, требуется ли обновление
	If not (
		--обновляем, если различаются даты
		((isnull((Select [DateRep] from RepReg where RID = @RepRegID),0)) = @DateRep) and 
		--обновляем, если различается ФПД
		((isnull((Select [FPD] from RepReg where RID = @RepRegID),0))  = @FPD) and
		--обновляем, если различается тип отчета
		((isnull((Select [RepTypeID] from RepReg where RID = @RepRegID),0))  = @RegTypeId) and
		--обновляем, если разлчается workMode
		((isnull((Select [WorkMode] from RepReg where Rid = @RepRegID),0)) = @WorkMode)
		) and 
		-- только если FD FPD больше нуля
		(Cast(@FPD as BigInt) > 0 and
		@FD > 0
		)
		Begin
			Update RepReg Set 
				 [DateRep] = @DateRep 
				,[RepTypeID] = @RegTypeId
				,[source] = @Source
				,[UpdateDate] = GetDate()
				,[FPD] = @FPD
				,[WorkMode]  = @WorkMode
				where RID = @RepRegID
			Set @Action = isnull(@Action,'') + 'Обновлены дата, режим регистрации, ФПД или тип отчета. '
		End;

			
	--обновляем, если кассир не пустой и не совпадает с текущим
	If @cashier is not null
		If isnull((Select [cashier] from RepReg where RID = @RepRegID),'') != @cashier
			Begin
				Update RepReg Set [cashier] = @cashier, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
				Set @Action = isnull(@Action,'') + 'Обновлён кассир. '
			End;
	--обновляем, если адрес не пустой и не совпадает с текущим
	If @adds is not null 
		If isnull((Select [addsId] from RepReg where RID = @RepRegID),'')  != @addsId
			Begin
				Update RepReg Set [addsId] = @addsId, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
				Set @Action = isnull(@Action,'') + 'Обновлён адрес. '
			End;
	--обновляем, если FD различается
	If isNull((select FD from RepReg where RID = @RepRegID), 0) !=  @FD 
			Begin
				Update RepReg Set FD = @FD, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
				Set @Action = isnull(@Action,'') + 'Обновлён ФД. '
			End;

	If @Action is null
		Set @Action = 'Обновление не требуется' 
	Else
		Set @Action = 'Отчёт обновлён: (' + isnull(@Action,'') + ')'
End

GO


GRANT EXECUTE
    ON OBJECT::[dbo].[UpdateRepReg] TO [cash]
    AS [dbo];
GO

