CREATE PROCEDURE [dbo].[GetCommentID]
	   @Comment nvarchar(MAX)
	  ,@CommentID int output
    ,@TableID int
AS
  Begin
    If not EXISTS (select RID from Comments where Comment = @Comment and TableID = @TableID) 
      BEGIN
        Insert Into Comments ([Comment], [TableID]) Values ( @CommentID, @TableID);
      END
    Set @CommentID = (select RID from Comments where Comment = @Comment and TableID = @TableID)
  End;
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[GetCommentID] TO [cash]
    AS [dbo];
GO

