CREATE TABLE [dbo].[Commands] (
    [RID]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (MAX) NULL,
    [Command]      NVARCHAR (MAX) NOT NULL,
    [WindowStyle]  INT            NOT NULL,
    [WaitOnReturn] INT            NOT NULL,
    [OrgID]        INT            NULL,
    [CompID]       INT            NULL,
    [RunOnce]      BIT            NOT NULL,
    [Deleted]      BIT            NOT NULL,
    [AddDate]      DATETIME       NOT NULL,
    CONSTRAINT [PK_Commands] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_commands_Computers] FOREIGN KEY ([OrgID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_commands_Org] FOREIGN KEY ([OrgID]) REFERENCES [dbo].[Org] ([RID])
);


GO

