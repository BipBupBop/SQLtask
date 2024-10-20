-- 8. Написать триггер на таблицы Account/Cards чтобы нельзя
-- было занести значения в поле баланс если это противоречит условиям
-- (то есть нельзя изменить значение в Account на меньшее, чем сумма
-- балансов по всем карточкам. И соответственно нельзя изменить
-- баланс карты если в итоге сумма на картах будет больше чем 
-- баланс аккаунта)

GO
USE BankDb;
GO

CREATE TRIGGER CheckAccountBalance
ON Accounts
AFTER UPDATE
AS
BEGIN
    DECLARE @AccountId INT, @NewBalance DECIMAL(18, 2);

    SELECT @AccountId = inserted.id, @NewBalance = inserted.balance
    FROM inserted;

    DECLARE @TotalCardBalance DECIMAL(18, 2);
    SELECT @TotalCardBalance = COALESCE(SUM(balance), 0)
    FROM Cards
    WHERE accountId = @AccountId;

    IF @NewBalance < @TotalCardBalance
    BEGIN
        RAISERROR ('Account balance cannot be less than the total card balances.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER CheckCardBalance
ON Cards
AFTER UPDATE
AS
BEGIN
    DECLARE @CardId INT, @AccountId INT, @NewCardBalance DECIMAL(18, 2);

    SELECT @CardId = inserted.id, @NewCardBalance = inserted.balance, @AccountId = inserted.accountId
    FROM inserted;

    DECLARE @AccountBalance DECIMAL(18, 2);
    SELECT @AccountBalance = balance
    FROM Accounts
    WHERE id = @AccountId;

    DECLARE @TotalCardBalance DECIMAL(18, 2);
    SELECT @TotalCardBalance = COALESCE(SUM(balance), 0)
    FROM Cards
    WHERE accountId = @AccountId AND id != @CardId;

    SET @TotalCardBalance = @TotalCardBalance + @NewCardBalance;

    IF @TotalCardBalance > @AccountBalance
    BEGIN
        RAISERROR ('Total card balances cannot exceed the account balance.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
