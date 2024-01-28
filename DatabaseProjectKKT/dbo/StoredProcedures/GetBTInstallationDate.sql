-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBTInstallationDate] (
	 @ReturnDate				smalldatetime OUTPUT 
	,@ReturnDays				int OUTPUT
	,@TerminalNumber			nvarchar(50)
	,@SerialNumber				nvarchar(50)
	)
AS
BEGIN
	SET @ReturnDate = ( SELECT MIN(bts.Add_date)
							  FROM BT_Software_Info bts
							  WHERE bts.IsDeleted		= 0
								AND bts.Terminal_number	= @TerminalNumber
								AND bts.Serial_number	= @SerialNumber
							  GROUP BY bts.Terminal_number, bts.Serial_number);

	Set @ReturnDays = DATEDIFF(day, @ReturnDate, GETDATE());

END;
GO

