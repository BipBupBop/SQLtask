-- 3. Показать список банковских аккаунтов у которых баланс не совпадает 
-- с суммой баланса по карточкам. В отдельной колонке вывести разницу
GO
USE BankDb;
GO

SELECT a.id AS accountId, a.balance, 
       COALESCE(SUM(c.balance), 0) AS cardBalanceSum,
       a.balance - COALESCE(SUM(c.balance), 0) AS difference
FROM Accounts a
LEFT JOIN Cards c ON a.id = c.accountId
GROUP BY a.id, a.balance
HAVING a.balance != COALESCE(SUM(c.balance), 0);

GO
