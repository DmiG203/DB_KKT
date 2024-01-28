CREATE TABLE [dbo].[FnDocs] (
    [RID]            BIGINT   IDENTITY (1, 1) NOT NULL,
    [FnID]           INT      NOT NULL,
    [UnconfirmedDoc] INT      NULL,
    [DocNum]         INT      NULL,
    [DocDate]        DATETIME NULL,
    [Type]           INT      NOT NULL,
    [UpdateDate]     DATETIME NOT NULL,
    [AddDate]        DATETIME NOT NULL,
    [SourceID]       BIGINT   NULL
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - номер/дата последнего чека
2 - неоправленные документы', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FnDocs', @level2type = N'COLUMN', @level2name = N'Type';
GO

