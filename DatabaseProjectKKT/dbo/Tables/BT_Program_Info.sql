CREATE TABLE [dbo].[BT_Program_Info] (
    [ID]                        INT            IDENTITY (1, 1) NOT NULL,
    [CompID]                    INT            NOT NULL,
    [TerminalID]                INT            NOT NULL,
    [PC_PathFolder]             NVARCHAR (50)  NULL,
    [PC_Model]                  NVARCHAR (50)  NULL,
    [PC_Serial_number]          NVARCHAR (50)  NULL,
    [PC_Software_versions_UPOS] NVARCHAR (50)  NULL,
    [LoadParmEXE]               NVARCHAR (50)  NULL,
    [GateDLL]                   NVARCHAR (50)  NULL,
    [Sb_kernelDLL]              NVARCHAR (50)  NULL,
    [FullTextFromFile]          NVARCHAR (MAX) NULL,
    [Add_date]                  SMALLDATETIME  NOT NULL,
    [Update_date]               SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_BT_Program_Info] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_BT_Program_Info_BT_Software_Info] FOREIGN KEY ([TerminalID]) REFERENCES [dbo].[BT_Software_Info] ([ID])
);


GO

