CREATE VIEW dbo.ViewLogs
AS
SELECT     dbo.logs.rid, dbo.Org.NumOP, dbo.logs.compID, dbo.Computers.ComputerName, dbo.kkm.sn AS KkmSn, dbo.kkmModel.Name AS kkmModel, dbo.logs.addDateTime, dbo.textTable.text AS event
FROM        dbo.logs LEFT OUTER JOIN
                  dbo.textTable ON dbo.logs.eventID = dbo.textTable.rid LEFT OUTER JOIN
                  dbo.Computers ON dbo.logs.compID = dbo.Computers.rid LEFT OUTER JOIN
                  dbo.Org ON dbo.Org.RID = dbo.Computers.OrgID LEFT OUTER JOIN
                  dbo.kkm ON dbo.logs.kkmID = dbo.kkm.rid LEFT OUTER JOIN
                  dbo.kkmModel ON dbo.kkmModel.rid = dbo.kkm.modelID
GO

