
CREATE procedure [dbo].[GetCashSettings] (
	   @Action nvarchar(MAX) = null output 
	  ,@farcards nvarchar(MAX) = null output
	  ,@Plex int = null
	  )
AS
Begin
	Declare	@ModelID int		--ID Модели ККМ

	If @Plex =''	Set @Plex = null

	-- если передан номер кинотеатра, возвращаем настройки кассы
	If @Plex is not null
		Begin
			Set @farcards = (
	
			select TOP(1)Org.farcards
			from Org
			where Org.NumOP = @Plex 
			)
		End
	Else
		Begin 
			Set @Action = 'Пустой запрос'
			return 1 
		End
End

GO

