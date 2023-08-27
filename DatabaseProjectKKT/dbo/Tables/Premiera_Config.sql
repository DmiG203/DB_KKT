CREATE TABLE [dbo].[Premiera_Config] (
    [ID]                          INT            IDENTITY (1, 1) NOT NULL,
    [CompID]                      INT            NOT NULL,
    [Path]                        NVARCHAR (MAX) NULL,
    [Unit_ID]                     INT            NULL,
    [DisplayMode]                 INT            NULL,
    [IO_DLL]                      NVARCHAR (50)  NULL,
    [POS_log_level]               INT            NULL,
    [Logging_type]                INT            NULL,
    [Logging_files_count]         INT            NULL,
    [Logging_max_file_size]       INT            NULL,
    [Confirmation_of_changes]     NVARCHAR (50)  NULL,
    [Is_need_of_change]           BIT            NULL,
    [Is_need_of_delete_dsi_files] BIT            NULL,
    [Add_date]                    SMALLDATETIME  NOT NULL,
    [Update_date]                 SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_Premiera_Config] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Premiera_Config_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_Premiera_Config_Premiera_Logging_Types] FOREIGN KEY ([Logging_type]) REFERENCES [dbo].[Premiera_Logging_Types] ([Type])
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[Update_Trigger] ON [dbo].[Premiera_Config]
AFTER UPDATE 
AS
BEGIN
--SET NOCOUNT ON;
	DECLARE @CurValue		nvarchar(50)
	DECLARE @IsNeedOfChange bit
	DECLARE @LogType		int
	DECLARE @MinValue		int
	DECLARE @MaxValue		int

	
	--если обновлен флаг необходимости изменений в локале на 1, то меняем Confirmation_of_changes и Update_date
	IF UPDATE(Is_need_of_change) AND NOT UPDATE(Unit_ID) 
		BEGIN
			SET @IsNeedOfChange = (SELECT Is_need_of_change FROM Premiera_Config WHERE ID = (SELECT ID FROM inserted))
			IF @IsNeedOfChange = 1
				BEGIN
					UPDATE Premiera_Config SET Confirmation_of_changes = 'Awaiting', Update_date = GETDATE() WHERE ID = (SELECT ID FROM inserted)
				END;
			--если обновлен флаг необходимости изменений в локале на <> 1 без изменения статуса Confirmation_of_changes, то меняем Confirmation_of_changes и Update_date
			ELSE IF @IsNeedOfChange <> 1 AND NOT UPDATE(Confirmation_of_changes) AND NOT UPDATE(Unit_ID)
				BEGIN
					UPDATE Premiera_Config SET Confirmation_of_changes = 'Cancel', Update_date = GETDATE() WHERE ID = (SELECT ID FROM inserted)
				END;
		END;
	--если обновлен какой-то параметр из логирования, меняем флаг Is_need_of_change, статус Confirmation_of_changes и Update_date
	ELSE IF (UPDATE(POS_log_level) OR UPDATE(Logging_type) OR UPDATE(Logging_files_count) OR UPDATE(Logging_max_file_size) OR UPDATE(DisplayMode)) AND NOT UPDATE(Unit_ID) 
		BEGIN
			--если обновлен Logging_type, проверяем, что значение в допустимом диапазоне, иначе указываем ближайшее доступное
			IF UPDATE(Logging_type) AND NOT UPDATE(Unit_ID)
				BEGIN
					SET @LogType = (SELECT Logging_type FROM Premiera_Config WHERE ID = (SELECT ID FROM inserted))
					SET @MinValue = (SELECT MIN(Type) FROM Premiera_Logging_Types)
					SET @MaxValue = (SELECT MAX(Type) FROM Premiera_Logging_Types)

					IF @LogType < @MinValue
						BEGIN
							UPDATE Premiera_Config SET Logging_type = @MinValue WHERE ID = (SELECT ID FROM inserted)
						END;
					IF @LogType > @MaxValue
						BEGIN
							UPDATE Premiera_Config SET Logging_type = @MaxValue WHERE ID = (SELECT ID FROM inserted)
						END;
				END;
			UPDATE Premiera_Config SET Is_need_of_change = 1, Confirmation_of_changes = 'Awaiting', Update_date = GETDATE() WHERE ID = (SELECT ID FROM inserted)
		END;

END;

GO

