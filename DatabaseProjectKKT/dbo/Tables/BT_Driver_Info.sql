CREATE TABLE [dbo].[BT_Driver_Info] (
    [ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [CompID]             INT            NOT NULL,
    [Terminal_ID]        INT            NULL,
    [Description]        NVARCHAR (50)  NULL,
    [DeviceName]         NVARCHAR (50)  NULL,
    [DriverDate]         DATE           NULL,
    [DriverProviderName] NVARCHAR (MAX) NULL,
    [DriverVersion]      NVARCHAR (50)  NOT NULL,
    [FriendlyName]       NVARCHAR (50)  NULL,
    [Add_Date]           SMALLDATETIME  NOT NULL,
    [Update_Date]        SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_BT_Driver_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_BT_Driver_Info_BT_Software_Info] FOREIGN KEY ([Terminal_ID]) REFERENCES [dbo].[BT_Software_Info] ([ID])
);


GO

