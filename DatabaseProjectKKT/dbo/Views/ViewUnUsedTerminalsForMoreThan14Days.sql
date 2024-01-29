CREATE VIEW dbo.ViewUnUsedTerminalsForMoreThan14Days
AS
SELECT        btss.ID, t.NumOP, t.IP, t.Hostname, t.Terminal_number, t.Serial_number, t.Terminal_model, t.Detected, t.DateTime_last_operation, t.Add_date, btss.Min_add_date AS First_add_date, t.Update_date, DATEDIFF(day, 
                         t.DateTime_last_operation, t.Update_date) AS Days_of_downtime, DATEDIFF(day, t.Update_date, GETDATE()) AS Days_without_update, DATEDIFF(day, t.DateTime_last_operation, t.Update_date) + DATEDIFF(day, t.Update_date, 
                         GETDATE()) AS Sum_Days
FROM            dbo.ViewBTCurrentInfo AS t INNER JOIN
                             (SELECT        bts.ID, bts.CompID, bts.Terminal_number, bts.Merchant_number, bts.Serial_number, bts.Terminal_model, bts.Contactless, bts.Loading_parameters, bts.DateTime_last_operation, bts.Software_versions_UPOS, 
                                                         bts.StatusID, bts.IsDeleted, bts.Add_date, bts.Update_date, bts_g.Min_add_date
                               FROM            dbo.BT_Software_Info AS bts INNER JOIN
                                                             (SELECT        Terminal_number, Serial_number, MIN(Add_date) AS Min_add_date
                                                               FROM            dbo.BT_Software_Info AS b
                                                               WHERE        (IsDeleted = 0)
                                                               GROUP BY Terminal_number, Serial_number) AS bts_g ON bts_g.Terminal_number = bts.Terminal_number AND bts_g.Serial_number = bts.Serial_number
                               WHERE        (bts.DateTime_last_operation IS NOT NULL) AND (bts.StatusID = 1)) AS btss ON t.Terminal_number = btss.Terminal_number AND t.Serial_number = btss.Serial_number AND DATEDIFF(day, 
                         t.DateTime_last_operation, t.Update_date) <= DATEDIFF(day, btss.Min_add_date, t.Update_date)
WHERE        (DATEDIFF(day, t.DateTime_last_operation, t.Update_date) >= 14) AND (t.Detected = 1) OR
                         (t.Detected = 1) AND (DATEDIFF(day, t.DateTime_last_operation, t.Update_date) + DATEDIFF(day, t.Update_date, GETDATE()) >= 14) OR
                         (t.Detected = 1) AND (DATEDIFF(day, t.Update_date, GETDATE()) >= 14)
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
         Left = 0
      End
      Begin Tables = 
         Begin Table = "btss"
            Begin Extent = 
               Top = 12
               Left = 387
               Bottom = 142
               Right = 605
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 276
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewUnUsedTerminalsForMoreThan14Days';
GO


EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewUnUsedTerminalsForMoreThan14Days';
GO

