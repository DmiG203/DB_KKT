CREATE TABLE [dbo].[Comments] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    [TableID]    INT            NOT NULL,
    [ItemID]     INT            NOT NULL,
    [Comment]    NVARCHAR (MAX) NOT NULL,
    [AddDate]    DATETIME       NOT NULL,
    [UpdateDate] DATETIME       NOT NULL
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - Kkm
2 - Fn
3 - RepReg
4 - PC_Info
5 - BT', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Comments', @level2type = N'COLUMN', @level2name = N'TableID';
GO

ALTER TABLE [dbo].[Comments]
    ADD CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED ([RID] ASC);
GO

