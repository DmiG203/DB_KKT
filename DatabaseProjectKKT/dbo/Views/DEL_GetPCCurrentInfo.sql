CREATE VIEW [dbo].[DEL_GetPCCurrentInfo]
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

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 883
               Bottom = 136
               Right = 1057
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "icpu"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "hdd"
            Begin Extent = 
               Top = 138
               Left = 462
               Bottom = 268
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Comments"
            Begin Extent = 
               Top = 459
               Left = 831
               Bottom = 589
               Right = 1021
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetPCCurrentInfo';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[29] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "pc"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 102
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "os"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 136
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 1095
               Bottom = 136
               Right = 1269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bb"
            Begin Extent = 
               Top = 6
               Left = 1307
               Bottom = 136
               Right = 1481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 102
               Left = 250
               Bottom = 232
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 670
               Bottom = 136
               Right = 845
            End
            DisplayFlags = 280
            TopColumn = 0
         End', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetPCCurrentInfo';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetPCCurrentInfo';
GO

