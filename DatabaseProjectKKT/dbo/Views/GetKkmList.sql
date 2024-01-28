CREATE VIEW dbo.GetKkmList
AS
SELECT        dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.RID AS CompID, dbo.Computers.ComputerName, dbo.Kkm.RID AS KkmID, dbo.Kkm.SN AS KkmSn, dbo.Kkm.ModelID AS KkmModelID, dbo.KkmModel.Name AS KkmModel, 
                         dbo.Kkm.Deleted AS KkmDeleted, dbo.Kkm.AddDate AS KkmAddDate, dbo.Kkm.SoftVer, dbo.Kkm.LoaderVersion, dbo.Kkm.MAC, dbo.Fn.RID AS FnID, dbo.Fn.SN AS FnSn, dbo.Fn.ModelID AS FnModelID, 
                         dbo.FnModel.Name AS FnModel, dbo.Fn.Status AS FnStatus, (CASE WHEN dbo. Fn .DateExpired <= '01.01.1970' THEN NULL WHEN dbo. Fn .DateExpired = NULL THEN NULL ELSE dbo. Fn .DateExpired END) AS DateExpired, 
                         dbo.Kkm.WorkMode, (CASE WHEN dbo.Kkm.WorkMode IN (0, 1) THEN 'Чек' WHEN dbo.Kkm.WorkMode IN (4, 5) THEN 'Киоск (Чек)' WHEN dbo.Kkm.WorkMode IN (24, 25) THEN 'БСО' WHEN dbo.Kkm.WorkMode IN (28, 29) 
                         THEN 'Киоск (БСО)' WHEN dbo.Kkm.WorkMode IN (36, 37) THEN 'Интернет (Чек)' WHEN dbo.Kkm.WorkMode IN (60, 61) THEN 'Интернет (БСО)' ELSE 'Не верный статус' END) AS WorkModeDescription, 
                         dbo.RepReg.WorkModeEx, dbo.RepReg.FFD AS KkmFFD, LastDocs.DocNum AS LastDocNum, LastDocs.DocDate AS LastDocDate, dbo.LocKkm.ComPort, dbo.LocKkm.ComBaudRate, dbo.Computers.ShtrihDrvVer, 
                         dbo.Computers.AtolDrvVer, dbo.RepReg.WorkMode AS WorkModeFromRepReg, dbo.Kkm.RNDIS, dbo.Kkm.IpAddress, dbo.Kkm.IpPort, dbo.Computers.LastStart,
                             (SELECT        UnconfirmedDoc
                               FROM            dbo.FnDocs
                               WHERE        (Type = 2) AND (FnID = dbo.Fn.RID) AND (AddDate =
                                                             (SELECT        MAX(AddDate) AS Expr1
                                                               FROM            dbo.FnDocs AS FnDocs_1
                                                               WHERE        (FnID = dbo.Fn.RID) AND (Type = 2)))) AS UnconfirmedDoc, CAST(CASE WHEN dbo.KkmNotUse.RID IS NOT NULL THEN 1 ELSE 0 END AS bit) AS KkmNotUse, 
                         (CASE dbo.KkmNotUse.NotUseType WHEN 1 THEN 'Не используется' WHEN 2 THEN 'Вывод из эксплуатации' WHEN 3 THEN 'Временная блокировка' END) AS KkmNotUseType, dbo.KkmNotUse.AddDate AS DateBlock, 
                         dbo.KkmNotUse.Comment AS CommentBlock, fns.RID AS FnsID, fns.RNM, fns.Status AS FnsStatus, fns.RegMode
FROM            dbo.Kkm LEFT OUTER JOIN
                         dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID LEFT OUTER JOIN
                         dbo.Fn ON dbo.Kkm.RID = dbo.Fn.KktID AND dbo.Fn.Status < 2 AND dbo.Fn.Deleted = 0 LEFT OUTER JOIN
                         dbo.RepReg ON dbo.RepReg.FnID = dbo.Fn.RID AND dbo.RepReg.RID =
                             (SELECT        MAX(RID) AS Expr1
                               FROM            dbo.RepReg AS RepReg2
                               WHERE        (FnID = dbo.Fn.RID)) LEFT OUTER JOIN
                         dbo.FnModel ON dbo.FnModel.RID = dbo.Fn.ModelID LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND
                             (SELECT        MAX(RID) AS Expr1
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)) = dbo.LocKkm.RID LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID LEFT OUTER JOIN
                         dbo.FnDocs AS LastDocs ON LastDocs.Type = 1 AND LastDocs.FnID = dbo.Fn.RID AND LastDocs.DocNum =
                             (SELECT        MAX(DocNum) AS Expr1
                               FROM            dbo.FnDocs
                               WHERE        (Type = 1) AND (FnID = dbo.Fn.RID)) LEFT OUTER JOIN
                         dbo.KkmNotUse ON dbo.Kkm.RID = dbo.KkmNotUse.KkmId AND dbo.KkmNotUse.StopDate IS NULL LEFT OUTER JOIN
                         dbo.FNSData AS fns ON fns.KkmID = dbo.Kkm.RID AND fns.DateReg =
                             (SELECT        MAX(DateReg) AS Expr1
                               FROM            dbo.FNSData AS fns2
                               WHERE        (KkmID = fns.KkmID))

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'          TopColumn = 2
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 376
               Left = 204
               Bottom = 506
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "LastDocs"
            Begin Extent = 
               Top = 23
               Left = 635
               Bottom = 153
               Right = 815
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "KkmNotUse"
            Begin Extent = 
               Top = 31
               Left = 994
               Bottom = 161
               Right = 1168
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fns"
            Begin Extent = 
               Top = 26
               Left = 433
               Bottom = 156
               Right = 607
            End
            DisplayFlags = 280
            TopColumn = 11
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
         Column = 1905
         Alias = 2115
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 2100
         SortOrder = 1830
         GroupBy = 1350
         Filter = 4410
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
         Configuration = "(H (1[34] 4[34] 2[26] 3) )"
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
               Top = 195
               Left = 432
               Bottom = 325
               Right = 606
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "KkmModel"
            Begin Extent = 
               Top = 204
               Left = 208
               Bottom = 317
               Right = 382
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Fn"
            Begin Extent = 
               Top = 366
               Left = 388
               Bottom = 496
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 9
         End
         Begin Table = "RepReg"
            Begin Extent = 
               Top = 196
               Left = 985
               Bottom = 326
               Right = 1159
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "FnModel"
            Begin Extent = 
               Top = 384
               Left = 652
               Bottom = 514
               Right = 826
            End
            DisplayFlags = 280
            TopColumn = 0
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
               Top = 108
               Left = 0
               Bottom = 392
               Right = 175
            End
            DisplayFlags = 280
  ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'GetKkmList';


GO


GRANT SELECT
    ON OBJECT::[dbo].[GetKkmList] TO [cash]
    AS [dbo];
GO

