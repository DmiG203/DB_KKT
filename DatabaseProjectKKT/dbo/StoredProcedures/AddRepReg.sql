
CREATE procedure [dbo].[AddRepReg] (
	   @RepRegID int output
	  ,@Action nvarchar(MAX) = null output 
	  ,@FnId int output
	  ,@AddError bit  = null output
	  ,@snFn nvarchar(16)
      ,@DateRep datetime = null
      ,@cashier nvarchar(MAX) = null
      ,@adds nvarchar(MAX) = null
      ,@FD int  = null
	  ,@FPD nvarchar(MAX) = null
	  ,@FFD nvarchar(4) = null
      ,@Comment nvarchar(MAX) = null
	  ,@RegTypeId int = null
	  ,@Source nvarchar(MAX)
	  ,@WorkMode int = null
	  ,@WorkModeEx int = null
	  ,@snKKM nvarchar(MAX) = null
	  ,@modelKKM nvarchar(MAX) = null
	  ,@FNexpired date = null
	  ,@FreeReg int = null
	  ,@RNM nvarchar(16) = null
	  ,@link nvarchar(MAX) = null
	  ,@LastDocNum int = null
	  ,@LastDocDate datetime = null
	  ,@UnconfirmedDoc int = null
	  ,@teg1290 int = null
	  ,@RegCheckID int = null

	  )
AS
Begin
	Declare  @addsId int
			,@Update bit = 0
			,@statusFn int = 0
			,@AddFn int = 0
			,@ActionFN nvarchar(max)

	--обнуляем пустые переменные 
	If @cashier = ''	set @cashier = null
	If @Comment = ''	set @Comment = null
	If @adds = ''		set @adds = null
	If @snKKM = ''		set @snKKM = null
	If @FD = ''			set @FD = null
	If @RNM = ''		set @RNM = null
	If @link = ''		set @link = null
	Set @Action = null

	-- проверяем или переопределяем FFD:
	Set @FFD = 
		CASE @FFD
			WHEN '1.0'	THEN '1'
			WHEN '1.05'	THEN '2'
			WHEN '1.1'	THEN '3'
			WHEN '1.2'	THEN '4'
			ELSE @FFD
		End
	
	If ISNUMERIC(@FFD) = 0 or not (CAST(@FFD as int) > 1 and CAST(@FFD as int) <= 4)
		Set @FFD = null
			
	--определяем статус fn, который будет после добавления отчета (0 - новый, 1 - в работе, 2 - закрыт)
	If @RegTypeId = 3 
		Set @statusFn = 2
	Else 
		Set @statusFn = 1
	-- если отчета о регистрации нет, статус ФН - 0
	If @FD is null
		Set @statusFn = 0
