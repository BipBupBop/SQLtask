-- 4. Вывести кол-во банковских карточек для каждого соц статуса (2 реализации, GROUP BY и подзапросом)
GO
USE BankDb;
GO

SELECT ss.statusName, COUNT(c.id) AS cardCount
FROM SocialStatuses ss
JOIN Clients cl ON ss.id = cl.socialStatusId
JOIN Accounts a ON cl.id = a.clientId
JOIN Cards c ON a.id = c.accountId
GROUP BY ss.statusName;

GO

SELECT ss.statusName, 
       (SELECT COUNT(c.id)
        FROM Clients cl
        JOIN Accounts a ON cl.id = a.clientId
        JOIN Cards c ON a.id = c.accountId
        WHERE cl.socialStatusId = ss.id) AS cardCount
FROM SocialStatuses ss;

GO
