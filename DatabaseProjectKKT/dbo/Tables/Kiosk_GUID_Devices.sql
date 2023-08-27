CREATE TABLE [dbo].[Kiosk_GUID_Devices] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [GUID]        NVARCHAR (MAX) NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [DllName]     NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Kiosk_GUID_Devices] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

