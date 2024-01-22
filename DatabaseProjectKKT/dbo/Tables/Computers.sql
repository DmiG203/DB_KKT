CREATE TABLE [dbo].[Computers] (
    [RID]          INT            IDENTITY (1, 1) NOT NULL,
    [ComputerName] NVARCHAR (MAX) NOT NULL,
    [ComputerType] INT            NOT NULL,
    [OrgID]        INT            NULL,
    [SourceID]     BIGINT         NOT NULL,
    [ShtrihDrvVer] NVARCHAR (MAX) NULL,
    [AtolDrvVer]   NVARCHAR (MAX) NULL,
    [LastStart]    DATETIME       NULL,
    [AddDate]      DATETIME       NOT NULL,
    [UpdateDate]   DATETIME       NOT NULL
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - виртуальный/неизвестный
1 - сервер
2 - барная касса
3 - оф станция
4 - киоск
5 - рабочая станция
6 - билетная касса
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Computers', @level2type = N'COLUMN', @level2name = N'ComputerType';
GO

ALTER TABLE [dbo].[Computers]
    ADD CONSTRAINT [FK_Computers_TextTable] FOREIGN KEY ([SourceID]) REFERENCES [dbo].[TextTable] ([RID]);
GO

ALTER TABLE [dbo].[Computers]
    ADD CONSTRAINT [FK_Computers_Org] FOREIGN KEY ([OrgID]) REFERENCES [dbo].[Org] ([RID]);
GO

ALTER TABLE [dbo].[Computers]
    ADD CONSTRAINT [PK_Computers] PRIMARY KEY CLUSTERED ([RID] ASC);
GO

ALTER TABLE [dbo].[Computers]
    ADD CONSTRAINT [DF_Computers_ComputerType] DEFAULT ((0)) FOR [ComputerType];
GO

