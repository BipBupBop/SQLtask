GO
USE BankDb;
GO

SELECT balance FROM Accounts;

GO

EXEC TransferToCard @AccountId = 1, @CardId = 1, @Amount = 60;

GO

SELECT balance FROM Accounts;
