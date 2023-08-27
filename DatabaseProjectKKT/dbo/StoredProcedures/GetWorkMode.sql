
CREATE procedure [dbo].[GetWorkMode] (
	   @RepRegID int
	  ,@WorkMode int output
	  ,@BeforeWorkMode int output
	  )
AS
Begin
	DECLARE  @kkmID int
			,@LastFnID int
	Set @WorkMode = (select WorkMode from RepReg where rid = @RepRegID)
	Set @LastFnID = (select RepReg.fnID from RepReg where RepReg.rid = @RepRegID)
	Set @BeforeWorkMode = 
		(
		select TOP(1) RepReg.WorkMode
		from fn 
		left join RepReg on fn.rid = RepReg.fnID
		where fn.kktID = (select kktid from fn where rid = @LastFnID) 
		and fn.rid != @LastFnID
		and RepReg.RepTypeID != 3
		order by  RepReg.DateRep DESC
		)
End;

GO

