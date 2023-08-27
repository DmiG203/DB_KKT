CREATE TABLE [dbo].[PC_Hardware_Info] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [PC_ID]          INT            NOT NULL,
    [CPU1]           NVARCHAR (MAX) NULL,
    [CPU2]           NVARCHAR (MAX) NULL,
    [RAM]            NVARCHAR (50)  NULL,
    [RAM_total_size] INT            NULL,
    [Add_date]       SMALLDATETIME  NOT NULL,
    [Update_date]    SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_PC_Hardware_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PC_Hardware_Info_PC_Info] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID])
);


GO

