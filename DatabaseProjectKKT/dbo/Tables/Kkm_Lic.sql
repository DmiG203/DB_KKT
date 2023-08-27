CREATE TABLE [dbo].[Kkm_Lic] (
    [RID]        INT         IDENTITY (1, 1) NOT NULL,
    [KktID]      INT         NOT NULL,
    [LicHEX]     NCHAR (128) NOT NULL,
    [SyngHEX]    NCHAR (128) NOT NULL,
    [Lic_typeID] INT         NOT NULL,
    [AddDate]    DATETIME    NOT NULL,
    [UpdateDate] DATETIME    NOT NULL,
    CONSTRAINT [PK_kkm_lic] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_kkm_lic_kkm] FOREIGN KEY ([KktID]) REFERENCES [dbo].[Kkm] ([RID]),
    CONSTRAINT [FK_kkm_lic_kkm_lic_type] FOREIGN KEY ([Lic_typeID]) REFERENCES [dbo].[Kkm_Lic_Type] ([RID]),
    CONSTRAINT [IX_kkm_lic_1] UNIQUE NONCLUSTERED ([KktID] ASC, [LicHEX] ASC)
);


GO

