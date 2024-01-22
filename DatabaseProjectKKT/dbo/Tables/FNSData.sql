CREATE TABLE [dbo].[FNSData] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    ALTER TABLE [dbo].[FNSData]
    ADD [CodeNo] CHAR (4) NULL;,
    ALTER TABLE [dbo].[FNSData]
    ADD [DateReg] DATETIME NULL;,
    [Adds]       NVARCHAR (MAX) NOT NULL,
    ALTER TABLE [dbo].[FNSData]
    ADD [RNM] CHAR (16) NULL;,
    [KkmModelID] INT            NOT NULL,
    [DateBlock]  DATETIME       NOT NULL,
    [Status]     NVARCHAR (MAX) NOT NULL,
    [KkmID]      INT            NOT NULL,
    [OfdID]      INT            NOT NULL,
    ALTER TABLE [dbo].[FNSData]
    ADD [FnID] INT NULL;,
    [OpOrgID]    INT            NOT NULL,
    [OrgID]      INT            NOT NULL,
    [AddsID]     INT            NOT NULL,
    ALTER TABLE [dbo].[FNSData]
    ADD [AddDate] DATETIME NOT NULL;,
    ALTER TABLE [dbo].[FNSData]
    ADD [UpdateDate] DATETIME NOT NULL;,
    CONSTRAINT [PK_FNSData] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_FNSData_adds] FOREIGN KEY ([AddsID]) REFERENCES [dbo].[Adds] ([RID]),
    CONSTRAINT [FK_FNSData_fn] FOREIGN KEY ([FnID]) REFERENCES [dbo].[Fn] ([RID]),
    CONSTRAINT [FK_FNSData_kkm] FOREIGN KEY ([KkmID]) REFERENCES [dbo].[Kkm] ([RID]),
    CONSTRAINT [FK_FNSData_kkmModel] FOREIGN KEY ([KkmModelID]) REFERENCES [dbo].[KkmModel] ([RID]),
    ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Org] FOREIGN KEY ([OfdOrgID]) REFERENCES [dbo].[Org] ([RID]);,
    ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Org1] FOREIGN KEY ([OpID]) REFERENCES [dbo].[Org] ([RID]);,
    CONSTRAINT [FK_FNSData_Org2] FOREIGN KEY ([OfdID]) REFERENCES [dbo].[Org] ([RID])
);


GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 бит:	ККТ правопредшественника (1-да, 0-нет)	
2 бит:	ККТ используется при приеме денежных средств при реализации лотерейных билетов	
3 бит:	ККТ используется при приеме ставок и выплате денежных средств в виде выигрыша	
4 бит:	ККТ используется при осуществлении деятельности банковского платежного агента (субагента)	
5 бит:	ККТ входит в состав автоматического устройства для расчетов	
6 бит:	ККТ используется для расчетов в информационно-телекоммуникационной сети «Интернет»	
7 бит:	ККТ используется для развозной и (или) разносной торговли (оказания услуг, выполнения работ)	
8 бит:	ККТ применяется только при оказании услуг	
9 бит:	ККТ используется при осуществлении деятельности платежного агента (субагента)	
10 бит:	ККТ используется при продаже подакцизных товаров	
11 бит:	ККТ используется при осуществлении расчетов за маркированные товары', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FNSData', @level2type = N'COLUMN', @level2name = N'RegMode';
GO

