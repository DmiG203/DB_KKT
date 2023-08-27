CREATE VIEW dbo.view_external_logs
AS
SELECT        ComputerName AS computer_name, CAST(theatre_id AS int) AS theatre_id, Version, work_date, Query_type, Query_Name, COUNT(DISTINCT Date_Created) AS сnt_app_launches, SUM(Normal_Count) AS normal_count, 
                         SUM(CEE_Count) AS cee_count, SUM(TimeOut_Count) AS timeout_count, SUM(total_query) AS total_query, ROUND(AVG(bad_query_ratio), 4) AS bad_query_ratio, MIN(MinTime) AS min_time, MAX(MaxTime) AS max_time, 
                         AVG(AvgTime) AS avg_time
FROM            (SELECT        c.ComputerName, SUBSTRING(c.ComputerName, 8, 3) AS theatre_id, el.Version, CASE WHEN el.Query_Name IN ('GETCODEINFO', 'PASSEVENT', 'GETACCESSPOINTS') 
                                                    THEN 'SUD' WHEN el.Query_Name IN ('KIOSKGETANNOUNCEMENT', 'KIOSKGETCARDINFO', 'KIOSKGETCURRENCY', 'KIOSKGETLASTPRINTEDTICKETS', 'KIOSKGETRIBBONS', 'KIOSKGETRIBBONVOIDSREASON', 
                                                    'KIOSKGETSETTINGS', 'KIOSKGETUNITS', 'KIOSKGETUSERS', 'KIOSKRECALCPRICE', 'KIOSKSALE', 'KIOSKSETRIBBON', 'KIOSKTRANSACTION') THEN 'KIOSK' WHEN el.Query_Name IN ('GETFORMATS', 
                                                    'GETMOVIES', 'GETSESSIONS', 'GETSESSIONPRICES') THEN 'SESSION_AND_PRICES' WHEN el.Query_Name IN ('RESERVATION', 'RESERVATIONCLEAR', 'SALEAPPROVED', 'SALECANCEL', 'SALEPAYRETURN', 
                                                    'SALERESERVATION') THEN 'RESERV_AND_SALE' WHEN el.Query_Name IN ('GETHALLPLAN', 'GETHALLS', 'ACSGETHALLS') THEN 'HALLS' WHEN el.Query_Name IN ('GETONEDAYSESSIONSANDPRICES') 
                                                    THEN 'PLAZMA' WHEN el.Query_Name IN ('GETSTATISTICSALE', 'GETSTATINFO', 'GETADVANCEDSTATISTICSALE') THEN 'STATISTIC' ELSE 'OTHER' END AS Query_type, el.Query_Name, el.Date_Created, 
                                                    CONVERT(DATETIME, CONVERT(DATE, el.Date_Created)) AS work_date, el.Date_Last_Modified, el.Normal_Count, el.CEE_Count, el.TimeOut_Count, 
                                                    el.Normal_Count + el.CEE_Count + el.TimeOut_Count AS total_query, (CAST(el.CEE_Count AS float) + CAST(el.TimeOut_Count AS float)) / (CAST(el.Normal_Count AS float) + CAST(el.CEE_Count AS float) 
                                                    + CAST(el.TimeOut_Count AS float)) AS bad_query_ratio, el.MinTime, el.MaxTime, el.AvgTime
                          FROM            dbo.Cinema_External_Run_Logs AS el INNER JOIN
                                                    dbo.Computers AS c ON el.CompID = c.RID) AS inf
GROUP BY ComputerName, theatre_id, Version, work_date, Query_type, Query_Name

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
         Begin Table = "inf"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 341
               Right = 432
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_external_logs';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_external_logs';


GO

