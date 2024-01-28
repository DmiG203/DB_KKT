CREATE PROCEDURE [dbo].[MoveUnDoc]
AS
  insert into FnDocs (FnID, DocDate, DocNum, UpdateDate, AddDate, Type)
						select	rid, LastDocDate, LastDocNum, UpdateDate, GETDATE(), 1
						from	FN 
						where LastDocNum is not null
  
  update fn set LastDocDate = null, LastDocNum = null where RID in (select FnID from FnDocs where Type = 1 group by FnID )

  --SELECT @param1, @param2
RETURN 0
