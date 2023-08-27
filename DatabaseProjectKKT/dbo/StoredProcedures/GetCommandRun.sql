

CREATE procedure [dbo].[GetCommandRun] (
	   @Action nvarchar(MAX) = null OUTPUT 
	  ,@CompName nvarchar(MAX) = null
	  ,@ComputerName nvarchar(MAX) = null -- оставлено для совместимости
	  ,@Source nvarchar(MAX) = ''
	  )

AS
SET NOCOUNT ON; 
BEGIN

	DECLARE @CompID int						--ID компьютера
	DECLARE @OrgID int						--ID организации
	DECLARE @SourceID bigint
	DECLARE @tempTable table (
		CommandId int, Command nvarchar(MAX), WindowStyle int, WaitOnReturn int 
		)				

	If @ComputerName is not null			-- для совместимости
		Set @CompName = @ComputerName
	
	--обнуляем @Action
	Set @Action = ''

	-- Получаем ID текста
	-- для @SourceID
	EXEC	[dbo].[GetTextId]
			@text = @Source,
			@textID = @SourceID OUTPUT

	-- определяем комп по имени, и ОП из записи о компе.
	If (select count(*) from Computers where ComputerName = @CompName) > 0
		begin
			Set @CompID = (select MAX(rid)  from Computers where ComputerName = @CompName)
			Set @OrgId = (Select OrgID from Computers where rid = @CompID)
		end;
	Else
		--если не находим комп, выходим
		begin
			Set @Action = isnull(@Action, '') + 'Компьютер ' + @CompName + ' не известен. Команды не выданы. '
			RETURN 1
		end;

	Insert Into @tempTable (CommandId, Command, WindowStyle, WaitOnReturn) 
	(select RID, Command, WindowStyle, WaitOnReturn 
	 from Commands
	 where	ISNULL(OrgID, @OrgID)	= @OrgID
	 and		ISNULL(CompID, @CompID)	= @CompID
	 and		deleted = 0
	)
	
	Select Command, WindowStyle, WaitOnReturn  from @tempTable
	Set @Action = ISNULL(@Action, '') + ' Команды выданы. '

	-- записываем какие, когда и кому команды выданы
	Insert Into CommandsRun (CommandID, CompID, SourceID, AddDate) 
	(Select CommandId, @CompID, @SourceID, GetDATE()  from @tempTable)

End

GO

