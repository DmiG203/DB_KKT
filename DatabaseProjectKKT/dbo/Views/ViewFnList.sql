CREATE VIEW dbo.ViewFnList
AS
SELECT        TOP (100) PERCENT dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.RID AS CompID, dbo.Computers.ComputerName, dbo.Kkm.RID AS KkmID, dbo.Kkm.SN AS KkmSn, dbo.Kkm.ModelID AS KkmModelID, 
                         dbo.KkmModel.Name AS KkmModel, dbo.Kkm.Deleted AS kkmDeleted, dbo.Fn.RID AS FnID, dbo.Fn.SN AS FnSn, dbo.FnModel.Name AS FnModel, dbo.Fn.Status, 
                         CASE dbo. Fn .Status WHEN 0 THEN 'Не активирована' WHEN 1 THEN 'Рабочий режим' WHEN 2 THEN 'Закрыт архив ФН' WHEN 3 THEN 'Сломана (есть заключение производителя)' WHEN 4 THEN 'Выведена из реестра ФНС (активировать не возможно)'
                          ELSE 'Статус неизвестен' END AS StatusDescription, dbo.Fn.DateExpired, RepReg_1.FFD AS KkmFFD, RepReg_1.WorkMode,
                             (SELECT        MIN(DateRep) AS Expr1
                               FROM            dbo.RepReg
                               WHERE        (RepTypeID = 1) AND (FnID = dbo.Fn.RID)) AS DateStart,
                             (SELECT        MAX(DateRep) AS Expr1
                               FROM            dbo.RepReg AS RepReg_2
                               WHERE        (RepTypeID = 3) AND (FnID = dbo.Fn.RID)) AS DateStop, 0 AS Move
FROM            dbo.Kkm LEFT OUTER JOIN
                         dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID LEFT OUTER JOIN
                         dbo.Fn ON dbo.Kkm.RID = dbo.Fn.KktID LEFT OUTER JOIN
                         dbo.RepReg AS RepReg_1 ON RepReg_1.FnID = dbo.Fn.RID AND RepReg_1.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.RepReg AS RepReg2
                               WHERE        (FnID = dbo.Fn.RID)
                               ORDER BY DateRep DESC) LEFT OUTER JOIN
                         dbo.FnModel ON dbo.FnModel.RID = dbo.Fn.ModelID LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND dbo.LocKkm.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)
                               ORDER BY AddDate DESC) LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID
ORDER BY dbo.Computers.ComputerName, RepReg_1.DateRep
GO

