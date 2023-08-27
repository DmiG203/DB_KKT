CREATE TABLE [dbo].[Info_CPU] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (MAX) NOT NULL,
    [Cores]       INT           NULL,
    [Threads]     INT           NULL,
    [YearOfIssue] INT           NULL,
    CONSTRAINT [PK_Info_CPU] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

