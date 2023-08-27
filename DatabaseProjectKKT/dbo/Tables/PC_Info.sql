CREATE TABLE [dbo].[PC_Info] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [CompID]      INT           NOT NULL,
    [IP]          NVARCHAR (50) NOT NULL,
    [MAC]         NVARCHAR (50) NOT NULL,
    [OrgID]       INT           NOT NULL,
    [StatusID]    INT           NULL,
    [Add_date]    SMALLDATETIME NOT NULL,
    [Update_date] SMALLDATETIME NOT NULL,
    CONSTRAINT [PK_PC_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PC_Info_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_PC_Info_Statuses] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[Statuses] ([ID])
);


GO

