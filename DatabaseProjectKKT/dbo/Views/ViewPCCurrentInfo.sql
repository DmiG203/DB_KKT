CREATE VIEW [dbo].[ViewPCCurrentInfo]
AS
SELECT        o.NumOP, pc.ID, pc.IP, pc.MAC, s.Name, os.Hostname, os.OS, os.Arch, os.Version, os.Serial_number, os.Status, os.Install_date, os.lastBootTime, h.CPU1, h.CPU2, icpu.Cores, icpu.Threads, h.RAM, h.RAM_total_size, 
                         bb.Manufacturer AS bb_Manufacturer, bb.Product AS bb_product, bb.Serial_number AS bb_SN, bb.Version AS bb_version, m.Manufacturer, m.Model, m.Bios_SN, m.Update_Date, CAST(CASE WHEN Comments.RID IS NOT NULL 
                         THEN 1 ELSE 0 END AS BIT) AS CommentExist, SUM(hdd.Size) AS HHD_Size
FROM            dbo.PC_Info AS pc LEFT OUTER JOIN
                         dbo.Statuses AS s ON s.ID = pc.StatusID LEFT OUTER JOIN
                             (SELECT        ID, PC_ID, MAC, Hostname, OS, Arch, Version, Status, Serial_number, Install_date, lastBootTime, Add_date, Update_date
                               FROM            dbo.PC_OS_Info
                               WHERE        (ID IN
                                                             (SELECT        MAX(ID) AS ID
                                                               FROM            dbo.PC_OS_Info AS PC_OS_Info_1
                                                               GROUP BY PC_ID))) AS os ON os.PC_ID = pc.ID LEFT OUTER JOIN
                             (SELECT        ID, PC_ID, CPU1, CPU2, RAM, RAM_total_size, Add_date, Update_date
                               FROM            dbo.PC_Hardware_Info
                               WHERE        (ID IN
                                                             (SELECT        MAX(ID) AS Expr1
                                                               FROM            dbo.PC_Hardware_Info AS PC_Hardware_Info_1
                                                               GROUP BY PC_ID))) AS h ON h.PC_ID = pc.ID LEFT OUTER JOIN
                             (SELECT        ID, PC_ID, Manufacturer, Product, Serial_number, Version, Add_date, Update_date
                               FROM            dbo.PC_Baseboard_Info
                               WHERE        (ID IN
                                                             (SELECT        MAX(ID) AS Expr1
                                                               FROM            dbo.PC_Baseboard_Info AS PC_Baseboard_Info_1
                                                               GROUP BY PC_ID))) AS bb ON bb.PC_ID = pc.ID LEFT OUTER JOIN
                             (SELECT        ID, PC_ID, Manufacturer, Model, Bios_SN, Add_date, Update_Date
                               FROM            dbo.PC_Manufacturer_Info
                               WHERE        (ID IN
                                                             (SELECT        MAX(ID) AS Expr1
                                                               FROM            dbo.PC_Manufacturer_Info AS PC_Manufacturer_Info_1
                                                               GROUP BY PC_ID))) AS m ON m.PC_ID = pc.ID INNER JOIN
                         dbo.Computers AS c ON c.RID = pc.CompID INNER JOIN
                         dbo.Org AS o ON o.RID = c.OrgID INNER JOIN
                         dbo.Info_CPU AS icpu ON icpu.Name = h.CPU1 INNER JOIN
                         dbo.PC_Hdd_Info AS hdd ON hdd.PC_ID = pc.ID LEFT OUTER JOIN
                         dbo.Comments ON dbo.Comments.TableID = 4 AND dbo.Comments.ItemID = pc.ID AND dbo.Comments.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.Comments AS com1
                               WHERE        (TableID = 4) AND (ItemID = pc.ID))
WHERE        (s.ID IN (1))
GROUP BY o.NumOP, pc.ID, pc.IP, pc.MAC, s.Name, os.Hostname, os.OS, os.Arch, os.Version, os.Serial_number, os.Status, os.Install_date, os.lastBootTime, h.CPU1, h.CPU2, h.RAM, h.RAM_total_size, bb.Manufacturer, bb.Product, 
                         bb.Serial_number, bb.Version, m.Manufacturer, m.Model, m.Bios_SN, m.Update_Date, icpu.Cores, icpu.Threads, CAST(CASE WHEN Comments.RID IS NOT NULL THEN 1 ELSE 0 END AS BIT)
GO

