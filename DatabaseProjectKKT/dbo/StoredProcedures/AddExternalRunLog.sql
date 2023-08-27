-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddExternalRunLog] (
	 @AlreadyExists				bit	OUTPUT			
	,@ReturnID					int OUTPUT 
	,@PC_ID						int
	,@Version					nvarchar(50)	=null
	,@FolderName				nvarchar(50)	=null
	,@DateCreated				smalldatetime	=null
	,@DateLastModified			smalldatetime	=null
	,@QueryName 				nvarchar(50)	=null
	,@NormalCount				int				=null
	,@CEECount					int				=null
	,@TimeOutCount				int				=null
	,@MinTime					decimal(8,3)	=null
	,@MaxTime					decimal(8,3)	=null
	,@AvgTime					decimal(8,3)	=null
	)
AS
BEGIN
	DECLARE @LogID int
	DECLARE @SetDateCreated smalldatetime

	IF @PC_ID IS NULL
		BEGIN
			SET @ReturnID = 0
			SET @AlreadyExists = 0
			RETURN 0
		END;

	IF @QueryName LIKE '%Total:%'
		BEGIN
			SET @ReturnID = 0
			SET @AlreadyExists = 0 
			RETURN 0
		END;

	SET @LogID = (SELECT TOP 1 ID FROM Cinema_External_Run_Logs WHERE CompID = @PC_ID AND Folder_Name = @FolderName AND Query_Name = @QueryName ORDER BY ID DESC)
	--Если запись не найдена, то добавляем
	IF @LogID IS NULL
		BEGIN
			INSERT INTO Cinema_External_Run_Logs (CompID, Version, Folder_Name, Date_Created, Date_Last_Modified, Query_Name, Normal_Count, CEE_Count, TimeOut_Count, MinTime, MaxTime, AvgTime, Add_Date)
								VALUES(@PC_ID, @Version, @FolderName, @DateCreated, @DateLastModified, @QueryName, @NormalCount, @CEECount, @TimeOutCount, @MinTime, @MaxTime, @AvgTime, GETDATE())
			SET @LogID = (SELECT TOP 1 ID FROM Cinema_External_Run_Logs WHERE CompID = @PC_ID AND Folder_Name = @FolderName AND Query_Name = @QueryName ORDER BY ID DESC)
			SET @ReturnID = @LogID
			SET @AlreadyExists = 0
		END;
	ELSE
		SET @SetDateCreated = (SELECT Date_Created FROM Cinema_External_Run_Logs WHERE ID = @LogID)
		IF @SetDateCreated IS NULL AND @DateCreated IS NOT NULL
			BEGIN
				UPDATE Cinema_External_Run_Logs SET Date_Created = @DateCreated WHERE ID = @LogID
				SET @ReturnID = @LogID
				SET @AlreadyExists = 0
			END;
		ELSE
			BEGIN
				SET @ReturnID = 0
				SET @AlreadyExists = 1
			END;
END

GO

