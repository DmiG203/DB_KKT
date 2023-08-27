-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetSuccessOfTheChanges] (
	 @IsSuccess					bit OUTPUT 
	,@Success					nvarchar(50)
	,@PC_ID						int				
	,@Config_ID					int
	)
AS
BEGIN
	IF @PC_ID IS NOT NULL 
	AND @Config_ID IS NOT NULL 
	AND @Success IS NOT NULL
		BEGIN
			UPDATE Premiera_Config SET Confirmation_of_changes = @Success, Is_need_of_change = 0, Update_date = GETDATE() 
				WHERE CompID = @PC_ID AND ID = @Config_ID
			SET @IsSuccess = 1
		END;
	ELSE
		BEGIN
			SET @IsSuccess = 0
		END;
END

GO

