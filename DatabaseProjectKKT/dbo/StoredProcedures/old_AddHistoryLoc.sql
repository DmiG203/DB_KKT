-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[old_AddHistoryLoc](
	 @SNKKM nvarchar(MAX)
	,@OP int
	,@Date date
	,@Action nvarchar(MAX) output
	,@LocKkmId int output
	)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
    
	DECLARE @KkmId int;
	DECLARE @SOURCE nvarchar(MAX) = 'ECXEL загрузка архивных данных'
	DECLARE @CompID int; 


	Set @KkmId = (select rid from kkm where sn = @SNKKM)
	If @KkmId is null
		begin 
			Set @Action = 'Не найдена ККМ в БД. Сначала добавьте ККМ'
			Return 1
		End;
	--ищем compID
	Set @CompID = (select top(1) rid from Computers where ComputerName = 'ОП' + cast(@OP as nvarchar))

	--проверяем наличие записи 
	Set @LocKkmId = (select rid from LocKkm where KkmId = @KkmId)
	If @LocKkmId is null 
		begin
			insert into LocKkm (compID,KkmId,addDate,updateDate,source) values (@CompID,@KkmID,@date,GETDATE(),@Source)
		End;
END

GO

