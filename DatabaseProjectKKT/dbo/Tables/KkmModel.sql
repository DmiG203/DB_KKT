CREATE TABLE [dbo].[KkmModel] (
    [RID]     INT            IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (100) NULL,
    [AddDate] DATETIME       NULL,
    CONSTRAINT [PK_Model] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [IX_Name_kkmModel] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

