CREATE VIEW dbo.ViewServersSN
AS
SELECT        TOP (100) PERCENT o.NumOP, os.Hostname, m.Manufacturer, m.Model, bb.Product AS bb_product, bb.Serial_number AS Bb_SN, m.Bios_SN, m.Update_Date
FROM            dbo.PC_Info AS pc LEFT OUTER JOIN
                         dbo.Statuses AS s ON s.ID = pc.StatusID LEFT OUTER JOIN
                             (SELECT        ID, PC_ID, MAC, Hostname, OS, Arch, Version, Status, Serial_number, Install_date, lastBootTime, Add_date, Update_date
                               FROM            dbo.PC_OS_Info
                               WHERE        (ID IN
                                                             (SELECT        MAX(ID) AS ID
                                                               FROM            dbo.PC_OS_Info AS PC_OS_Info_1
                                                               GROUP BY PC_ID))) AS os ON os.PC_ID = pc.ID LEFT OUTER JOIN
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
                         dbo.Org AS o ON o.RID = c.OrgID
WHERE        (s.ID = 1) AND (c.ComputerType = 1)
ORDER BY o.NumOP
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewServersSN';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
               Top = 174
               Left = 253
               Bottom = 270
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "os"
            Begin Extent = 
               Top = 167
               Left = 473
               Bottom = 297
               Right = 647
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bb"
            Begin Extent = 
               Top = 128
               Left = 668
               Bottom = 258
               Right = 842
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 0
               Left = 842
               Bottom = 130
               Right = 1016
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 63
               Left = 1099
               Bottom = 193
               Right = 1274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 175
               Left = 895
               Bottom = 305
               Right = 1069
            End
            DisplayFlags = 280
            TopColumn = 0
      ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewServersSN';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewServersSN';
GO

