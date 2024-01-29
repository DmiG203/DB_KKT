CREATE VIEW dbo.ViewLocKKM
AS
SELECT        dbo.LocKkm.rid, dbo.kkm.rid AS KkmID, dbo.kkm.sn AS KkmSn, dbo.kkmModel.rid AS KkmModelID, dbo.kkmModel.Name AS KkmModel, dbo.Org.NumOP, dbo.Computers.rid AS CompID, dbo.Computers.ComputerName, 
                         dbo.LocKkm.ComPort, dbo.LocKkm.ComBaudRate, dbo.LocKkm.addDate, dbo.LocKkm.updateDate, dbo.LocKkm.source
FROM            dbo.LocKkm INNER JOIN
                         dbo.Computers ON dbo.LocKkm.compID = dbo.Computers.rid INNER JOIN
                         dbo.kkmModel INNER JOIN
                         dbo.kkm ON dbo.kkmModel.rid = dbo.kkm.modelID ON dbo.LocKkm.KkmId = dbo.kkm.rid INNER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID
GO

