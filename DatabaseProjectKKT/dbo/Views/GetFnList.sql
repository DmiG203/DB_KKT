CREATE VIEW dbo.GetFnList
AS
SELECT        dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.rid AS CompID, dbo.Computers.ComputerName, dbo.kkm.rid AS KkmID, dbo.kkm.sn AS KkmSn, dbo.kkm.modelID AS KkmModelID, dbo.kkmModel.Name AS KkmModel, 
                         dbo.kkm.deleted AS kkmDeleted, dbo.fn.rid AS FnID, dbo.fn.sn AS FnSn, dbo.fnModel.Name AS FnModel, dbo.fn.status, dbo.fn.DateExpired, dbo.RepReg.FFD AS KkmFFD, dbo.fn.LastDocNum, dbo.fn.LastDocDate, 
                         dbo.RepReg.WorkMode AS WokModeFromRepReg
FROM            dbo.kkm LEFT OUTER JOIN
                         dbo.kkmModel ON dbo.kkm.modelID = dbo.kkmModel.rid LEFT OUTER JOIN
                         dbo.fn ON dbo.kkm.rid = dbo.fn.kktID LEFT OUTER JOIN
                         dbo.RepReg ON dbo.RepReg.fnID = dbo.fn.rid AND dbo.RepReg.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.RepReg AS RepReg2
                               WHERE        (fnID = dbo.fn.rid)
                               ORDER BY DateRep DESC) LEFT OUTER JOIN
                         dbo.fnModel ON dbo.fnModel.rid = dbo.fn.modelId LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.kkm.rid = dbo.LocKkm.KkmId AND
                             (SELECT        TOP (1) rid
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmId = dbo.kkm.rid)
                               ORDER BY addDate DESC) = dbo.LocKkm.rid LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.compID = dbo.Computers.rid LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetFnList';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'           TopColumn = 0
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 233
               Left = 84
               Bottom = 363
               Right = 258
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetFnList';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[23] 2[24] 3) )"
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
               Top = 32
               Left = 418
               Bottom = 162
               Right = 592
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkmModel"
            Begin Extent = 
               Top = 34
               Left = 86
               Bottom = 147
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fn"
            Begin Extent = 
               Top = 33
               Left = 929
               Bottom = 163
               Right = 1109
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RepReg"
            Begin Extent = 
               Top = 8
               Left = 1210
               Bottom = 138
               Right = 1384
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "fnModel"
            Begin Extent = 
               Top = 208
               Left = 1235
               Bottom = 338
               Right = 1409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 223
               Left = 699
               Bottom = 353
               Right = 873
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 210
               Left = 414
               Bottom = 340
               Right = 589
            End
            DisplayFlags = 280
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetFnList';


GO

