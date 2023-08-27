/*
select repreg.* , kkmModel.Name As KKM_Name
from repreg 
inner join fn on fn.rid = repreg.fnid
left join kkm on kkm.rid = fn.kktID
inner join kkmModel on kkm.modelID = kkmModel.rid
where --fn.sn like '999%'
DateRep >= convert(date,'20.10.2021',104)

--update repreg set Comment = null where comment = ''
*/
CREATE VIEW dbo.DateBadRepReg
AS
SELECT        TOP (100) PERCENT CONVERT(DATE, dbo.RepReg.DateRep, 104) AS DateRepReg, dbo.kkm.SN, dbo.RepReg.Comment, dbo.RepReg.RID
FROM            dbo.RepReg INNER JOIN
                         dbo.fn ON dbo.fn.RID = dbo.RepReg.FnID INNER JOIN
                         dbo.kkm ON dbo.fn.KktID = dbo.kkm.RID LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.LocKkm.CompID = dbo.kkm.RID LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID
WHERE        (dbo.RepReg.AddsID IS NULL) AND (dbo.RepReg.FD > 0) AND (CAST(dbo.RepReg.FPD AS bigint) > 0) AND (dbo.RepReg.RepTypeID < 3)
GROUP BY CONVERT(DATE, dbo.RepReg.DateRep, 104), dbo.kkm.SN, dbo.RepReg.Comment, dbo.RepReg.RID

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DateBadRepReg';


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
         Left = -384
      End
      Begin Tables = 
         Begin Table = "RepReg"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fn"
            Begin Extent = 
               Top = 7
               Left = 313
               Bottom = 170
               Right = 530
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "kkm"
            Begin Extent = 
               Top = 7
               Left = 578
               Bottom = 170
               Right = 795
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 7
               Left = 843
               Bottom = 170
               Right = 1060
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 7
               Left = 1108
               Bottom = 170
               Right = 1325
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 7
               Left = 1373
               Bottom = 170
               Right = 1590
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
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
    ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DateBadRepReg';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'     Table = 1170
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'DateBadRepReg';


GO

