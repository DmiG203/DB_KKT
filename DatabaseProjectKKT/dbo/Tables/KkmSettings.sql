CREATE TABLE [dbo].[KkmSettings] (
    [RID]             INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (MAX) NULL,
    [TableForSHTRIH]  NVARCHAR (MAX) NULL,
    [Value]           NVARCHAR (MAX) NULL,
    [RegParam]        BIT            NOT NULL,
    [ParametrNumAtol] INT            NULL,
    [OrgID]           INT            NULL,
    [CompID]          INT            NULL,
    [KkmModelID]      INT            NULL,
    [FnModelID]       INT            NULL,
    [KkmFFD]          INT            NULL,
    [KkmID]           INT            NULL,
    [WorkMode]        INT            NULL,
    [Priority]        INT            NULL,
    CONSTRAINT [PK_SettingKKM] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_kkmSettings_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_kkmSettings_fnModel] FOREIGN KEY ([FnModelID]) REFERENCES [dbo].[FnModel] ([RID]),
    CONSTRAINT [FK_kkmSettings_kkm] FOREIGN KEY ([KkmID]) REFERENCES [dbo].[Kkm] ([RID]),
    CONSTRAINT [FK_kkmSettings_kkmModel] FOREIGN KEY ([KkmModelID]) REFERENCES [dbo].[KkmModel] ([RID]),
    CONSTRAINT [FK_kkmSettings_Org] FOREIGN KEY ([OrgID]) REFERENCES [dbo].[Org] ([RID])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Адрес таблицы так, как он выгружается тестом драйвера', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KkmSettings', @level2type = N'COLUMN', @level2name = N'TableForSHTRIH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description_tst', @value = N'0 - настрока не требует перерегистрации, 1- настройка требует перерегистрации. ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KkmSettings', @level2type = N'COLUMN', @level2name = N'RegParam';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description_tst', @value = N'Адрес таблицы так, как он выгружается тестом драйвера', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KkmSettings', @level2type = N'COLUMN', @level2name = N'TableForSHTRIH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - настрока не требует перерегистрации, 1- настройка требует перерегистрации. ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'KkmSettings', @level2type = N'COLUMN', @level2name = N'RegParam';


GO

