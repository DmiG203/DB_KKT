CREATE TABLE [dbo].[BT_Notes] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [TerminalID]        INT             NOT NULL,
    [CompID]            INT             NULL,
    [Comment]           NVARCHAR (MAX)  NULL,
    [Description]       NVARCHAR (MAX)  NULL,
    [АattachedDocument] VARBINARY (MAX) NULL,
    [Add_date]          SMALLDATETIME   NULL,
    [Update_date]       SMALLDATETIME   NULL,
    CONSTRAINT [PK_BT_Notes] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_BT_Notes_BT_Software_Info] FOREIGN KEY ([TerminalID]) REFERENCES [dbo].[BT_Software_Info] ([ID])
);


GO

