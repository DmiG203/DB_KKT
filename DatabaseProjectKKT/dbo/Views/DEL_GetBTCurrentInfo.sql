CREATE VIEW dbo.[DEL_GetBTCurrentInfo]
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

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[18] 2[20] 3) )"
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
         Begin Table = "bts"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "btp"
            Begin Extent = 
               Top = 2
               Left = 705
               Bottom = 132
               Right = 943
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "btd"
            Begin Extent = 
               Top = 75
               Left = 463
               Bottom = 205
               Right = 659
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "det"
            Begin Extent = 
               Top = 183
               Left = 45
               Bottom = 313
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pci"
            Begin Extent = 
               Top = 212
               Left = 270
               Bottom = 342
               Right = 444
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "os"
            Begin Extent = 
               Top = 6
               Left = 981
               Bottom = 136
               Right = 1155
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 223
               Left = 487
               Bottom = 353
               Right = 662
            End
            DisplayFlags = 280
            TopColumn = 0
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetBTCurrentInfo';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetBTCurrentInfo';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'      End
         Begin Table = "o"
            Begin Extent = 
               Top = 230
               Left = 770
               Bottom = 360
               Right = 944
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetBTCurrentInfo';
GO

