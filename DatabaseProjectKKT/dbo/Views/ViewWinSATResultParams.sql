CREATE VIEW dbo.ViewWinSATResultParams
AS
SELECT        TOP (100) PERCENT o.NumOP, c.ComputerType AS Type, pc.IP, c.ComputerName, m.Manufacturer, m.Model, os.OS, h.CPU1 AS CPU, h.RAM, Score.PC_ID, Score.Cpu_count, Score.Cpu_cores, Score.Cpu_threads, 
                         Score.Cpu_per_core, Score.Cpu_frequency, Score.Cpu_cores_are_threaded, Score.Cpu_score, Score.Cpu_sub_agg_score, Score.Video_encode_score, Score.Memory_bandwidth, Score.Memory_total_size, 
                         Score.Memory_score, Score.Disk_SR_score, Score.Disk_RR_score, Score.Disk_score
FROM            (SELECT        PC_ID, MAX(Result_xml.value('(/WinSAT/SystemConfig/Processor/Instance/NumProcs)[1]', 'float')) AS Cpu_count, MAX(Result_xml.value('(/WinSAT/SystemConfig/Processor/Instance/NumCores)[1]', 'float')) 
                                                    AS Cpu_cores, MAX(Result_xml.value('(/WinSAT/SystemConfig/Processor/Instance/NumCPUs)[1]', 'float')) AS Cpu_threads, MAX(Result_xml.value('(/WinSAT/SystemConfig/Processor/Instance/NumCPUsPerCore)[1]', 
                                                    'float')) AS Cpu_per_core, MAX(ROUND(Result_xml.value('(/WinSAT/SystemConfig/Processor/Instance/TSCFrequency)[1]', 'float') / 1024 / 1024 / 1024, 1)) AS Cpu_frequency, 
                                                    MAX(Result_xml.value('(/WinSAT/SystemConfig/Processor/Instance/CoresAreThreaded)[1]', 'float')) AS Cpu_cores_are_threaded, MAX(Result_xml.value('(/WinSAT/WinSPR/CpuScore)[1]', 'float')) AS Cpu_score, 
                                                    MAX(Result_xml.value('(/WinSAT/WinSPR/CPUSubAggScore)[1]', 'float')) AS Cpu_sub_agg_score, MAX(Result_xml.value('(/WinSAT/WinSPR/VideoEncodeScore)[1]', 'float')) AS Video_encode_score, 
                                                    MAX(ROUND(Result_xml.value('(/WinSAT/Metrics/MemoryMetrics/Bandwidth)[1]', 'float') / 1024, 1)) AS Memory_bandwidth, MAX(ROUND(Result_xml.value('(/WinSAT/SystemConfig/Memory/TotalPhysical/Bytes)[1]', 
                                                    'float') / 1024 / 1024 / 1024, 1)) AS Memory_total_size, MAX(Result_xml.value('(/WinSAT/WinSPR/MemoryScore)[1]', 'float')) AS Memory_score, 
                                                    MAX(Result_xml.value('(/WinSAT/Metrics/DiskMetrics/AvgThroughput/@score)[1]', 'float')) AS Disk_SR_score, MAX(Result_xml.value('(/WinSAT/Metrics/DiskMetrics/AvgThroughput/@score)[2]', 'float')) 
                                                    AS Disk_RR_score, MAX(Result_xml.value('(/WinSAT/WinSPR/DiskScore)[1]', 'float')) AS Disk_score
                          FROM            dbo.WinSAT AS ws
                          GROUP BY PC_ID) AS Score INNER JOIN
                         dbo.PC_Info AS pc ON pc.ID = Score.PC_ID INNER JOIN
                         dbo.Org AS o ON o.RID = pc.OrgID INNER JOIN
                         dbo.Computers AS c ON c.RID = pc.CompID INNER JOIN
                             (SELECT        man.ID, man.PC_ID, man.Manufacturer, man.Model, man.Bios_SN, man.Add_date, man.Update_Date
                               FROM            dbo.PC_Manufacturer_Info AS man INNER JOIN
                                                             (SELECT        PC_ID, MAX(Add_date) AS add_date
                                                               FROM            dbo.PC_Manufacturer_Info AS mani
                                                               GROUP BY PC_ID) AS mt ON mt.PC_ID = man.PC_ID AND mt.add_date = man.Add_date) AS m ON m.PC_ID = pc.ID INNER JOIN
                             (SELECT        pcos1.ID, pcos1.PC_ID, pcos1.MAC, pcos1.Hostname, pcos1.OS, pcos1.Arch, pcos1.Version, pcos1.Status, pcos1.Serial_number, pcos1.Install_date, pcos1.lastBootTime, pcos1.Add_date, 
                                                         pcos1.Update_date
                               FROM            dbo.PC_OS_Info AS pcos1 INNER JOIN
                                                             (SELECT        PC_ID, MAC, MAX(Add_date) AS add_date
                                                               FROM            dbo.PC_OS_Info AS pcos
                                                               GROUP BY PC_ID, MAC) AS ost ON ost.PC_ID = pcos1.PC_ID AND ost.MAC = pcos1.MAC AND ost.add_date = pcos1.Add_date) AS os ON os.PC_ID = pc.ID INNER JOIN
                             (SELECT        pch1.ID, pch1.PC_ID, pch1.CPU1, pch1.CPU2, pch1.RAM, pch1.RAM_total_size, pch1.Add_date, pch1.Update_date
                               FROM            dbo.PC_Hardware_Info AS pch1 INNER JOIN
                                                             (SELECT        PC_ID, MAX(Add_date) AS add_date
                                                               FROM            dbo.PC_Hardware_Info AS pch
                                                               GROUP BY PC_ID) AS pct ON pct.PC_ID = pch1.PC_ID AND pct.add_date = pch1.Add_date) AS h ON h.PC_ID = pc.ID
WHERE        (pc.StatusID = 1)
ORDER BY o.NumOP, pc.IP
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
         Begin Table = "Score"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pc"
            Begin Extent = 
               Top = 6
               Left = 293
               Bottom = 136
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 6
               Left = 505
               Bottom = 136
               Right = 679
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 717
               Bottom = 136
               Right = 892
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "os"
            Begin Extent = 
               Top = 6
               Left = 1142
               Bottom = 136
               Right = 1316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "h"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 930
               Bottom = 136
               Right = 1104
            End
            DisplayFlags = 280
            TopColumn = 0
         End', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewWinSATResultParams';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'
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
         SortType = 2160
         SortOrder = 2670
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewWinSATResultParams';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewWinSATResultParams';
GO

