-- 2. Получить список карточек с указанием имени владельца, баланса и названия банка
GO
USE BankDb;
GO

SELECT c.number AS cardNumber, 
cl.fullName AS ownerName, 
a.balance, 
b.bankName
FROM Cards c
JOIN Accounts a ON c.accountId = a.id
JOIN Clients cl ON a.clientId = cl.id
JOIN Banks b ON a.bankId = b.id;

GO
