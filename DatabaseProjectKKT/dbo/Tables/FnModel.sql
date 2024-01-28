CREATE TABLE [dbo].[FnModel] (
    [RID]        INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (MAX) NULL,
    [Mask]       NCHAR (6)      NOT NULL,
    [FFD]        NCHAR (4)      NULL,
    [AddDate]    DATETIME       NULL,
    [UpdateDate] DATETIME       NULL,
    [OKP]        NVARCHAR (MAX) NULL,
    [OKPPort]    INT            NULL,
    CONSTRAINT [PK_fnModel] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [IX_fnModel] UNIQUE NONCLUSTERED ([Mask] ASC)
);


GO

