
CREATE procedure [dbo].[AddLogEvent] (
	   @Action nvarchar(max) output
	  ,@Event nvarchar(max)
	  ,@CompName nvarchar(max)
	  ,@kkmSN nvarchar(max) = null
	  ,@kkmModel nvarchar(max) = null
	  ,@Source nvarchar(max)
	  )
AS
Begin
	DECLARE	 @CompID int
			,@kkmID int
			,@ModelID int
			,@SourceID bigint
			,@EventID bigint
	
	--получаем CompID
	EXEC	[dbo].[GetCompID]
			 @CompID = @CompID OUTPUT
			,@Source = @Source
			,@CompName = @CompName
			,@Action = @Action OUTPUT

	--Set @Action = isnull(@Action,'') + @CompID
	--получаем @ModelID
	Set @ModelID = (Select rid from kkmModel where Name = @kkmModel)

	If @kkmSN is not null and @ModelID is not null
		begin
			Set @kkmID = (select rid from kkm where kkm.sn = @kkmSN and kkm.modelID = @ModelID)
			Set @Event = REPLACE(@Event, @kkmModel + ' №' + @kkmSN + ': ', '')
		end

	If @kkmID is not null								-- убираем серийник ККМ из сообщения лога, если получили её ID
		Set @Event = REPLACE(@Event, @kkmSN, '')

	-- Получаем ID текста
	-- для @SourceID
	EXEC	[dbo].[GetTextId]
			@text = @Source,
			@textID = @SourceID OUTPUT

	-- для @EventID
	EXEC	[dbo].[GetTextId]
			@text = @Event,
			@textID = @EventID OUTPUT

	insert into logs (compID,addDateTime,kkmID,SourceID, eventID) VALUES (@CompID,Getdate(),@kkmID,@SourceID, @EventID)
	Set @Action = isnull(@Action,'') + 'Записано '		
End;

GO


GRANT EXECUTE
    ON OBJECT::[dbo].[AddLogEvent] TO [cash]
    AS [dbo];
GO

