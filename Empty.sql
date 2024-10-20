GO
USE BankDb;
GO

INSERT INTO SocialStatuses (statusName) VALUES
('Student'),
('Employed'),
('Unemployed'),
('Retired'),
('Disabled');

INSERT INTO Banks (bankName) VALUES
('Bank1'),
('Bank2'),
('Bank3'),
('Bank4'),
('Bank5');

INSERT INTO Cities (cityName) VALUES
('City1'),
('City2'),
('City3'),
('City4'),
('City5');

INSERT INTO Branches (bankId, cityId, address) VALUES
(1, 1, '1 Main St'),
(1, 2, '2 Branch St'),
(2, 1, '3 Silver St'),
(3, 3, '4 Waltuh St'),
(4, 4, '5 Senior St');

INSERT INTO Clients (socialStatusId, fullName) VALUES
(1, 'Ivan1'),
(2, 'Ivan2'),
(3, 'Ivan3'),
(4, 'Ivan4'),
(5, 'Ivan5');

INSERT INTO Accounts (bankId, clientId, balance) VALUES
(1, 1, 1000.00),
(1, 2, 2500.50),
(2, 3, 500.75),
(3, 4, 1500.00),
(4, 5, 3000.25);

INSERT INTO Cards (accountId, number, expirationDate, balance) VALUES
(1, '1234567812345678', '2025-12-31', 1000.00),
(2, '8765432187654321', '2024-11-30', 2500.50),
(3, '5678123456781234', '2026-01-15', 500.75),
(4, '4321876543218765', '2025-06-30', 1300.00),
(5, '8765123487651234', '2027-09-20', 2900.25);

GO
