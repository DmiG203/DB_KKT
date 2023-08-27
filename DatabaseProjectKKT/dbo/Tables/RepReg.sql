CREATE TABLE [dbo].[RepReg] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    [DateRep]    DATETIME       NOT NULL,
    [Cashier]    NVARCHAR (MAX) NULL,
    [FD]         INT            NULL,
    [WorkMode]   INT            NULL,
    [WorkModeEx] INT            NULL,
    [FnID]       INT            NOT NULL,
    [FPD]        NVARCHAR (MAX) NOT NULL,
    [Comment]    NVARCHAR (MAX) NULL,
    [RepTypeID]  INT            NOT NULL,
    [Source]     NVARCHAR (MAX) NULL,
    [AddDate]    DATETIME       NULL,
    [UpdateDate] DATETIME       NULL,
    [AddsID]     INT            NULL,
    [RNM]        NVARCHAR (16)  NULL,
    [Link]       NVARCHAR (MAX) NULL,
    [FFD]        INT            NULL,
    CONSTRAINT [PK_ProductId] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_RepReg_adds] FOREIGN KEY ([AddsID]) REFERENCES [dbo].[Adds] ([RID]),
    CONSTRAINT [FK_RepReg_fn] FOREIGN KEY ([FnID]) REFERENCES [dbo].[Fn] ([RID]),
    CONSTRAINT [FK_RepReg_RepType] FOREIGN KEY ([RepTypeID]) REFERENCES [dbo].[RepType] ([RID])
);


GO

