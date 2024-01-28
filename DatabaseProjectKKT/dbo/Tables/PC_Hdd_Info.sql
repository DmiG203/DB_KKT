CREATE TABLE [dbo].[PC_Hdd_Info] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [PC_ID]         INT            NOT NULL,
    [HDD]           NVARCHAR (50)  NULL,
    [Size]          INT            NULL,
    [FreeSpace]     INT            NULL,
    [Serial_number] NVARCHAR (50)  NULL,
    [Caption]       NVARCHAR (MAX) NULL,
    [Status]        NVARCHAR (50)  NULL,
    [Device_ID]     NVARCHAR (50)  NULL,
    [Add_date]      SMALLDATETIME  NOT NULL,
    [Update_date]   SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_PC_Hdd_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PC_Hdd_Info_PC_Info1] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID])
);


GO


