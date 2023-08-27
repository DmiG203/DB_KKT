CREATE TABLE [dbo].[Kkm] (
    [RID]           INT            IDENTITY (1, 1) NOT NULL,
    [SN]            NVARCHAR (30)  NOT NULL,
    [ModelID]       INT            NOT NULL,
    [WorkMode]      INT            NULL,
    [SoftVer]       NVARCHAR (MAX) NULL,
    [UpdateDate]    DATETIME       NOT NULL,
    [AddDate]       DATETIME       NOT NULL,
    [Source]        NVARCHAR (MAX) NOT NULL,
    [Deleted]       BIT            NULL,
    [MAC]           CHAR (12)      NULL,
    [RNDIS]         BIT            NOT NULL,
    [IpAddress]     NCHAR (15)     NULL,
    [IpPort]        INT            NULL,
    [LoaderVersion] INT            NULL,
    CONSTRAINT [PK_kkm] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_kkm_kkmModel] FOREIGN KEY ([ModelID]) REFERENCES [dbo].[KkmModel] ([RID]),
    CONSTRAINT [IX_kkm] UNIQUE NONCLUSTERED ([SN] ASC, [ModelID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Серийный номер ККМ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Kkm', @level2type = N'COLUMN', @level2name = N'SN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ссылка на модель ККМ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Kkm', @level2type = N'COLUMN', @level2name = N'ModelID';


GO

