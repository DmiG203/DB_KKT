CREATE TABLE [dbo].[BT_Status] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [TerminalID]  INT            NOT NULL,
    [Status]      NVARCHAR (MAX) NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [Comment]     NVARCHAR (MAX) NULL,
    [Add_date]    SMALLDATETIME  NOT NULL,
    [Update_date] SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_BT_Status] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_BT_Status_BT_Software_Info] FOREIGN KEY ([TerminalID]) REFERENCES [dbo].[BT_Software_Info] ([ID])
);


GO

