CREATE TABLE [dbo].[WinSAT] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [PC_ID]       INT            NOT NULL,
    [Test_name]   NVARCHAR (50)  NULL,
    [Result_xml]  XML            NULL,
    [Error]       NVARCHAR (MAX) NULL,
    [Add_date]    SMALLDATETIME  NOT NULL,
    [Update_date] SMALLDATETIME  NOT NULL
);
GO

ALTER TABLE [dbo].[WinSAT]
    ADD CONSTRAINT [FK_WinSAT_PC_Info] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID]);
GO

ALTER TABLE [dbo].[WinSAT]
    ADD CONSTRAINT [PK_WinSAT] PRIMARY KEY CLUSTERED ([ID] ASC);
GO

