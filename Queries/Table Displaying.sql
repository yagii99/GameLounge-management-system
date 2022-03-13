USE gamelounge;
-- 1 Display All Employee
SELECT * FROM Employee;

-- 2 Display All Customers
SELECT * FROM Customers C;

-- 3 Display All customers with Accounts
SELECT C.Cid,Cname,Cgender,Cbirthday,SUM(Abudget) AS budget
 FROM Customers C, Accounts A
 WHERE C.Cid = A.Cid GROUP BY C.Cid;
 
 -- 4 Display All Customer with negative Budgets
 
 SELECT C.Cid,Cname,Cgender,Cbirthday,SUM(Abudget) AS budget
 FROM Customers C, Accounts A
 WHERE C.Cid = A.Cid AND(SELECT SUM(Abudget)
						FROM Accounts A1 WHERE C.Cid = A1.Cid) < 0
GROUP BY C.Cid;

-- 5 Display All Accounts

SELECT Aid,username,Abudget,Cid FROM Accounts;

-- 6 Display Busy Devices
SELECT * FROM Device D
 WHERE EXISTS(SELECT * FROM Playing P WHERE D.did = P.did AND P.End_Time = NULL);
 
 -- 7 Display Available Devices
 SELECT * FROM Device D
 WHERE NOT EXISTS(SELECT * FROM laying P WHERE D.did = P.did);
 
 -- 8 Display Games Compatible with specific device
 SELECT * FROM Game G
 WHERE EXISTS (SELECT * FROM GameComp GC WHERE G.Gname = GC.Gname AND GC.Dtype='Pc');
 
 -- 9 Display Games by developer X
 SELECT * FROM Game G
 WHERE G.Gdeveloper='Rockstar Games';
 
 -- 10 Display Most Played Games
 
 SELECT* FROM Game 
 WHERE time_played = (Select Max(time_played) FROM Game)
 GROUP BY Gname;
 
 -- 11 Display Games Ordered
 
 SELECT * FROM Game
 ORDER BY time_played DESC;
 
 -- 12 Display all purchases ordered
 SELECT * FROM Purchases_Header
 ORDER BY PurchaseDate DESC;
 
 -- 13 Display Suppliers
 
 SELECT * FROM Suppliers;
 -- 14 Display All purchases by one header id
 SELECT * FROM Purchases_Details WHERE Phid=1;
 
 -- 15 Display all available foods
 
 SELECT * FROM Food
 WHERE Fqtyleft > 0;
 
 -- 16 Display Foods with expiry duration <30
 SELECT * FROM Food
 WHERE datediff(Fexpirydate, (SELECT current_date())) < 30;
 
 -- 17 Display profit from selling foods
SELECT SUM(Itemprice) AS profit_from_foods
FROM Items
WHERE Itemtype = 'Food';

-- 18 Display profit from playing games
SELECT SUM(Itemprice*Qty) AS Profit_from_games
FROM Items
WHERE Itemtype = 'Game';

-- 19 Display profit made by customer
SELECT SUM(Bprice) AS profit_by_customer
FROM Bills JOIN (SELECT Aid FROM Accounts WHERE Cid = 1) AS Acc;

SELECT * FROM Bills;
-- 20 Display Profit generally by month
SELECT SUM(B.Bprice) - SUM(E.Esalary) AS profit
FROM Bills B,Employee E
WHERE datediff(B.bdate,(SELECT Current_date())) <= 30;
 
 -- 21 Display most bought foods
 
 SELECT ItemName,COUNT(ItemName)
 FROM PURCHASES_details
 GROUP BY ItemName ORDER BY COUNT(ItemName) DESC;
 