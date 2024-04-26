CREATE VIEW [dbo].[ViewKkmList]
AS
SELECT        dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.RID AS CompID, dbo.Computers.ComputerName, dbo.Kkm.RID AS KkmID, dbo.Kkm.SN AS KkmSn, dbo.Kkm.ModelID AS KkmModelID, dbo.KkmModel.Name AS KkmModel, 
                         dbo.Kkm.Deleted AS KkmDeleted, dbo.Kkm.AddDate AS KkmAddDate, dbo.Kkm.SoftVer, dbo.Kkm.LoaderVersion, dbo.Kkm.MAC, dbo.Fn.RID AS FnID, dbo.Fn.SN AS FnSn, dbo.Fn.ModelID AS FnModelID, 
                         dbo.FnModel.Name AS FnModel, dbo.Fn.Status AS FnStatus, 
                         (CASE WHEN dbo.Fn.DateExpired <= '01.01.1970' or dbo.Fn.DateExpired is null THEN FNS.DateExpired ELSE dbo.Fn.DateExpired END ) AS DateExpired,
                         --(CASE WHEN dbo.Fn.DateExpired <= '01.01.1970' THEN NULL ELSE dbo.Fn.DateExpired END) AS DateExpired, 
                         dbo.Kkm.WorkMode, (CASE WHEN dbo.Kkm.WorkMode IN (0, 1) THEN 'Чек' WHEN dbo.Kkm.WorkMode IN (4, 5) THEN 'Киоск (Чек)' WHEN dbo.Kkm.WorkMode IN (24, 25) THEN 'БСО' WHEN dbo.Kkm.WorkMode IN (28, 29) 
                         THEN 'Киоск (БСО)' WHEN dbo.Kkm.WorkMode IN (36, 37) THEN 'Интернет (Чек)' WHEN dbo.Kkm.WorkMode IN (60, 61) THEN 'Интернет (БСО)' ELSE 'Не верный статус' END) AS WorkModeDescription, 
                         dbo.RepReg.WorkModeEx, dbo.RepReg.FFD AS KkmFFD, LastDocs.DocNum AS LastDocNum, LastDocs.DocDate AS LastDocDate, dbo.LocKkm.ComPort, dbo.LocKkm.ComBaudRate, dbo.Computers.ShtrihDrvVer, 
                         dbo.Computers.AtolDrvVer, dbo.RepReg.WorkMode AS WorkModeFromRepReg, dbo.Kkm.RNDIS, dbo.Kkm.IpAddress, dbo.Kkm.IpPort, dbo.Computers.LastStart,
                             (SELECT        UnconfirmedDoc
                               FROM            dbo.FnDocs
                               WHERE        (Type = 2) AND (FnID = dbo.Fn.RID) AND (AddDate =
                                                             (SELECT        MAX(AddDate) AS Expr1
                                                               FROM            dbo.FnDocs AS FnDocs_1
                                                               WHERE        (FnID = dbo.Fn.RID) AND (Type = 2)))) AS UnconfirmedDoc, CAST(CASE WHEN dbo.KkmNotUse.RID IS NOT NULL THEN 1 ELSE 0 END AS bit) AS KkmNotUse, 
                         (CASE dbo.KkmNotUse.NotUseType WHEN 1 THEN 'Не используется' WHEN 2 THEN 'Вывод из эксплуатации' WHEN 3 THEN 'Временная блокировка' END) AS KkmNotUseType, dbo.KkmNotUse.AddDate AS DateBlock, 
                         dbo.KkmNotUse.Comment AS CommentBlock, fns.RID AS FnsID, fns.RNM, fns.Status AS FnsStatus, fns.RegMode, CAST((Case WHEN fns.FnID = fn.rid Then 0 Else 1 End) as bit) as NeedReReg
FROM            dbo.Kkm LEFT OUTER JOIN
                         dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID LEFT OUTER JOIN
                         dbo.Fn ON dbo.Kkm.RID = dbo.Fn.KktID AND dbo.Fn.Status < 2 AND dbo.Fn.Deleted = 0 AND dbo.Fn.AddDate = (select MAX(Fn2.AddDate) from dbo.Fn Fn2 where Fn2.KktID = dbo.Kkm.Rid and Fn2.Status < 2)
                         LEFT OUTER JOIN
                         dbo.RepReg ON dbo.RepReg.FnID = dbo.Fn.RID AND dbo.RepReg.RID =
                             (SELECT        MAX(RID) AS Expr1
                               FROM            dbo.RepReg AS RepReg2
                               WHERE        (FnID = dbo.Fn.RID)) LEFT OUTER JOIN
                         dbo.FnModel ON dbo.FnModel.RID = dbo.Fn.ModelID LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND
                             (SELECT        MAX(RID) AS Expr1
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)) = dbo.LocKkm.RID LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID LEFT OUTER JOIN
                         dbo.FnDocs AS LastDocs ON LastDocs.Type = 1 AND LastDocs.FnID = dbo.Fn.RID AND LastDocs.DocNum =
                             (SELECT        MAX(DocNum) AS Expr1
                               FROM            dbo.FnDocs
                               WHERE        (Type = 1) AND (FnID = dbo.Fn.RID)) LEFT OUTER JOIN
                         dbo.KkmNotUse ON dbo.Kkm.RID = dbo.KkmNotUse.KkmId AND dbo.KkmNotUse.StopDate IS NULL LEFT OUTER JOIN
                         dbo.FNSData AS fns ON fns.KkmID = dbo.Kkm.RID AND fns.DateReg =
                             (SELECT        MAX(DateReg) AS Expr1
                               FROM            dbo.FNSData AS fns2
                               WHERE        (KkmID = fns.KkmID))
GO

