-- 7. Написать процедуру которая будет переводить определённую
-- сумму со счёта на карту этого аккаунта.  При этом будем считать
-- что деньги на счёту все равно останутся, просто сумма средств
-- на карте увеличится. Например, у меня есть аккаунт на котором
-- 1000 рублей и две карты по 300 рублей на каждой. Я могу 
-- перевести 200 рублей на одну из карт, при этом баланс аккаунта
-- останется 1000 рублей, а на картах будут суммы 300 и 500 рублей
-- соответственно. После этого я уже не смогу перевести 400 рублей
-- с аккаунта ни на одну из карт, так как останется всего 200 
-- свободных рублей (1000-300-500). Переводить БЕЗОПАСНО. То есть
-- использовать транзакцию

GO
USE BankDb;
GO

CREATE PROCEDURE TransferToCard
    @AccountId INT,
    @CardId INT,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Accounts WHERE id = @AccountId)
        BEGIN
            RAISERROR ('Invalid account ID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Cards WHERE id = @CardId AND accountId = @AccountId)
        BEGIN
            RAISERROR ('Invalid card ID or card does not belong to the specified account.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @TotalCardBalance DECIMAL(18, 2);
        SELECT @TotalCardBalance = COALESCE(SUM(balance), 0)
        FROM Cards
        WHERE accountId = @AccountId;

        DECLARE @AccountBalance DECIMAL(18, 2);
        SELECT @AccountBalance = balance FROM Accounts WHERE id = @AccountId;

        IF @AccountBalance < @TotalCardBalance + @Amount OR @Amount < 0
        BEGIN
            RAISERROR ('Insufficient available funds for transfer or negative amount inputted.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE Cards
        SET balance = balance + @Amount
        WHERE id = @CardId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        ROLLBACK TRANSACTION;
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
