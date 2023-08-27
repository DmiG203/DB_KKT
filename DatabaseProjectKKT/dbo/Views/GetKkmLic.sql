CREATE VIEW dbo.GetKkmLic
AS
SELECT        dbo.Org.NumOP, dbo.Computers.ComputerName, dbo.kkm.sn, dbo.kkmModel.Name AS ModelKkm, dbo.kkm.SoftVer, dbo.fn.sn AS snFn, dbo.fnModel.Name AS ModelFn, dbo.fn.status, dbo.fn.DateExpired, dbo.kkm.WorkMode, 
                         dbo.fn.LastDocNum, dbo.fn.LastDocDate, dbo.LocKkm.ComPort, dbo.LocKkm.ComBaudRate, dbo.kkm_lic_type.Name AS lic_name, dbo.kkm_lic.licHEX, dbo.kkm_lic.syngHEX
FROM            dbo.kkm_lic_type INNER JOIN
                         dbo.kkm_lic ON dbo.kkm_lic_type.RID = dbo.kkm_lic.lic_typeID RIGHT OUTER JOIN
                         dbo.kkm ON dbo.kkm_lic.kktID = dbo.kkm.rid LEFT OUTER JOIN
                         dbo.kkmModel ON dbo.kkm.modelID = dbo.kkmModel.rid LEFT OUTER JOIN
                         dbo.fn ON dbo.kkm.rid = dbo.fn.kktID AND dbo.fn.status <> 2 AND dbo.fn.status <> 4 LEFT OUTER JOIN
                         dbo.fnModel ON dbo.fnModel.rid = dbo.fn.modelId LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.kkm.rid = dbo.LocKkm.KkmId AND
                             (SELECT        TOP (1) rid
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmId = dbo.kkm.rid)
                               ORDER BY addDate DESC) = dbo.LocKkm.rid LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.compID = dbo.Computers.rid LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'      TopColumn = 0
         End
         Begin Table = "kkm_lic"
            Begin Extent = 
               Top = 224
               Left = 251
               Bottom = 354
               Right = 425
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkm_lic_type"
            Begin Extent = 
               Top = 224
               Left = 22
               Bottom = 351
               Right = 196
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmLic';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmLic';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[14] 2[23] 3) )"
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
               Top = 142
               Left = 480
               Bottom = 272
               Right = 654
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkmModel"
            Begin Extent = 
               Top = 238
               Left = 724
               Bottom = 351
               Right = 898
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fn"
            Begin Extent = 
               Top = 39
               Left = 243
               Bottom = 169
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fnModel"
            Begin Extent = 
               Top = 40
               Left = 20
               Bottom = 170
               Right = 194
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 83
               Left = 724
               Bottom = 213
               Right = 898
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 79
               Left = 937
               Bottom = 209
               Right = 1112
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 80
               Left = 1144
               Bottom = 210
               Right = 1318
            End
            DisplayFlags = 280
      ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmLic';


GO

