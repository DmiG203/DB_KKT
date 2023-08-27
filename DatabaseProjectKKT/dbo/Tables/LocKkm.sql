CREATE TABLE [dbo].[LocKkm] (
    [RID]         INT            IDENTITY (1, 1) NOT NULL,
    [KkmID]       INT            NOT NULL,
    [CompID]      INT            NOT NULL,
    [Source]      NVARCHAR (MAX) NOT NULL,
    [AddDate]     DATETIME       NOT NULL,
    [UpdateDate]  DATETIME       NOT NULL,
    [ComPort]     INT            NULL,
    [ComBaudRate] INT            NULL,
    CONSTRAINT [PK_LocKkm] PRIMARY KEY CLUSTERED ([RID] ASC),
    CONSTRAINT [FK_LocKkm_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID]),
    CONSTRAINT [FK_LocKkm_kkm] FOREIGN KEY ([KkmID]) REFERENCES [dbo].[Kkm] ([RID])
);


GO

