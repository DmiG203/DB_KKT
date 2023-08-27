CREATE TABLE [dbo].[Premiera_Logging_Types] (
    [ID]          INT           NOT NULL,
    [Type]        INT           NOT NULL,
    [Description] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Premiera_Logging_Types] PRIMARY KEY CLUSTERED ([ID] ASC),
    UNIQUE NONCLUSTERED ([Type] ASC)
);


GO

