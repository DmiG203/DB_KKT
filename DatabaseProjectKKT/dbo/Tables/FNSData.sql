CREATE TABLE [dbo].[FNSData] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    [CodeNo]     CHAR (4)       NOT NULL,
    [DateReg]    DATETIME       NOT NULL,
    [Adds]       NVARCHAR (MAX) NOT NULL,
    [RNM]        CHAR (16)      NOT NULL,
    [KkmModelID] INT            NOT NULL,
    [DateBlock]  DATETIME       NOT NULL,
    [Status]     NVARCHAR (MAX) NOT NULL,
    [KkmID]      INT            NOT NULL,
    [OfdID]      INT            NOT NULL,
    [FnID]       INT            NOT NULL,
    [OpOrgID]    INT            NOT NULL,
    [OrgID]      INT            NOT NULL,
    [AddsID]     INT            NOT NULL,
    [AddDate]    DATE           NOT NULL,
    [UpdateDate] DATE           NOT NULL,
    CONSTRAINT [PK_FNSData] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_FNSData_adds] FOREIGN KEY ([AddsID]) REFERENCES [dbo].[Adds] ([RID]),
    CONSTRAINT [FK_FNSData_fn] FOREIGN KEY ([FnID]) REFERENCES [dbo].[Fn] ([RID]),
    CONSTRAINT [FK_FNSData_kkm] FOREIGN KEY ([KkmID]) REFERENCES [dbo].[Kkm] ([RID]),
    CONSTRAINT [FK_FNSData_kkmModel] FOREIGN KEY ([KkmModelID]) REFERENCES [dbo].[KkmModel] ([RID]),
    CONSTRAINT [FK_FNSData_Org] FOREIGN KEY ([OrgID]) REFERENCES [dbo].[Org] ([RID]),
    CONSTRAINT [FK_FNSData_Org1] FOREIGN KEY ([OpOrgID]) REFERENCES [dbo].[Org] ([RID]),
    CONSTRAINT [FK_FNSData_Org2] FOREIGN KEY ([OfdID]) REFERENCES [dbo].[Org] ([RID])
);


GO

