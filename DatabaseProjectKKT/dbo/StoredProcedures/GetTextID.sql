
CREATE procedure [dbo].[GetTextID] (
	   @text nvarchar(MAX)
	  ,@textID int output
)
AS
Begin
	Set @textID = (select [rid] from textTable where [text] = @text)

	If @textID is null and @text is not null
		Begin
			Insert Into textTable ([text]) Values ( @text);
			Set  @textID = (select rid from textTable where [text] = @text)
		End;

End;

GO

