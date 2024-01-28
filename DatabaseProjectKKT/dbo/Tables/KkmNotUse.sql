CREATE TABLE [dbo].[KkmNotUse] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    [KkmId]      INT            NOT NULL,
    [Comment]    NVARCHAR (MAX) NULL,
    [AddDate]    DATE           NOT NULL,
    [StopDate]   DATE           NULL,
    [NotUseType] INT            NOT NULL
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - Не используется
2 - Вывод из эксплуатации
3 - Временная блокировка', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KkmNotUse', @level2type = N'COLUMN', @level2name = N'NotUseType';
GO

ALTER TABLE [dbo].[KkmNotUse]
    ADD CONSTRAINT [PK_KkmNotUse] PRIMARY KEY CLUSTERED ([RID] ASC);
GO

ALTER TABLE [dbo].[KkmNotUse]
    ADD CONSTRAINT [FK_KkmNotUse_Kkm] FOREIGN KEY ([KkmId]) REFERENCES [dbo].[Kkm] ([RID]);
GO