--select @FnId,@snFn, @snKKM, @modelKKM, @Source, @FNexpired, @FreeReg, @statusFn, @LastDocNum,  @LastDocDate,  @UnconfirmedDoc
	--Обновляем информацию по ФН 
	EXEC	 @AddFn = AddFN 
			 @Action = @ActionFN OUTPUT
			,@snFnID = @FnId OUTPUT
			,@snFN = @snFn
			,@SnKkm = @snKKM
			,@modelKKM = @modelKKM
			,@Source = @Source
			,@FNexpired = @FNexpired
			,@FreeReg = @FreeReg
			,@status = @statusFn
			,@LastDocNum = @LastDocNum 
			,@LastDocDate = @LastDocDate 
			,@UnconfirmedDoc = @UnconfirmedDoc

	-- зачищаем Action, если вернулось 'ФН существует. ' или прибовляем пробел в конце
	if @ActionFN = 'ФН существует. ' 
		Set @ActionFN = null
	else 
		set @ActionFN = @ActionFN + ' '

	-- Функция добавления ФН вернула ошибку. Выходим, передав эту ошибку наружу
	If	@AddFN != 0 
		begin
			Set @Action = @ActionFN
			Set @RepRegID = null
			RETURN 1
		end; 

	--Получаем FnId
	Set @FnId = (Select rid from fn where sn =  @snFn)

	--по номеру Fn и отчета получаем RID отчета, если он есть в базе
	If @Fd is null
		Set @RepRegID = (Select TOP(1) rid from RepReg where fnID = @FnId and FPD = @FPD order by DateRep desc)
	Else
		Set @RepRegID = (Select TOP(1) rid from RepReg where fnID = @FnId and fd = @FD order by DateRep desc)

	--получаем ID адреса, если адрес передали
	If @adds is not null
		Exec GetAddsId @adds, @addsId = @addsId OUTPUT
	 
	--определяем тип отчета, если он не был передан в процедуру
	If @RegTypeId is null
		If @FD = 1 
			Set @RegTypeId = 1
		Else
			Set @RegTypeId = 2


	-- если это отчет о закрытии архива ФН, и нет адреса, возьмём его с предыдущего отчета
	If @RegTypeId = 3 and @addsId is null
		Set @addsId = (Select TOP(1) addsID from RepReg where fnID = @FnId and RepTypeID !=3 order by DateRep DESC)

	-- Работаем только если есть FD или FPD
	If @FD is not null or @FPD is not null
		begin
			-- если отчет уже есть и FPD больше 0, смотрим нужно ли обновить
			If (@RepRegID is not null) and (Cast(@FPD as BigInt) > 0)
				Begin
					--обновляем, если различается RNM
					If @RNM is not null
						If isnull((Select [RNM] from RepReg where RID = @RepRegID),0) != @RNM
							Begin
								Update RepReg Set [RNM] = @RNM, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён РНМ.  '								
							End;	
					--если WorkMode не передали,подсмотрим его в отчете
					If @WorkMode is null
						Set @WorkMode = (select WorkMode from RepReg where RID = @RepRegID)
					--обновляем, если разлчается workMode	
					If @WorkMode is not null
						If isnull((Select [WorkMode] from RepReg where RID = @RepRegID),-1) != @WorkMode	
							Begin
								Update RepReg Set [WorkMode] = @WorkMode, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён режим регистрации.  '								
							End;
					If @WorkModeEx is not null
						If isnull((Select [WorkModeEx] from RepReg where RID = @RepRegID),-1) != @WorkModeEx	
							Begin
								Update RepReg Set [WorkModeEx] = @WorkModeEx, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён расширенный режим регистрации.  '								
							End;						
					
					--обновляем, если различается тип отчета
					If @RegTypeId is not null
						If isnull((Select [RepTypeID] from RepReg where RID = @RepRegID),0) != @RegTypeId					
							Begin
								Update RepReg Set [RepTypeID] = @RegTypeId, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён тип отчета.  '								
							End;

					--обновляем, если различается ФПД
					If @FPD is not null
						If isnull((Select [FPD] from RepReg where RID = @RepRegID),0) != @FPD
							Begin
								Update RepReg Set [FPD] = @FPD, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён ФПД.  '								
							End;
					
					--обновляем, если различаются даты 
					If @DateRep is not null
						If isnull((Select [DateRep] from RepReg where RID = @RepRegID),0) != @DateRep
							Begin
								Update RepReg Set [DateRep] = @DateRep, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлёна дата.  '
							End;
							
					--обновляем, если различается Link
					If @link is not null
						If isnull((Select [link] from RepReg where RID = @RepRegID),'') != @link
							Begin 
								Update RepReg Set [link] = @link, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлёна ссылка ОФД. '
							End;

					--обновляем, если @RegCheckID не пустой и не совпадает с текущим
					If @RegCheckID is not null
							If isnull((Select RegCheckID from RepReg where RID = @RepRegID),'') != @RegCheckID
								Begin
									Update RepReg Set RegCheckID = @RegCheckID, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
									Set @Update =  1
									Set @Action = isnull(@Action,'') + 'Обновлёна ссылка ОФД. '
								End;

					--обновляем, если кассир не пустой и не совпадает с текущим
					If @cashier is not null
						If isnull((Select [cashier] from RepReg where RID = @RepRegID),'') != @cashier
							Begin
								Update RepReg Set [cashier] = @cashier, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён кассир. '
							End;

					--обновляем, если адрес не пустой и не совпадает с текущим
					If @adds is not null 
						If isnull((Select [addsId] from RepReg where RID = @RepRegID),'')  != @addsId
							Begin
								Update RepReg Set [addsId] = @addsId, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён адрес. '
							End;
					--обновляем, если коммент не пустой, и не совпадает с текущим комментом
					If @Comment is not null
						If isnull((Select [Comment] from RepReg where RID = @RepRegID),'')  != @Comment
							Begin
								Update RepReg Set [Comment] = @Comment, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлён комментарий. '
							End;
					
					--обновляем, если FFD не пустой и не совпадает с текущим
					If @FFD is not null
						If isnull((Select [FFD] from RepReg where RID = @RepRegID),'')  != @FFD
							Begin
								Update RepReg Set [FFD] = @FFD, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
								Set @Update =  1
								Set @Action = isnull(@Action,'') + 'Обновлена версия FFD. '
							End;

					--обновляем, если teg1290 не пустой и не совпадает с текущим
					If @teg1290 is not null
						begin
							If isnull((Select teg1290 from RepReg where RID = @RepRegID),'')  != @teg1290
								Begin
									Update RepReg Set teg1290 = @teg1290, [source] = @Source, [UpdateDate] = GetDate() where RID = @RepRegID
									Set @Update =  1
									Set @Action = isnull(@Action,'') + 'Обновлены признаки условий применения ККТ (тэг 1209). '
								End;
						-- Можно попробовать получить WorkMode и WorkModeEx из teg1290
						/*
							0 - не используется (0)
							1 - ПРИНТЕР В АВТОМАТЕ
							2 - АС БСО
							3 - не используется (0)
							4 - не используется (0)
							5 - ККТ ДЛЯ ИНТЕРНЕТ
							6 - ПОДАКЦИЗНЫЕ ТОВАРЫ
							7 - не используется (0)
							8 - ТМТ
							9 - ККТ ДЛЯ УСЛУГ
							10 - ПРОВЕДЕНИЕ АЗАРТНОЙ ИГРЫ
							11 - ПРОВЕДЕНИЕ ЛОТЕРЕИ
							12 - ЛОМБАРД
							13 - СТРАХОВАНИЕ
							14 - ККТ С ТОРГ. АВТОМАТОМ
							15 - ККТ В ОБЩ. ПИТАНИИ
							16 - ККТ В ОПТ. ТОРГОВЛЕ С ОРГ. И ИП
							17 - не используется (0)
							18 - не используется (0)
							19 - не используется (0)
							20 - не используется (0)
							21 - не используется (0)
							22 - не используется (0)
							23 - не используется (0)
							24 - не используется (0)
							25 - не используется (0)
							26 - не используется (0)
							27 - не используется (0)
							28 - не используется (0)
							29 - не используется (0)
							30 - не используется (0)
							31 - не используется (0)
						*/
						End;
					
					If @Update = 1
						Set @Action = 'Отчёт обновлён: (' + isnull(@Action,'') + ') . '
					Else
						Set @Action = 'Отчёт существует. '
				End;
			Else
				-- добавляем только если FD и FPD больше 0
				If @FD > 0 and Cast(@FPD as BigInt) > 0
					begin
						-- добавляем отчет в базу и возвращаем RID записи

						Insert Into RepReg	( DateRep, cashier, addsId, fnID, FPD, FD, Comment, RepTypeID, source, AddDate,   UpdateDate, WorkMode, WorkModeEx, teg1290, RNM, link, RegCheckID, FFD) Values 
											(@DateRep,@cashier,@addsId,@FnId,@FPD,@FD,@Comment,@RegTypeId,@Source, GETDATE(), GETDATE(), @WorkMode,@WorkModeEx,@teg1290,@RNM,@link,@RegCheckID,@FFD)
						Set @Action = 'Отчёт добавлен. '
						Set @RepRegID = (Select top(1) rid from RepReg where fnID = @FnId and fd = @FD order by rid desc) 
					End;
				Else
					begin
						If @FD <= 0 Set @Action = 'ФД не может быть меньше 1. '
						If Cast(@FPD as BigInt) <= 0 Set @Action = 'ФПД не может быть меньше 1. '
						Set @Action = @Action  +  isnull(@ActionFN,'')
						Return 1
					End
		End
	Set @Action = @Action  +  isnull(@ActionFN,'')
End

GO


GRANT EXECUTE
    ON OBJECT::[dbo].[AddRepReg] TO [cash]
    AS [dbo];
GO

