CREATE VIEW dbo.[DEL_GetFnList]
AS
SELECT        TOP (100) PERCENT dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.RID AS CompID, dbo.Computers.ComputerName, dbo.Kkm.RID AS KkmID, dbo.Kkm.SN AS KkmSn, dbo.Kkm.ModelID AS KkmModelID, 
                         dbo.KkmModel.Name AS KkmModel, dbo.Kkm.Deleted AS kkmDeleted, dbo.Fn.RID AS FnID, dbo.Fn.SN AS FnSn, dbo.FnModel.Name AS FnModel, dbo.Fn.Status, 
                         CASE dbo. Fn .Status WHEN 0 THEN 'Не активирована' WHEN 1 THEN 'Рабочий режим' WHEN 2 THEN 'Закрыт архив ФН' WHEN 3 THEN 'Сломана (есть заключение производителя)' WHEN 4 THEN 'Выведена из реестра ФНС (активировать не возможно)'
                          ELSE 'Статус неизвестен' END AS StatusDescription, dbo.Fn.DateExpired, RepReg_1.FFD AS KkmFFD, RepReg_1.WorkMode,
                             (SELECT        MIN(DateRep) AS Expr1
                               FROM            dbo.RepReg
                               WHERE        (RepTypeID = 1) AND (FnID = dbo.Fn.RID)) AS DateStart,
                             (SELECT        MAX(DateRep) AS Expr1
                               FROM            dbo.RepReg AS RepReg_2
                               WHERE        (RepTypeID = 3) AND (FnID = dbo.Fn.RID)) AS DateStop, 0 AS Move
FROM            dbo.Kkm LEFT OUTER JOIN
                         dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID LEFT OUTER JOIN
                         dbo.Fn ON dbo.Kkm.RID = dbo.Fn.KktID LEFT OUTER JOIN
                         dbo.RepReg AS RepReg_1 ON RepReg_1.FnID = dbo.Fn.RID AND RepReg_1.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.RepReg AS RepReg2
                               WHERE        (FnID = dbo.Fn.RID)
                               ORDER BY DateRep DESC) LEFT OUTER JOIN
                         dbo.FnModel ON dbo.FnModel.RID = dbo.Fn.ModelID LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND dbo.LocKkm.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)
                               ORDER BY AddDate DESC) LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID
ORDER BY dbo.Computers.ComputerName, RepReg_1.DateRep
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetFnList';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'            TopColumn = 0
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 82
               Left = 16
               Bottom = 212
               Right = 190
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
      Begin ColumnWidths = 19
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetFnList';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[39] 4[28] 2[24] 3) )"
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
         Left = -127
      End
      Begin Tables = 
         Begin Table = "Kkm"
            Begin Extent = 
               Top = 293
               Left = 259
               Bottom = 423
               Right = 433
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "KkmModel"
            Begin Extent = 
               Top = 303
               Left = 14
               Bottom = 416
               Right = 188
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Fn"
            Begin Extent = 
               Top = 447
               Left = 8
               Bottom = 577
               Right = 188
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RepReg_1"
            Begin Extent = 
               Top = 293
               Left = 528
               Bottom = 423
               Right = 702
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "FnModel"
            Begin Extent = 
               Top = 452
               Left = 356
               Bottom = 582
               Right = 530
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 52
               Left = 492
               Bottom = 182
               Right = 666
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 91
               Left = 244
               Bottom = 221
               Right = 419
            End
            DisplayFlags = 280
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DEL_GetFnList';
GO

