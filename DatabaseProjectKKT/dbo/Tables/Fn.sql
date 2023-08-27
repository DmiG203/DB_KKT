CREATE TABLE [dbo].[Fn] (
    [RID]            INT            IDENTITY (1, 1) NOT NULL,
    [SN]             NVARCHAR (16)  NOT NULL,
    [ModelID]        INT            NOT NULL,
    [KktID]          INT            NULL,
    [UpdateDate]     DATETIME       NOT NULL,
    [AddDate]        DATETIME       NOT NULL,
    [Source]         NVARCHAR (MAX) NOT NULL,
    [Status]         INT            NOT NULL,
    [DateExpired]    DATE           NULL,
    [FreeReg]        INT            NULL,
    [Comment]        NVARCHAR (MAX) NULL,
    [LastDocNum]     INT            NULL,
    [LastDocDate]    DATETIME       NULL,
    [UnconfirmedDoc] INT            NULL,
    CONSTRAINT [PK_fn] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_fn_fnModel] FOREIGN KEY ([ModelID]) REFERENCES [dbo].[FnModel] ([RID]),
    CONSTRAINT [FK_fn_kkm] FOREIGN KEY ([KktID]) REFERENCES [dbo].[Kkm] ([RID]),
    CONSTRAINT [IX_fn] UNIQUE NONCLUSTERED ([SN] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - новая
1 - в работе
2 - архив закрыт
3 - сломан
4 - выведен из реестра ФН', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Fn', @level2type = N'COLUMN', @level2name = N'Status';


GO

