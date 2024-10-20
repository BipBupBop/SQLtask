-- 6. Получить список доступных средств для каждого клиента. 
-- То есть если у клиента на банковском аккаунте 60 рублей, и
-- у него 2 карточки по 15 рублей на каждой, то у него доступно
-- 30 рублей для перевода на любую из карт

-- Если я правильно понял суть задания, доступные для "перевода
-- на любую из карт" средства - это те, которые не находятся
-- ни на одной из карт. 

GO
USE BankDb;
GO

SELECT 
    cl.fullName AS clientName,
    a.id AS accountId,
    a.balance AS accountBalance,
    COALESCE(SUM(c.balance), 0) AS totalCardBalance,
    COALESCE(a.balance - SUM(c.balance), 0) AS availableFunds
FROM Clients cl
JOIN Accounts a ON cl.id = a.clientId
LEFT JOIN Cards c ON a.id = c.accountId
GROUP BY cl.fullName, a.id, a.balance;

GO
