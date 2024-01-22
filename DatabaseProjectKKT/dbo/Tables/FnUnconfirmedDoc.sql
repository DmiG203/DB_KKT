CREATE TABLE [dbo].[FnUnconfirmedDoc] (
    [RID]            INT      NOT NULL,
    [FnID]           INT      NOT NULL,
    [UnconfirmedDoc] INT      NOT NULL,
    [LastDocNum]     INT      NOT NULL,
    [LastDocDate]    DATETIME NOT NULL,
    [UpdateDate]     DATETIME NOT NULL,
    [AddDate]        DATETIME NOT NULL,
    PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_FnUnconfirmedDoc_Fn] FOREIGN KEY ([FnID]) REFERENCES [dbo].[Fn] ([RID])
);
GO

ALTER TABLE [dbo].[FnUnconfirmedDoc]
    ADD CONSTRAINT [FK_FnUnconfirmedDoc_Fn] FOREIGN KEY ([FnID]) REFERENCES [dbo].[Fn] ([RID]);
GO

