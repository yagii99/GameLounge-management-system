USE gamelounge;

ALTER TABLE Accounts
	ADD CONSTRAINT Accounts_Customers
		FOREIGN KEY (Cid)
        REFERENCES Customers (Cid)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE Bills
	ADD CONSTRAINT Bills_Accounts
		FOREIGN KEY (Aid)
        REFERENCES Accounts (Aid)
        ON DELETE NO ACTION
        ON UPDATE CASCADE;
        
ALTER TABLE Device
	ADD CONSTRAINT Device_Employee
		FOREIGN KEY (Eid)
        REFERENCES Employee (Eid)
        ON DELETE NO ACTION
        ON UPDATE CASCADE;
        
ALTER TABLE Food
	ADD CONSTRAINT Food_Purchases_Details
		FOREIGN KEY (Pdid)
        REFERENCES Purchases_Details (Pdid)
        ON DELETE NO ACTION
        ON UPDATE CASCADE;
        
ALTER TABLE FoodComp
	ADD CONSTRAINT FoodComp_DeviceType
		FOREIGN KEY (Dtype)
        REFERENCES DeviceType (Dtype)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	ADD CONSTRAINT FoodComp_Food
		FOREIGN KEY (Fname)
        REFERENCES Food (Fname)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
        
ALTER TABLE GameComp
	ADD CONSTRAINT GameComp_DeviceType
		FOREIGN KEY (Dtype)
        REFERENCES DeviceType (Dtype)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	ADD CONSTRAINT GameComp_Game
		FOREIGN KEY (Gname)
        REFERENCES Game (Gname)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
        
ALTER TABLE Items
	ADD CONSTRAINT Items_Bills
		FOREIGN KEY (Bid)
        REFERENCES Bills (Bid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	ADD CONSTRAINT Items_Accounts
		FOREIGN KEY (Aid)
	REFERENCES Accounts (Aid)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
        
ALTER TABLE Playing
	ADD CONSTRAINT Playing_Device
		FOREIGN KEY (Did)
        REFERENCES Device (Did)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	ADD CONSTRAINT Playing_Game
		FOREIGN KEY (Gname)
        REFERENCES Game (Gname)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	ADD CONSTRAINT Playing_Accounts
		FOREIGN KEY (Aid)
        REFERENCES Accounts (Aid)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
        
ALTER TABLE Purchases_Details
	ADD CONSTRAINT Purchases_Details_Purchases_Header
		FOREIGN KEY (Phid)
        REFERENCES Purchases_Header (Phid)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
        
ALTER TABLE Purchases_Header
	ADD CONSTRAINT Purchases_Header_Suppliers
		FOREIGN KEY (Sname)
        REFERENCES Suppliers (Sname)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
        
DROP TRIGGER Item_insert;

DELIMITER $$
CREATE TRIGGER Item_Insert
BEFORE INSERT ON items
FOR EACH ROW
BEGIN
IF new.Qty> (SELECT Fqtyleft FROM Food WHERE new.itemname=Fname) AND NOT EXISTS (SELECT * FROM Game WHERE new.Itemname=Gname)
THEN
SIGNAL sqlstate '45001' set message_text = "Cannot Complete this process!";
ELSE IF new.itemtype='Food'
THEN
UPDATE Food
SET Fqtyleft=Fqtyleft-new.Qty
WHERE new.itemname=Fname;
UPDATE Accounts
SET Abudget = Abudget - new.Itemprice*new.Qty
WHERE new.Aid=Aid;
INSERT INTO Bills(Bdate,Aid,Bprice)
	VALUES(Current_date(),new.Aid,new.Itemprice*new.Qty)
    ON DUPLICATE KEY UPDATE
    Bprice=Bprice+new.Itemprice*new.Qty;
ELSE
INSERT INTO Bills(Bid,Bdate,Aid,Bprice)
	VALUES(new.Bid,Current_date(),new.Aid,new.Itemprice*new.Qty)
    ON DUPLICATE KEY UPDATE
    Bprice=Bprice+new.Itemprice*new.Qty;
END IF;
END IF;
END $$
DELIMITER ;
