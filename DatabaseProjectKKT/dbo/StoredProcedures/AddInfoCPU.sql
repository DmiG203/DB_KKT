-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddInfoCPU]
(
	   @CPU_ID		int output	--ответ процедуры
	  ,@CPU_Name	int output	
	  )
AS
BEGIN
	SET @CPU_ID = (SELECT ID FROM Info_CPU WHERE Name = @CPU_Name);
	IF @CPU_ID IS NULL
		BEGIN
			INSERT INTO Info_CPU (Name) VALUES (@CPU_Name)
			SET @CPU_ID = (SELECT ID FROM Info_CPU WHERE Name = @CPU_Name);
		END;
END

GO

