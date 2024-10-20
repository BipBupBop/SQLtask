-- Должен выводить ошибку "Account balance cannot be less than the total card balances."

GO
USE BankDb;
GO

UPDATE Accounts SET balance = 1 WHERE id = 1;

GO
