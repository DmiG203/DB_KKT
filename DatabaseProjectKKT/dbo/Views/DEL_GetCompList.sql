CREATE VIEW dbo.[DEL_GetCompList]
AS
SELECT        dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.RID AS CompID, dbo.Computers.ComputerName, dbo.Kkm.RID AS KkmID, dbo.Kkm.SN AS KkmSn, dbo.Kkm.ModelID AS KkmModelID, dbo.KkmModel.Name AS KkmModel, 
                         dbo.Kkm.Deleted AS kkmDeleted
FROM            dbo.Kkm LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND
                             (SELECT        TOP (1) RID
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)
                               ORDER BY AddDate DESC) = dbo.LocKkm.RID LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID LEFT OUTER JOIN
                         dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetCompList';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[13] 2[23] 3) )"
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
         Begin Table = "Kkm"
            Begin Extent = 
               Top = 15
               Left = 213
               Bottom = 316
               Right = 387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 15
               Left = 432
               Bottom = 315
               Right = 606
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 13
               Left = 637
               Bottom = 316
               Right = 812
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 11
               Left = 842
               Bottom = 319
               Right = 1016
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "KkmModel"
            Begin Extent = 
               Top = 16
               Left = 9
               Bottom = 314
               Right = 183
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
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetCompList';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetCompList';
GO

