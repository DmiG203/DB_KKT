CREATE TABLE [dbo].[RegCheck] (
    [RID]       INT            IDENTITY (1, 1) NOT NULL,
    [Link]      NVARCHAR (MAX) NOT NULL,
    [Processed] BIT            NOT NULL
);
GO

ALTER TABLE [dbo].[RegCheck]
    ADD CONSTRAINT [PK_RegCheck] PRIMARY KEY CLUSTERED ([RID] ASC);
GO

ALTER TABLE [dbo].[RegCheck]
    ADD CONSTRAINT [FK_RegCheck_RegCheck] FOREIGN KEY ([RID]) REFERENCES [dbo].[RegCheck] ([RID]);
GO

