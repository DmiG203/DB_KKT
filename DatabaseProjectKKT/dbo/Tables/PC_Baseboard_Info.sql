CREATE TABLE [dbo].[PC_Baseboard_Info] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [PC_ID]         INT            NOT NULL,
    [Manufacturer]  NVARCHAR (MAX) NULL,
    [Product]       NVARCHAR (MAX) NULL,
    [Serial_number] NVARCHAR (50)  NULL,
    [Version]       NVARCHAR (50)  NULL,
    [Add_date]      SMALLDATETIME  NOT NULL,
    [Update_date]   SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_PC_Baseboard_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PC_Baseboard_Info_PC_Info] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID])
);


GO

