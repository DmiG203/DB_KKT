-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE PROCEDURE [dbo].[GetNeedOfRunWinSAT] (
	 @IsNeedOfRun		bit OUTPUT 
	,@PC_ID				int
	,@Test_name			nvarchar(50)
	)
AS
BEGIN
	DECLARE @RunOnceEveryNDays	int;
	DECLARE @ExistsID			int;
	DECLARE @ExistsXml			xml;
	DECLARE @ExistsUpdateDate	smalldatetime;
	--Через сколько дней будет повторяться запуск WinSAT.
	SET @RunOnceEveryNDays = 14;
	--По умолчанию возвращаем FALSE
	SET @IsNeedOfRun = 0;

	--Проверяем сходные данные
	IF (@PC_ID IS NOT NULL) AND (@Test_name IS NOT NULL)
		BEGIN
			--Получаем ID записи
			SET @ExistsID = (SELECT ID FROM WinSAT WHERE PC_ID = @PC_ID AND Test_name = @Test_name);
			--Если записи нет
			IF @ExistsID IS NULL
				BEGIN
					--Возвращаем TRUE
					SET @IsNeedOfRun = 1;
				END;
			--Если запись есть
			ELSE
				BEGIN
					--Получаем xml для ее проверки
					SET @ExistsXml = (SELECT Result_xml FROM WinSAT WHERE ID = @ExistsID);
					--Если xml пуста, то в предыдущий раз была ошибка и нужно повторить запуск
					IF @ExistsXml IS NULL
						BEGIN
							--Возвращаем TRUE
							SET @IsNeedOfRun = 1;
						END;
					--Если xml не пустая
					ELSE
						BEGIN
							--Получаем дату обновления записи
							SET @ExistsUpdateDate = (SELECT Update_date FROM WinSAT WHERE ID = @ExistsID);
							--Если разница в днях превышает или равна установленному порогу
							IF DATEDIFF(day, CAST(@ExistsUpdateDate as DATE), CAST(GETDATE() as DATE)) >= @RunOnceEveryNDays
								BEGIN
									--Возвращаем TRUE
									SET @IsNeedOfRun = 1;
								END;
							--Если разница в днях не превышает или не равна установленному порогу
							ELSE
								BEGIN
									--Возвращаем FALSE
									SET @IsNeedOfRun = 0;
								END;
						END;
				END;
		END;
END
GO

