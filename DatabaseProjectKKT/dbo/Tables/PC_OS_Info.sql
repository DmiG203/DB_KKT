CREATE TABLE [dbo].[PC_OS_Info] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [PC_ID]         INT            NOT NULL,
    [MAC]           NVARCHAR (50)  NOT NULL,
    [Hostname]      NVARCHAR (50)  NULL,
    [OS]            NVARCHAR (MAX) NULL,
    [Arch]          NVARCHAR (50)  NULL,
    [Version]       NVARCHAR (50)  NULL,
    [Status]        NVARCHAR (50)  NULL,
    [Serial_number] NVARCHAR (50)  NULL,
    [Install_date]  SMALLDATETIME  NULL,
    [lastBootTime]  SMALLDATETIME  NULL,
    [Add_date]      SMALLDATETIME  NOT NULL,
    [Update_date]   SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_PC_OS_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PC_OS_Info_PC_Info] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID])
);


GO

