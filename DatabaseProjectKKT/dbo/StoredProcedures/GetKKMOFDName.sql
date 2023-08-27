/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
CREATE PROCEDURE [dbo].[GetKKMOFDName](
		 @SnKkm nvarchar(MAX)
		,@OFDName nvarchar(15) = null OUTPUT
		,@NumOP int = null OUTPUT
		,@INN char(10) = null OUTPUT
		)
As
Begin

Set @OFDName = (
SELECT TOP(1)
      IIF (CHARINDEX('-', [ComputerName])>0,
	        IIF ((kkmModelID = 3 or kkmModelID = 4),'', 'FR') +
			left([ComputerName], CHARINDEX('-', [ComputerName])-1) +
			IIF (WorkMode / 24 > 0, 'S','G') +
			IIF ([ComputerName] like 'BAR%' or [ComputerName] like 'cash%' or [ComputerName] like 'self%', '-' + FORMAT(cast(REPLACE(SUBSTRING([ComputerName], charindex('-', [ComputerName]) +1, 2),'-','') as int),'00'), '') +
			'-' +
			FORMAT([NumOP], '000')
	  ,null
	  ) as OFDName
  FROM [KKT].[dbo].[GetKkmList]
  where kkmDeleted = 0 and fnsn is not null
  and kkmsn = @SnKkm
  order by KkmID desc, FnID desc
)
Set @NumOP = (
SELECT TOP (1) [NumOP]
  FROM [KKT].[dbo].[GetLocKKM]
  where sn = @SnKkm
  order by rid desc
)
Set @INN = (
Select TOP(1) INN from Org where NUmOP = @NumOP
)
End

GO

