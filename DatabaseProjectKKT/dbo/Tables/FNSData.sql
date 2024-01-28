CREATE TABLE [dbo].[FNSData] (
    [RID]         INT            IDENTITY (1, 1) NOT NULL,
    [DateReg]     DATETIME       NULL,
    [AddsID]      INT            NOT NULL,
    [RNM]         CHAR (16)      NULL,
    [KkmID]       INT            NOT NULL,
    [DateExpired] DATE           NULL,
    [Status]      NVARCHAR (MAX) NOT NULL,
    [OfdOrgID]    INT            NULL,
    [FnID]        INT            NULL,
    [OpID]        INT            NOT NULL,
    [PlaceName]   NVARCHAR (MAX) NULL,
    [RegMode]     INT            NULL,
    [AddDate]     DATETIME       NOT NULL,
    [UpdateDate]  DATETIME       NOT NULL,
    [CodeNo]      CHAR (4)       NULL
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

ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Org] FOREIGN KEY ([OfdOrgID]) REFERENCES [dbo].[Org] ([RID]);
GO

ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Fn] FOREIGN KEY ([FnID]) REFERENCES [dbo].[Fn] ([RID]);
GO

ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Adds] FOREIGN KEY ([AddsID]) REFERENCES [dbo].[Adds] ([RID]);
GO

ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Org1] FOREIGN KEY ([OpID]) REFERENCES [dbo].[Org] ([RID]);
GO

ALTER TABLE [dbo].[FNSData]
    ADD CONSTRAINT [FK_FNSData_Kkm] FOREIGN KEY ([KkmID]) REFERENCES [dbo].[Kkm] ([RID]);
GO

