
CREATE procedure [dbo].[old_ChangeKKM] (
       @SnKkm1 nvarchar(MAX)
	  ,@ModelKkm1 nvarchar(MAX)
      ,@SnKkm2 nvarchar(MAX)
	  ,@ModelKkm2 nvarchar(MAX)
	  ,@Action nvarchar(MAX) = null output
	  )

AS
Begin
	Declare  @ModelID1 int
			,@KkmID1  int
			,@ModelID2 int
			,@KkmID2 int

			,@WorkMode1 int
			,@WorkMode2 int


	Set @ModelID1 = (select rid from kkmModel where Name = @ModelKkm1)
	Set @ModelID2 = (select rid from kkmModel where Name = @ModelKkm2)
	
	If @ModelID1 is null 
		BEGIN
			Set @Action = 'Модель ' + @ModelKkm1 + ' не найдена в БД. Проверьте правильность написания';
			RETURN 1;
		END;

	If @ModelID2 is null 
		BEGIN
			Set @Action = 'Модель ' + @ModelKkm2 + ' не найдена в БД. Проверьте правильность написания';
			RETURN 1;
		END;
	
	-- Получаем @KkmID. Если в этот момент не определён @ModelKkmID, KkmID мы так же не получем и запишем null
	Set @KkmID1 =  (Select rid from KKM where sn =  @SnKkm1 and kkm.modelID = @ModelID1);
	Set @KkmID2 =  (Select rid from KKM where sn =  @SnKkm2 and kkm.modelID = @ModelID2);

	If @KkmID1 is null 
		BEGIN
			Set @Action = 'ККМ  ' + @SnKkm1 + ' не найдена в БД. Проверьте правильность написания';
			RETURN 1;
		END;

	If @KkmID2 is null 
		BEGIN
			Set @Action = 'ККМ ' + @SnKkm2 + ' не найдена в БД. Проверьте правильность написания';
			RETURN 1;
		END;

	-- Если ККМ определены, меняем местами WorkMode
	if @KkmID1 is not null and @KkmID2 is not null
		begin
			Set @WorkMode1 = (select workmode from kkm where rid = @KkmID1)
			Set @WorkMode2 = (select workmode from kkm where rid = @KkmID2)
			update kkm set workmode = @WorkMode2 where rid = @KkmID1
			update kkm set workmode = @WorkMode1 where rid = @KkmID2
			Set @Action = 'Все получилося'
		end;

	select * from kkm where rid in (@KkmID1, @KkmID2)
End;

GO

