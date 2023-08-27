CREATE TABLE [dbo].[BT_Detect] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [CompID]      INT           NOT NULL,
    [TerminalID]  INT           NULL,
    [Detected]    BIT           NULL,
    [Add_date]    SMALLDATETIME NOT NULL,
    [Update_date] SMALLDATETIME NOT NULL,
    CONSTRAINT [PK_BT_Detect] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_BT_Detect_BT_Software_Info] FOREIGN KEY ([TerminalID]) REFERENCES [dbo].[BT_Software_Info] ([ID])
);


GO

