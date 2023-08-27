CREATE VIEW dbo.GetKkmList
AS
SELECT     dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.rid AS CompID, dbo.Computers.ComputerName, dbo.kkm.rid AS KkmID, dbo.kkm.sn AS KkmSn, dbo.kkm.modelID AS KkmModelID, dbo.kkmModel.Name AS KkmModel, dbo.kkm.deleted AS kkmDeleted, dbo.kkm.SoftVer, 
                  dbo.kkm.LoaderVersion, dbo.kkm.MAC, dbo.fn.rid AS FnID, dbo.fn.sn AS FnSn, dbo.fn.modelId AS FnModelID, dbo.fnModel.Name AS FnModel, dbo.fn.status, dbo.fn.DateExpired, dbo.kkm.WorkMode, dbo.RepReg.WorkModeEx, dbo.RepReg.FFD AS KkmFFD, dbo.fn.LastDocNum, 
                  dbo.fn.LastDocDate, dbo.LocKkm.ComPort, dbo.LocKkm.ComBaudRate, dbo.Computers.shtrihDrvVer, dbo.Computers.atolDrvVer, dbo.RepReg.WorkMode AS WokModeFromRepReg, dbo.kkm.RNDIS, dbo.kkm.ipAddress, dbo.kkm.ipPort, dbo.Computers.lastStart
FROM        dbo.kkm LEFT OUTER JOIN
                  dbo.kkmModel ON dbo.kkm.modelID = dbo.kkmModel.rid LEFT OUTER JOIN
                  dbo.fn ON dbo.kkm.rid = dbo.fn.kktID AND dbo.fn.status < 2 LEFT OUTER JOIN
                  dbo.RepReg ON dbo.RepReg.fnID = dbo.fn.rid AND dbo.RepReg.RID =
                      (SELECT     TOP (1) RID
                       FROM        dbo.RepReg AS RepReg2
                       WHERE     (fnID = dbo.fn.rid)
                       ORDER BY DateRep DESC) LEFT OUTER JOIN
                  dbo.fnModel ON dbo.fnModel.rid = dbo.fn.modelId LEFT OUTER JOIN
                  dbo.LocKkm ON dbo.kkm.rid = dbo.LocKkm.KkmId AND
                      (SELECT     TOP (1) rid
                       FROM        dbo.LocKkm AS lockkm2
                       WHERE     (KkmId = dbo.kkm.rid)
                       ORDER BY addDate DESC) = dbo.LocKkm.rid LEFT OUTER JOIN
                  dbo.Computers ON dbo.LocKkm.compID = dbo.Computers.rid LEFT OUTER JOIN
                  dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'      TopColumn = 2
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 290
               Left = 205
               Bottom = 420
               Right = 379
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
      Begin ColumnWidths = 21
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1908
         Alias = 2112
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 2100
         SortOrder = 1836
         GroupBy = 1350
         Filter = 4416
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmList';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmList';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[23] 2[14] 3) )"
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
         Begin Table = "kkm"
            Begin Extent = 
               Top = 27
               Left = 448
               Bottom = 344
               Right = 622
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "kkmModel"
            Begin Extent = 
               Top = 243
               Left = 662
               Bottom = 425
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fn"
            Begin Extent = 
               Top = 20
               Left = 681
               Bottom = 229
               Right = 855
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RepReg"
            Begin Extent = 
               Top = 6
               Left = 893
               Bottom = 136
               Right = 1067
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "fnModel"
            Begin Extent = 
               Top = 221
               Left = 886
               Bottom = 380
               Right = 1060
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 26
               Left = 206
               Bottom = 156
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 37
               Left = 0
               Bottom = 321
               Right = 175
            End
            DisplayFlags = 280
      ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmList';


GO

