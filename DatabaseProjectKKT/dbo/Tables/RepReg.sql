CREATE TABLE [dbo].[RepReg] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    [DateRep]    DATETIME       NOT NULL,
    [Cashier]    NVARCHAR (MAX) NULL,
    [FD]         INT            NULL,
    [WorkMode]   INT            NULL,
    [WorkModeEx] INT            NULL,
    [teg1290]    INT            NULL,
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
    [RegCheckID] INT            NULL,
    CONSTRAINT [PK_ProductId] PRIMARY KEY CLUSTERED ([RID] ASC)
);


GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - не используется (0)
1 - ПРИНТЕР В АВТОМАТЕ
2 - АС БСО
3 - не используется (0)
4 - не используется (0)
5 - ККТ ДЛЯ ИНТЕРНЕТ
6 - ПОДАКЦИЗНЫЕ ТОВАРЫ
7 - не используется (0)
8 - ТМТ
9 - ККТ ДЛЯ УСЛУГ
10 - ПРОВЕДЕНИЕ АЗАРТНОЙ ИГРЫ
11 - ПРОВЕДЕНИЕ ЛОТЕРЕИ
12 - ЛОМБАРД
13 - СТРАХОВАНИЕ
14 - ККТ С ТОРГ. АВТОМАТОМ
15 - ККТ В ОБЩ. ПИТАНИИ
16 - ККТ В ОПТ. ТОРГОВЛЕ С ОРГ. И ИП
17 - не используется (0)
18 - не используется (0)
19 - не используется (0)
20 - не используется (0)
21 - не используется (0)
22 - не используется (0)
23 - не используется (0)
24 - не используется (0)
25 - не используется (0)
26 - не используется (0)
27 - не используется (0)
28 - не используется (0)
29 - не используется (0)
30 - не используется (0)
31 - не используется (0)
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RepReg', @level2type = N'COLUMN', @level2name = N'teg1290';
GO

