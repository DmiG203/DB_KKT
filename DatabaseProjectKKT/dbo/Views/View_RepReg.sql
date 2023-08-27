CREATE VIEW dbo.View_RepReg
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

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_RepReg';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[39] 4[34] 2[23] 3) )"
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
         Begin Table = "kkmModel"
            Begin Extent = 
               Top = 38
               Left = 0
               Bottom = 151
               Right = 174
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkm"
            Begin Extent = 
               Top = 37
               Left = 204
               Bottom = 167
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RepReg"
            Begin Extent = 
               Top = 39
               Left = 612
               Bottom = 381
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RepType"
            Begin Extent = 
               Top = 36
               Left = 815
               Bottom = 164
               Right = 989
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "adds"
            Begin Extent = 
               Top = 243
               Left = 815
               Bottom = 362
               Right = 1016
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fn"
            Begin Extent = 
               Top = 39
               Left = 408
               Bottom = 270
               Right = 582
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
      Begin ColumnWidths = 17
         Width = 284
         Width = 2205
         Width = 2085
         Width =', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_RepReg';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' 1860
         Width = 2475
         Width = 2205
         Width = 1815
         Width = 1500
         Width = 1935
         Width = 2145
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
         Column = 2880
         Alias = 2130
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 5445
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_RepReg';


GO

