-- 1. Покажи мне список банков у которых есть филиалы в городе X (выбери один из городов)
GO
USE BankDb;
GO

DECLARE @CityName NVARCHAR(50) = 'City1'

SELECT b.bankName 
FROM Branches br
JOIN Banks b ON br.bankId = b.id
JOIN Cities c ON br.cityId = c.id
WHERE c.cityName = @CityName

GO
