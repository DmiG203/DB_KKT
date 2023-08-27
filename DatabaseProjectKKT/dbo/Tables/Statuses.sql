CREATE TABLE [dbo].[Statuses] (
    [ID]   INT           IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (50) NULL,
    CONSTRAINT [PK_PC_Statuses] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

