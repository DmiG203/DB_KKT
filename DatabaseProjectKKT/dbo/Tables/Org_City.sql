CREATE TABLE [dbo].[Org_City] (
    [RID]  INT           IDENTITY (1, 1) NOT NULL,
    [City] NVARCHAR (50) NOT NULL
);
GO

ALTER TABLE [dbo].[Org_City]
    ADD CONSTRAINT [PK_Org_City] PRIMARY KEY CLUSTERED ([RID] ASC);
GO

ALTER TABLE [dbo].[Org_City]
    ADD CONSTRAINT [FK_Org_City_Org_City] FOREIGN KEY ([RID]) REFERENCES [dbo].[Org_City] ([RID]);
GO

