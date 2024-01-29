CREATE VIEW dbo.ViewBTCurrentInfo
AS
SELECT DISTINCT 
                         o.NumOP, pci.IP, os.Hostname, bts.CompID, bts.Terminal_number, bts.Merchant_number, bts.Serial_number, bts.Terminal_model, bts.Software_versions_UPOS, bts.Contactless, bts.Loading_parameters, 
                         bts.DateTime_last_operation, btp.PC_PathFolder, btp.PC_Serial_number, btp.PC_Model, btp.PC_Software_versions_UPOS, btp.LoadParmEXE, btp.GateDLL, btp.Sb_kernelDLL, det.Detected, btd.DriverVersion, bts.Add_date, 
                         bts.Update_date
FROM            dbo.BT_Software_Info AS bts LEFT OUTER JOIN
                             (SELECT        b.ID, b.CompID, b.TerminalID, b.PC_PathFolder, b.PC_Model, b.PC_Serial_number, b.PC_Software_versions_UPOS, b.LoadParmEXE, b.GateDLL, b.Sb_kernelDLL, b.FullTextFromFile, b.Add_date, 
                                                         b.Update_date
                               FROM            dbo.BT_Program_Info AS b INNER JOIN
                                                             (SELECT        TerminalID, MAX(Update_date) AS Update_date
                                                               FROM            dbo.BT_Program_Info AS bt
                                                               GROUP BY TerminalID) AS t ON t.TerminalID = b.TerminalID AND t.Update_date = b.Update_date) AS btp ON btp.TerminalID = bts.ID LEFT OUTER JOIN
                             (SELECT        b.ID, b.CompID, b.Terminal_ID, b.Description, b.DeviceName, b.DriverDate, b.DriverProviderName, b.DriverVersion, b.FriendlyName, b.Add_Date, b.Update_Date
                               FROM            dbo.BT_Driver_Info AS b INNER JOIN
                                                             (SELECT        CompID, MAX(Update_Date) AS Update_date
                                                               FROM            dbo.BT_Driver_Info AS bt
                                                               GROUP BY CompID) AS t_1 ON t_1.CompID = b.CompID AND t_1.Update_date = b.Update_Date) AS btd ON btd.CompID = bts.CompID LEFT OUTER JOIN
                         dbo.BT_Detect AS det ON det.TerminalID = bts.ID INNER JOIN
                         dbo.PC_Info AS pci ON pci.CompID = bts.CompID INNER JOIN
                             (SELECT        pcos.ID, pcos.PC_ID, pcos.MAC, pcos.Hostname, pcos.OS, pcos.Arch, pcos.Version, pcos.Status, pcos.Serial_number, pcos.Install_date, pcos.lastBootTime, pcos.Add_date, pcos.Update_date
                               FROM            dbo.PC_OS_Info AS pcos INNER JOIN
                                                             (SELECT        MAC, MAX(Add_date) AS add_date
                                                               FROM            dbo.PC_OS_Info AS pcos1
                                                               GROUP BY MAC) AS ost ON ost.MAC = pcos.MAC AND ost.add_date = pcos.Add_date) AS os ON os.PC_ID = pci.ID INNER JOIN
                         dbo.Computers AS c ON c.RID = pci.CompID INNER JOIN
                         dbo.Org AS o ON o.RID = c.OrgID
WHERE        (bts.StatusID = 1) AND (bts.IsDeleted = 0) AND (pci.StatusID = 1)
GO

