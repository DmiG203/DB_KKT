CREATE VIEW dbo.ViewRepReg
AS
SELECT        dbo.RepReg.RID AS RepRegID, dbo.RepReg.DateRep AS RepRegDate, dbo.RepReg.cashier, dbo.adds.adds, dbo.RepReg.RNM, dbo.fn.rid AS FnID, dbo.fn.sn AS FnSn, dbo.fn.status AS FnStatus, dbo.fn.DateExpired, 
                         dbo.RepReg.FD, dbo.RepReg.FPD, dbo.RepReg.FFD, dbo.kkm.rid AS KkmID, dbo.kkm.sn AS KkmSn, dbo.kkmModel.Name AS KkmModel, dbo.RepReg.RepTypeID, dbo.RepType.Name AS RepType, dbo.RepReg.WorkMode, 
                         dbo.RepReg.link, dbo.RepReg.AddDate, dbo.RepReg.Comment, dbo.RepReg.source, dbo.RepReg.WorkModeEx
FROM            dbo.kkmModel RIGHT OUTER JOIN
                         dbo.kkm ON dbo.kkmModel.rid = dbo.kkm.modelID RIGHT OUTER JOIN
                         dbo.RepReg LEFT OUTER JOIN
                         dbo.RepType ON dbo.RepReg.RepTypeID = dbo.RepType.rid LEFT OUTER JOIN
                         dbo.adds ON dbo.RepReg.addsID = dbo.adds.rid LEFT OUTER JOIN
                         dbo.fn ON dbo.RepReg.fnID = dbo.fn.rid ON dbo.kkm.rid = dbo.fn.kktID
GO

