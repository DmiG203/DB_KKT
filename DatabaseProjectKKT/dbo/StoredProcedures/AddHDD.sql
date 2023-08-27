-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[AddHDD] (
	 @ReturnID			int				OUTPUT 
	,@PC_ID				int				
	,@HDD				nvarchar(50)	= null
	,@HDD_Size			int				= null
	,@HDD_FreeSize		int				= null
	,@HDD_SerialNumber  nvarchar(50)	= null
	,@HDD_Caption		nvarchar(50)	= null
	,@HDD_Status		nvarchar(50)	= null
	,@HDD_DeviceID		nvarchar(50)	= null
	)
AS
BEGIN
	--Переменные
	Declare  @HDD_ID int
	IF @HDD IS NULL
		BEGIN
			SET @ReturnID = 0
			RETURN 0
		END;
	--Переопределяем @PC_ID, т.к. на входе приходит CompID, а нужен ID записи. Лень переписывать, должно работать.
	SET @PC_ID = (SELECT TOP 1 ID FROM PC_Info WHERE CompID = @PC_ID ORDER BY ID DESC)
	--проверяем наличие HDD
	SET @HDD_ID = (SELECT TOP 1 ID FROM PC_Hdd_Info WHERE PC_ID = @PC_ID AND HDD = @HDD AND  Device_ID = @HDD_DeviceID ORDER BY ID DESC)
	--если записи нет
	IF @HDD_ID IS NULL
		BEGIN
			--добавляем запись и получаем ее ID
			INSERT INTO PC_Hdd_Info (PC_ID, HDD, Size, FreeSpace, Serial_number, Caption, Status, Device_ID, Add_date, Update_date)
				VALUES(@PC_ID, @HDD, @HDD_Size, @HDD_FreeSize, @HDD_SerialNumber, @HDD_Caption, @HDD_Status, @HDD_DeviceID, GETDATE(), GETDATE())
			SET @HDD_ID = (SELECT ID FROM PC_Hdd_Info WHERE PC_ID = @PC_ID AND HDD = @HDD AND Serial_number = @HDD_SerialNumber AND Device_ID = @HDD_DeviceID)
			Set @ReturnID = @HDD_ID
		END;
	--если запись есть
	ELSE
		BEGIN
			--проверяем актуальность информации
			IF EXISTS ( SELECT TOP 1 HDD, Size, Serial_number, Caption, Device_ID
						FROM PC_Hdd_Info
						WHERE PC_ID = @PC_ID AND HDD = @HDD AND Serial_number = @HDD_SerialNumber AND Device_ID = @HDD_DeviceID
						ORDER BY ID DESC
						EXCEPT
						SELECT @HDD, @HDD_Size, @HDD_SerialNumber, @HDD_Caption, @HDD_DeviceID)
				BEGIN
					INSERT INTO PC_Hdd_Info (PC_ID, HDD, Size, FreeSpace, Serial_number, Caption, Status, Device_ID, Add_date, Update_date)
						VALUES(@PC_ID, @HDD, @HDD_Size, @HDD_FreeSize, @HDD_SerialNumber, @HDD_Caption, @HDD_Status, @HDD_DeviceID, GETDATE(), GETDATE())
				END;
			ELSE
				BEGIN
					UPDATE PC_Hdd_Info SET Status = @HDD_Status, Update_date = GETDATE() WHERE ID = @HDD_ID AND PC_ID = @PC_ID AND HDD = @HDD AND Serial_number = @HDD_SerialNumber AND Device_ID = @HDD_DeviceID
				END;
			Set @ReturnID = @HDD_ID
		END;
END;

GO

