/*RIGHT OUTER JOIN dbo.kkm ON dbo.kkmModel.rid = dbo.kkm.modelID ON dbo.logs.kkmID = dbo.kkm.rid
dbo.logs LEFT OUTER JOIN
                         dbo.Org INNER JOIN
                         dbo.Computers ON dbo.Org.RID = dbo.Computers.OrgID ON dbo.logs.compID = dbo.Computers.rid LEFT OUTER JOIN
                         dbo.kkmModel RIGHT OUTER JOIN
                         dbo.kkm ON dbo.kkmModel.rid = dbo.kkm.modelID ON dbo.logs.kkmID = dbo.kkm.rid*/
CREATE VIEW dbo.View_Logs
AS
SELECT     dbo.logs.rid, dbo.Org.NumOP, dbo.logs.compID, dbo.Computers.ComputerName, dbo.kkm.sn AS KkmSn, dbo.kkmModel.Name AS kkmModel, dbo.logs.addDateTime, dbo.textTable.text AS event
FROM        dbo.logs LEFT OUTER JOIN
                  dbo.textTable ON dbo.logs.eventID = dbo.textTable.rid LEFT OUTER JOIN
                  dbo.Computers ON dbo.logs.compID = dbo.Computers.rid LEFT OUTER JOIN
                  dbo.Org ON dbo.Org.RID = dbo.Computers.OrgID LEFT OUTER JOIN
                  dbo.kkm ON dbo.logs.kkmID = dbo.kkm.rid LEFT OUTER JOIN
                  dbo.kkmModel ON dbo.kkmModel.rid = dbo.kkm.modelID

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'      Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_Logs';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_Logs';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[62] 4[19] 2[14] 3) )"
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
         Begin Table = "Org"
            Begin Extent = 
               Top = 3
               Left = 0
               Bottom = 125
               Right = 174
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkmModel"
            Begin Extent = 
               Top = 0
               Left = 795
               Bottom = 170
               Right = 969
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "textTable"
            Begin Extent = 
               Top = 188
               Left = 170
               Bottom = 307
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkm"
            Begin Extent = 
               Top = 0
               Left = 591
               Bottom = 184
               Right = 765
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 2
               Left = 206
               Bottom = 132
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "logs"
            Begin Extent = 
               Top = 1
               Left = 401
               Bottom = 186
               Right = 575
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
         Column = 1992
         Alias = 1896
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_Logs';


GO

