-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddWinSAT] (
	 @ReturnID			int OUTPUT 
	,@PC_ID				int	
	,@Test_name			nvarchar(50)
	,@Resul_xml			xml				= null
	,@Error				nvarchar(MAX)	= null
	)
AS
BEGIN
	DECLARE @Update_date smalldatetime;
	--Проверяем наличие ID компьюетра
	IF (@PC_ID IS NOT NULL) AND (@Test_name IS NOT NULL)
		BEGIN
			--Проверяем наличие входной инфы по тестам
			IF (@Resul_xml IS NOT NULL)
				BEGIN
					--Получаем ID имеющейся записи
					SET @ReturnID = (SELECT ID FROM WinSAT WHERE PC_ID = @PC_ID AND Test_name = @Test_name);
					--Если записи нет
					IF @ReturnID IS NULL
						BEGIN
							--Добавляем запись
							INSERT INTO WinSAT (PC_ID, Test_name, Result_xml, Error, Add_date, Update_date)
										VALUES (@PC_ID, @Test_name, @Resul_xml, @Error, GETDATE(), GETDATE())
							--Получем ID новой записи
							SET @ReturnID = (SELECT ID FROM WinSAT WHERE PC_ID = @PC_ID AND Test_name = @Test_name);
						END;
					--Если запись есть
					ELSE
						BEGIN
							--Обновляем ее
							UPDATE WinSAT SET Result_xml = @Resul_xml, Error = @Error, Update_date = GETDATE()
										WHERE ID = @ReturnID;
						END;
				END;
			--Если инфы по тестам нет
			ELSE
				BEGIN
					--Проверяем наличие сообщения об ошибки
					IF @Error IS NOT NULL
						BEGIN
							--Получаем ID имеющейся записи
							SET @ReturnID = (SELECT ID FROM WinSAT WHERE PC_ID = @PC_ID AND Test_name = @Test_name);
							--Если записи нет
							IF @ReturnID IS NULL
								BEGIN
									--Добавляем запись
									INSERT INTO WinSAT (PC_ID, Test_name, Result_xml, Error, Add_date, Update_date)
												VALUES (@PC_ID, @Test_name, @Resul_xml, @Error, GETDATE(), GETDATE())
									--Получем ID новой записи
									SET	 @ReturnID = (SELECT ID FROM WinSAT WHERE PC_ID = @PC_ID AND Test_name = @Test_name);
								END;
							--Если запись есть
							ELSE
								BEGIN
									--Обновляем ее
									UPDATE WinSAT SET Error = @Error, Update_date = GETDATE()
												WHERE ID = @ReturnID;
								END;
							
						END;
					ELSE
						BEGIN
							SET @ReturnID = 0;
							RETURN 0;
						END;
				END;
		END;
	ELSE
		BEGIN
			SET @ReturnID = 0;
			RETURN 0;
		END;

END;
GO

