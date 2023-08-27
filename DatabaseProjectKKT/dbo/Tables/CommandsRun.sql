CREATE TABLE [dbo].[CommandsRun] (
    [RID]       INT      IDENTITY (1, 1) NOT NULL,
    [CommandID] INT      NOT NULL,
    [CompID]    INT      NOT NULL,
    [SourceID]  BIGINT   NOT NULL,
    [AddDate]   DATETIME NOT NULL,
    CONSTRAINT [PK_CommandsRun] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_CommandsRun_Commands] FOREIGN KEY ([CommandID]) REFERENCES [dbo].[Commands] ([RID]),
    CONSTRAINT [FK_CommandsRun_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_CommandsRun_TextTable] FOREIGN KEY ([SourceID]) REFERENCES [dbo].[TextTable] ([RID])
);


GO

