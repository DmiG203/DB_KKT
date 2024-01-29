CREATE VIEW dbo.ViewKkmLic
AS
SELECT        dbo.Org.NumOP, dbo.Computers.ComputerName, dbo.kkm.sn, dbo.kkmModel.Name AS ModelKkm, dbo.kkm.SoftVer, dbo.fn.sn AS snFn, dbo.fnModel.Name AS ModelFn, dbo.fn.status, dbo.fn.DateExpired, dbo.kkm.WorkMode, 
                         dbo.fn.LastDocNum, dbo.fn.LastDocDate, dbo.LocKkm.ComPort, dbo.LocKkm.ComBaudRate, dbo.kkm_lic_type.Name AS lic_name, dbo.kkm_lic.licHEX, dbo.kkm_lic.syngHEX
FROM            dbo.kkm_lic_type INNER JOIN
                         dbo.kkm_lic ON dbo.kkm_lic_type.RID = dbo.kkm_lic.lic_typeID RIGHT OUTER JOIN
                         dbo.kkm ON dbo.kkm_lic.kktID = dbo.kkm.rid LEFT OUTER JOIN
                         dbo.kkmModel ON dbo.kkm.modelID = dbo.kkmModel.rid LEFT OUTER JOIN
                         dbo.fn ON dbo.kkm.rid = dbo.fn.kktID AND dbo.fn.status <> 2 AND dbo.fn.status <> 4 LEFT OUTER JOIN
                         dbo.fnModel ON dbo.fnModel.rid = dbo.fn.modelId LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.kkm.rid = dbo.LocKkm.KkmId AND
                             (SELECT        TOP (1) rid
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmId = dbo.kkm.rid)
                               ORDER BY addDate DESC) = dbo.LocKkm.rid LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.compID = dbo.Computers.rid LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID
GO

