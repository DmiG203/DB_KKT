CREATE TABLE [dbo].[BT_Software_Info] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [CompID]                  INT           NOT NULL,
    [Terminal_number]         NVARCHAR (50) NULL,
    [Merchant_number]         NVARCHAR (50) NULL,
    [Serial_number]           NVARCHAR (50) NULL,
    [Terminal_model]          NVARCHAR (50) NULL,
    [Contactless]             NVARCHAR (50) NULL,
    [Loading_parameters]      SMALLDATETIME NULL,
    [DateTime_last_operation] SMALLDATETIME NULL,
    [Software_versions_UPOS]  NVARCHAR (50) NULL,
    [StatusID]                INT           NULL,
    [IsDeleted]               BIT           NULL,
    [Add_date]                SMALLDATETIME NOT NULL,
    [Update_date]             SMALLDATETIME NOT NULL,
    CONSTRAINT [PK_BT_Software_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_BT_Software_Info_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_BT_Software_Info_Statuses] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[Statuses] ([ID])
);
GO

