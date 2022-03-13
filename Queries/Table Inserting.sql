USE gamelounge;
-- 1 Hire
INSERT INTO mployee (Ename,Esalary) values ('Ali Yaghi',1000);
SELECT * FROM Employee;
-- 2 Fire
DELETE FROM Employee WHERE Eid=1;
 SELECT * FROM Employee;
 -- 3 Raise
 UPDATE Employee
 SET Esalary=Esalary+200
 WHERE Eid=1;
 -- 4 demote
 UPDATE Employee
 SET Esalary=Esalary-200
 WHERE Eid=1;
 -- 5 Add customer
 INSERT INTO Customers (Cname,Cgender,Cbirthday)
 VALUES ('Ali Yaghi','M','1999-03-21');
 
 -- 6 Delete Customer
 DELETE FROM Customers
 WHERE Cid=1;
 
 -- 7 Create Account
 INSERT INTO Accounts (Username,Pass,Abudget,Cid)
 VALUES ('yagi','123',100,1);
 
 -- 8 Delete Account
 DELETE FROM Accounts
 WHERE Aid=1;
 
 -- 9 Add Device
 INSERT INTO Device (Eid,Dtype)
 VALUES (1,'Pc');
 INSERT IGNORE INTO devicetype(Dprice,Dtype,Dcharge) VALUES (2,'Pc',0.25);
 -- 10 delete Device
 
DELETE FROM Device
 WHERE Did=1;

-- 11 Add Game
INSERT INTO Game (Gname,Gdeveloper)
 VALUES ('GTA 5','Rockstar Games');
INSERT INTO GameComp (Gname,Dtype)
 VALUES ('GTA 5','Pc');
 
-- 12 Delete Game

DELETE FROM Game
 WHERE Gname='GTA 5';
 DELETE FROM GameComp
 WHERE Gname = 'GTA 5';
 
 -- 13 make a purchase header
 INSERT IGNORE INTO Suppliers (Sname,Stransaction)
 VALUES ('Ghandour',0);
  INSERT INTO Purchases_Header (TotalCost,PurchaseDate,Sname)
  VALUES (0,Current_date(),'Ghanour');
  
 -- 15 purchase item
 
 INSERT INTO Purchases_Details (Phid,CostPerItem,ExpiryDate,ItemQty,ItemName)
 VALUES (1,1,'2022-06-13',20,'UNICA');
 UPDATE Purchases_Header
 Set TotalCost=(TotalCost + 20) WHERE phid=1;
 UPDATE Suppliers SET Stransaction=(Stransaction + 20)
 WHERE Sname= (SELECT Sname From Purchases_Header
				Where Phid=1);
INSERT INTO Food (Pdid,FqtyLeft,FexpiryDate,Fprice,Fname)
 VALUES ((SELECT Max(Pdid) FROM Purchases_Details),20,'2022-06-13',1,'UNICA'); 
 
 -- 16 Add food in case no pricing
 
 INSERT INTO Food (Pdid,FqtyLeft,FexpiryDate,Fprice,Fname)
 VALUES (1,20,'2022-06-13',1,'UNICA');
 
 -- 17 buy Foods
 INSERT INTO Bills (Bdate,Bprice,Aid) 
	VALUES (current_date(),0,1);
 INSERT INTO Items (itemname,Bid,itemType,Qty,Aid,Itemprice)
 VALUES ('Unica',1,'Food',3,1,1);
 
 
 -- 18 Play
INSERT INTO Items (itemname,Bid,itemType,Qty,Aid,Itemprice)
 VALUES ('Valorant',1,'Game',3,1,(SELECT Dprice FROM Devicetype WHERE Dtype='Pc'));
 
 INSERT INTO PLAYING (Start_time,End_Time,Did,Gname,Aid,Eid,Earning)
		VALUES('13:00',null,1,'Valorant',1,1,10);