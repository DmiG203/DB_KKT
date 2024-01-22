
CREATE procedure [dbo].[GetAddsID] (
	   @adds nvarchar(MAX)
	  ,@addsID int output
)
AS
Begin
	Set @addsID = (select rid from adds where adds = @adds)

	If @addsID is null and @adds is not null
		Begin
			Insert Into adds ([adds]) Values ( @adds);
			Set  @addsID = (select rid from adds where adds = @adds)
		End;

End;

GO


GRANT EXECUTE
    ON OBJECT::[dbo].[GetAddsID] TO [cash]
    AS [dbo];
GO

