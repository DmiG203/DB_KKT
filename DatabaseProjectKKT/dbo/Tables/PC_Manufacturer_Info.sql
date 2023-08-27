CREATE TABLE [dbo].[PC_Manufacturer_Info] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [PC_ID]        INT           NOT NULL,
    [Manufacturer] VARCHAR (50)  NULL,
    [Model]        VARCHAR (50)  NULL,
    [Add_date]     SMALLDATETIME NOT NULL,
    [Update_Date]  SMALLDATETIME NOT NULL,
    CONSTRAINT [PK_PC_Manufacturer_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_PC_Manufacturer_Info_PC_Info] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID])
);


GO

