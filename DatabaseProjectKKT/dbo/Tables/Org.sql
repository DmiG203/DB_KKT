CREATE TABLE [dbo].[Org] (
    [RID]      INT            IDENTITY (1, 1) NOT NULL,
    [OrgID]    INT            NULL,
    [NumOP]    INT            NULL,
    [INN]      CHAR (10)      NULL,
    [KPP]      CHAR (9)       NULL,
    [Name]     NVARCHAR (MAX) NOT NULL,
    [AddsID]   INT            NULL,
    [OrgType]  INT            NULL,
    [FarCards] INT            NULL,
    [FsExist]  BIT            NULL,
    CONSTRAINT [PK_Org] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_Org_adds] FOREIGN KEY ([AddsID]) REFERENCES [dbo].[Adds] ([RID])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 = премьера, 1 = кипер', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Org', @level2type = N'COLUMN', @level2name = N'FarCards';


GO

