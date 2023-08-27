-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddXmlFile] (
	   @ReturnID	int OUTPUT
	  ,@CompID		int 
	  ,@FileName	nvarchar(MAX)
	  ,@Path		nvarchar(MAX)
	  ,@Xml			xml
)
AS
BEGIN
	DECLARE @XF_ID int;
	--Проверка на наличие значений
	IF (@CompID IS NULL) OR (@FileName IS NULL) OR (@Path IS NULL) OR (@Xml IS NULL)
		BEGIN
			SET @ReturnID = 0;
			RETURN 0;
		END;
	--Получаем ID записи
	SET @XF_ID = (SELECT TOP 1 ID FROM Xml_Files WHERE CompID = @CompID AND FileName = @FileName AND Path = @Path ORDER BY ID DESC);
	--Если запись не найдена
	IF @XF_ID IS NULL
		BEGIN
			--Добавляем запись
			INSERT INTO Xml_Files ( CompID, FileName, Path, Xml, Add_date, Update_date)
						   VALUES ( @CompID, @FileName, @Path, CONVERT(xml,@Xml), GETDATE(), GETDATE());
			--Получаем ID новой записи
			SET @XF_ID = (SELECT TOP 1 ID FROM Xml_Files WHERE CompID = @CompID AND FileName = @FileName AND Path = @Path ORDER BY ID DESC);
		END;
	--Если запись найдена
	ELSE
		--Обновляем Xml и дату
		BEGIN
			UPDATE Xml_Files SET Xml = CONVERT(xml, @Xml), Update_date = GETDATE() WHERE ID = @XF_ID;
		END;

	SET @ReturnID = @XF_ID;
END;

GO

