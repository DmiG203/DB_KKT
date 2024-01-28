CREATE TABLE [dbo].[Logs] (
    [RID]         BIGINT   IDENTITY (1, 1) NOT NULL,
    [CompID]      INT      NOT NULL,
    [KkmID]       INT      NULL,
    [AddDateTime] DATETIME NOT NULL,
    [EventID]     BIGINT   NULL,
    [SourceID]    BIGINT   NULL,
    CONSTRAINT [PK_logs] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_logs_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_logs_kkm] FOREIGN KEY ([KkmID]) REFERENCES [dbo].[Kkm] ([RID]),
    CONSTRAINT [FK_logs_textTable_Event] FOREIGN KEY ([EventID]) REFERENCES [dbo].[TextTable] ([RID]),
    CONSTRAINT [FK_logs_textTable_Source] FOREIGN KEY ([SourceID]) REFERENCES [dbo].[TextTable] ([RID])
);


GO


CREATE NONCLUSTERED INDEX [IX_Logs]
    ON [dbo].[Logs]([AddDateTime] ASC);
GO

