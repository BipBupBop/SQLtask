-- 5. Написать stored procedure которая будет добавлять по 10$ на каждый 
-- банковский аккаунт для определенного соц статуса (У каждого клиента бывают
-- разные соц. статусы. Например, пенсионер, инвалид и прочее). Входной
-- параметр процедуры - Id социального статуса. Обработать исключительные
-- ситуации (например, был введен неверные номер соц. статуса. Либо когда
-- у этого статуса нет привязанных аккаунтов).

GO
USE BankDb;
GO

CREATE PROCEDURE AddBonusToAccountsBySocialStatus
    @SocialStatusId INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SocialStatuses WHERE id = @SocialStatusId)
        BEGIN
            RAISERROR ('Invalid social status ID.', 16, 1);
            RETURN;
        END

        UPDATE a
        SET a.balance = a.balance + 10
        FROM Accounts a
        JOIN Clients cl ON a.clientId = cl.id
        WHERE cl.socialStatusId = @SocialStatusId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('No accounts found for the specified social status.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        -- Обработка ошибок
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
