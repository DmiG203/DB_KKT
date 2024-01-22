CREATE TABLE [dbo].[PC_Manufacturer_Info] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [PC_ID]        INT           NOT NULL,
    [Manufacturer] NVARCHAR (50) NULL,
    [Model]        NVARCHAR (50) NULL,
    [Bios_SN]      NVARCHAR (50) NULL,
    [Add_date]     SMALLDATETIME NOT NULL,
    [Update_Date]  SMALLDATETIME NOT NULL
);
GO

ALTER TABLE [dbo].[PC_Manufacturer_Info]
    ADD CONSTRAINT [PK_PC_Manufacturer_Info] PRIMARY KEY CLUSTERED ([ID] ASC);
GO

ALTER TABLE [dbo].[PC_Manufacturer_Info]
    ADD CONSTRAINT [FK_PC_Manufacturer_Info_PC_Info] FOREIGN KEY ([PC_ID]) REFERENCES [dbo].[PC_Info] ([ID]);
GO

