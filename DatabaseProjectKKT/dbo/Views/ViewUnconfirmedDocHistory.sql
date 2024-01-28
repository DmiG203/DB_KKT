/*
SELECT	dbo.Org.RID AS OrgID, 
		dbo.Org.NumOP, 
		dbo.Computers.RID AS CompID, 
		dbo.Computers.ComputerName, 
		dbo.Kkm.RID AS KkmID,
		dbo.Kkm.SN AS KkmSn, 
		dbo.Kkm.ModelID AS KkmModelID, 
		dbo.KkmModel.Name AS KkmModel,
		dbo.Kkm.Deleted AS kkmDeleted, 
		dbo.Kkm.SoftVer, 
		dbo.Kkm.LoaderVersion, 
		dbo.Kkm.MAC, 
		dbo.Fn.RID AS FnID, 
		dbo.Fn.SN AS FnSn, 
		dbo.Fn.ModelID AS FnModelID, 
		dbo.FnModel.Name AS FnModel, 
		dbo.Fn.Status,
		dbo.Fn.DateExpired, 
		dbo.Kkm.WorkMode, 
		dbo.RepReg.WorkModeEx, 
		dbo.RepReg.FFD AS KkmFFD, 
		dbo.Fn.LastDocNum, 
		dbo.Fn.LastDocDate, 
		dbo.LocKkm.ComPort, 
		dbo.LocKkm.ComBaudRate, 
		dbo.Computers.ShtrihDrvVer,
		dbo.Computers.AtolDrvVer, 
		dbo.RepReg.WorkMode AS WokModeFromRepReg, 
		dbo.Kkm.RNDIS, 
		dbo.Kkm.IpAddress, 
		dbo.Kkm.IpPort, 
		dbo.Computers.LastStart, 
		--UnDoc.UnconfirmedDoc,
		(SELECT FnDocs.UnconfirmedDoc FROM FnDocs
		WHERE Type = 2 AND
		FnID = Fn.RID AND
		AddDate = 
			(SELECT MAX(AddDate) 
			FROM FnDocs 
			WHERE	FnID = Fn.RID
			AND		Type = 2)
		) as UnconfirmedDoc
FROM	dbo.Kkm 
		LEFT OUTER JOIN dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID 
		LEFT OUTER JOIN dbo.Fn ON dbo.Kkm.RID = dbo.Fn.KktID AND dbo.Fn.Status < 2 
		LEFT OUTER JOIN dbo.RepReg ON dbo.RepReg.FnID = dbo.Fn.RID AND dbo.RepReg.RID =
                             (SELECT        TOP (1) RID
                               FROM            dbo.RepReg AS RepReg2
                               WHERE        (FnID = dbo.Fn.RID)
                               ORDER BY DateRep DESC) 
		LEFT OUTER JOIN dbo.FnModel ON dbo.FnModel.RID = dbo.Fn.ModelID 
		LEFT OUTER JOIN dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND
                             (SELECT        TOP (1) RID
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)
                               ORDER BY AddDate DESC) = dbo.LocKkm.RID 
		LEFT OUTER JOIN dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID 
		LEFT OUTER JOIN dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID 
		--LEFT OUTER JOIN dbo.FnDocs AS UnDoc ON dbo.Fn.RID = UnDoc.FnID AND UnDoc.Type = 2
WHERE  dbo.Kkm.SN = '0305810012087726' and dbo.Kkm.Deleted = 0


Select 


SELECT * FROM FnDocs
Where Type = 2 AND
FnID = 6390 AND
AddDate = 

(SELECT MAX(AddDate) 
FROM FnDocs 
WHERE	FnID = 6390
AND		Type = 2)


--update FnDocs set SourceID = 1 where SourceID is null
*/
CREATE VIEW dbo.ViewUnconfirmedDocHistory
AS
SELECT        dbo.Org.RID AS OrgID, dbo.Org.NumOP, dbo.Computers.RID AS CompID, dbo.Computers.ComputerName, dbo.Kkm.RID AS KkmID, dbo.Kkm.SN AS KkmSn, dbo.Kkm.ModelID AS KkmModelID, dbo.KkmModel.Name AS KkmModel, 
                         dbo.Kkm.Deleted AS kkmDeleted, dbo.Kkm.SoftVer, dbo.Fn.RID AS FnID, dbo.Fn.SN AS FnSn, dbo.Fn.ModelID AS FnModelID, dbo.FnModel.Name AS FnModel, dbo.Kkm.WorkMode, dbo.LocKkm.ComPort, 
                         dbo.LocKkm.ComBaudRate, dbo.Kkm.RNDIS, dbo.Kkm.IpAddress, dbo.Kkm.IpPort, dbo.Computers.LastStart, UnDoc.UnconfirmedDoc, UnDoc.AddDate, dbo.Kkm.MAC
FROM            dbo.Kkm LEFT OUTER JOIN
                         dbo.KkmModel ON dbo.Kkm.ModelID = dbo.KkmModel.RID LEFT OUTER JOIN
                         dbo.Fn ON dbo.Kkm.RID = dbo.Fn.KktID AND dbo.Fn.Status < 2 LEFT OUTER JOIN
                         dbo.FnModel ON dbo.FnModel.RID = dbo.Fn.ModelID LEFT OUTER JOIN
                         dbo.LocKkm ON dbo.Kkm.RID = dbo.LocKkm.KkmID AND
                             (SELECT        MAX(RID) AS Expr1
                               FROM            dbo.LocKkm AS lockkm2
                               WHERE        (KkmID = dbo.Kkm.RID)) = dbo.LocKkm.RID LEFT OUTER JOIN
                         dbo.Computers ON dbo.LocKkm.CompID = dbo.Computers.RID LEFT OUTER JOIN
                         dbo.Org ON dbo.Computers.OrgID = dbo.Org.RID INNER JOIN
                         dbo.FnDocs AS UnDoc ON UnDoc.Type = 2 AND UnDoc.FnID = dbo.Fn.RID
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewUnconfirmedDocHistory';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[20] 2[23] 3) )"
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
               Top = 101
               Left = 636
               Bottom = 356
               Right = 810
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "KkmModel"
            Begin Extent = 
               Top = 279
               Left = 871
               Bottom = 392
               Right = 1045
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Fn"
            Begin Extent = 
               Top = 143
               Left = 873
               Bottom = 273
               Right = 1053
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FnModel"
            Begin Extent = 
               Top = 143
               Left = 1090
               Bottom = 273
               Right = 1264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocKkm"
            Begin Extent = 
               Top = 101
               Left = 412
               Bottom = 354
               Right = 586
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Computers"
            Begin Extent = 
               Top = 100
               Left = 205
               Bottom = 354
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Org"
            Begin Extent = 
               Top = 100
               Left = 0
               Bottom = 352
               Right = 174
            End
            DisplayFlags = 280
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewUnconfirmedDocHistory';
GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'           TopColumn = 0
         End
         Begin Table = "UnDoc"
            Begin Extent = 
               Top = 0
               Left = 871
               Bottom = 130
               Right = 1051
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
      Begin ColumnWidths = 31
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ViewUnconfirmedDocHistory';
GO

