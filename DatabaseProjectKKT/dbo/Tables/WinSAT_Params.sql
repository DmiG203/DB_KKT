CREATE TABLE [dbo].[WinSAT_Params] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Comp_type]    INT           NOT NULL,
    [Param_id]     INT           NOT NULL,
    [Param_name]   NVARCHAR (50) NULL,
    [Weight_type]  INT           NULL,
    [Weight_value] FLOAT (53)    NULL
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - количество, 2 - оценка, 3 - Булево значение', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WinSAT_Params', @level2type = N'COLUMN', @level2name = N'Weight_type';
GO

ALTER TABLE [dbo].[WinSAT_Params]
    ADD CONSTRAINT [PK_WinSAT_Params] PRIMARY KEY CLUSTERED ([ID] ASC);
GO

