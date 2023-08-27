CREATE TABLE [dbo].[Xml_Files] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [CompID]      INT            NOT NULL,
    [FileName]    NVARCHAR (MAX) NOT NULL,
    [Path]        NVARCHAR (MAX) NOT NULL,
    [Xml]         XML            NOT NULL,
    [Add_date]    SMALLDATETIME  NOT NULL,
    [Update_date] SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_Cinema_Xml] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Xml_Files_Computers] FOREIGN KEY ([CompID]) REFERENCES [dbo].[Computers] ([RID])
);


GO

