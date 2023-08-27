CREATE TABLE [dbo].[Cinema_External_Run_Logs] (
    [ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [CompID]             INT            NOT NULL,
    [Version]            NVARCHAR (50)  NULL,
    [Folder_Name]        NVARCHAR (50)  NULL,
    [Date_Created]       SMALLDATETIME  NULL,
    [Date_Last_Modified] SMALLDATETIME  NULL,
    [Query_Name]         NVARCHAR (50)  NULL,
    [Normal_Count]       INT            NULL,
    [CEE_Count]          INT            NULL,
    [TimeOut_Count]      INT            NULL,
    [MinTime]            DECIMAL (8, 3) NULL,
    [MaxTime]            DECIMAL (8, 3) NULL,
    [AvgTime]            DECIMAL (8, 3) NULL,
    [Add_Date]           SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_Cinema_External_Run_Logs] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Cinema_External_Run_Logs_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID])
);


GO

