--Student No:	c3252194
--Student Name:	Jacobus Janse van Vuren

--CREATE DATABASE TABLES

--Create the Address table
CREATE TABLE Address (
	AddressID			INT				PRIMARY KEY CHECK (AddressID > 0 AND AddressID <= 9999),
	StreetNo			VARCHAR(10)		NOT NULL,
	StreetName			VARCHAR(20)		NOT NULL,
	City				VARCHAR(15)		NOT NULL,
	State				VARCHAR(20)		NOT NULL,
	PostCode			INT				NOT NULL	CHECK (PostCode > 0 AND PostCode <= 9999)
)

--Create the BankDetails table
CREATE TABLE BankDetails (
	BankAccountID		INT				PRIMARY KEY CHECK (BankAccountID > 0 AND BankAccountID <= 9999),
	AccountNo			VARCHAR(20)		NOT NULL,
	BankName			VARCHAR(20)		NOT NULL,
	BSBNo				INT				NOT NULL	CHECK (BSBNo > 0 AND BSBNo <= 999999)
)

--Create the Staff table
CREATE TABLE Staff (
	EmployeeNo			INT				PRIMARY KEY	CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
	FirstName			VARCHAR(15)		NOT NULL,
	LastName			VARCHAR(15)		NOT NULL,
	AddressID			INT				NOT NULL	CHECK (AddressID > 0 AND AddressID <= 9999),
	ContactNo			INT				NOT NULL	CHECK (ContactNo > 0),
	TaxFileNo			INT				NOT NULL	CHECK (TaxFileNo > 0 AND TaxFileNo <= 999999999) UNIQUE,
	BankAccountID		INT				NOT NULL,	CHECK (BankAccountID > 0 AND BankAccountID <= 9999),
	Status				VARCHAR(10)		NOT NULL,
	Description			VARCHAR(150)
	FOREIGN KEY(AddressID)		REFERENCES	Address (AddressID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(BankAccountID)	REFERENCES	BankDetails (BankAccountID) ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the InstoreStaff table
CREATE TABLE InstoreStaff (
	EmployeeNo			INT				PRIMARY KEY	CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
	PaymentRate			DECIMAL(4,2)	NOT NULL,
	FOREIGN KEY(EmployeeNo)	REFERENCES	Staff (EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the DriverStaff table
CREATE TABLE DriverStaff (
	EmployeeNo			INT				PRIMARY KEY CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
	DriverLicenceNo		INT				CHECK (DriverLicenceNo > 0 AND DriverLicenceNo <= 99999999) UNIQUE,
	PaymentPerDelivery	DECIMAL(4,2)	NOT NULL,
	FOREIGN KEY(EmployeeNo)	REFERENCES	Staff (EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the Customer table
CREATE TABLE Customer (
	CustomerID			INT				PRIMARY KEY	CHECK (CustomerID > 0 AND CustomerID <= 9999),
	PhoneNo				INT				NOT NULL	CHECK (PhoneNo > 0),
	FirstName			VARCHAR(15)		NOT NULL,
	LastName			VARCHAR(15)		NOT NULL,
	AddressID			INT				NOT NULL	CHECK (AddressID > 0 AND AddressID <= 9999),
	FOREIGN KEY(AddressID)		REFERENCES	Address (AddressID) ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the DiscountProgram table
CREATE TABLE DiscountProgram (
	DiscountCode		INT				PRIMARY KEY CHECK (DiscountCode > 0 AND DiscountCode <= 999999),
	StartDate			DATE			NOT NULL,
	EndDate				DATE			NOT NULL,
	Requirements		VARCHAR(150)	NOT NULL,
	DiscountPercentage	DECIMAL(5,4)	NOT NULL	CHECK (DiscountPercentage >= 0 AND DiscountPercentage <= 1),
	Description			VARCHAR(150)	NOT NULL,
)

--Create the CustomerOrder table
CREATE TABLE CustomerOrder (
	OrderNo				INT				PRIMARY KEY CHECK (OrderNo > 0 AND OrderNo <= 99999),
	Date				DATE			NOT NULL,
	DeliveryMethod		VARCHAR(15)		NOT NULL	DEFAULT 'Pick up',
	PaymentMethod		VARCHAR(15)		NOT NULL	DEFAULT 'Cash',
	OrderTotal			DECIMAL(6,2)	NOT NULL,
	Tax					DECIMAL(4,2)	NOT NULL,
	Status				VARCHAR(15)		NOT NULL,
	PaymentApprovalNo	INT				UNIQUE CHECK (PaymentApprovalNo > 0 AND PaymentApprovalNo <= 999999),
	DiscountAmount		DECIMAL(4,2),
	SubTotal			DECIMAL(6,2)	NOT NULL,
	DiscountCode		INT				CHECK (DiscountCode > 0 AND DiscountCode <= 999999),
	FOREIGN KEY(DiscountCode) REFERENCES DiscountProgram(DiscountCode) ON UPDATE CASCADE ON DELETE NO ACTION
)

--Create the WalkinOrder table
CREATE TABLE WalkinOrder (
	OrderNo				INT				PRIMARY KEY CHECK (OrderNo > 0 AND OrderNo <= 99999),
	CustomerName		VARCHAR(50)		NOT NULL,
	FOREIGN KEY(OrderNo) REFERENCES CustomerOrder(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the PhoneOrder table
CREATE TABLE PhoneOrder (
    OrderNo					INT				PRIMARY KEY	CHECK (OrderNo > 0 AND OrderNo <= 99999),
    CustomerID				INT			    NOT NULL	CHECK (CustomerID > 0 AND CustomerID <= 9999),
	EmployeeNo				INT				NOT NULL	CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
    CustomerPhoneNo			INT				NOT NULL	CHECK (CustomerPhoneNo > 0),
	OrderVarificationStatus	VARCHAR(15)		NOT NULL	DEFAULT 'Un-varified',
	VerificationCallStart	TIME,
	VerificationCallEnd		TIME,
	FOREIGN KEY(OrderNo)	REFERENCES CustomerOrder(OrderNo)	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(EmployeeNo)	REFERENCES	Staff(EmployeeNo)		ON UPDATE NO ACTION ON DELETE NO ACTION
)

--Create the MenuItem table
CREATE TABLE MenuItem (
	ItemNo					INT				PRIMARY KEY	CHECK (ItemNo > 0 AND ItemNo <= 9999),
	Name					VARCHAR(50)		NOT NULL,
	Dscription				VARCHAR(150),
	Size					VARCHAR(10)		DEFAULT 'Medium',
	CurrentSellingPrice		DECIMAL(4,2)	NOT NULL
)

--Create the OrderMenuItem table
CREATE TABLE OrderMenuItem (
	OrderNo					INT				NOT NULL CHECK (OrderNo > 0 AND OrderNo <= 99999),
	ItemNo					INT				NOT NULL CHECK (ItemNo > 0 AND ItemNo <= 9999),
	UnitQuantity			INT				DEFAULT 1 CHECK (UnitQuantity > 0 AND UnitQuantity <= 999),
	UnitPrice				DECIMAL(6,2),
	PRIMARY KEY (OrderNo, ItemNo),
	FOREIGN KEY(OrderNo)	REFERENCES CustomerOrder(OrderNo)	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(ItemNo)		REFERENCES MenuItem(ItemNo)			ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the Ingredient table
CREATE TABLE Ingredient (
	IngredientCode				INT				PRIMARY KEY CHECK (IngredientCode > 0 AND IngredientCode <= 9999),
	Name						VARCHAR(50)		NOT NULL,
	Type						VARCHAR(10)		NOT NULL,
	Description					VARCHAR(150),
	StockLevelAtCurrentPeriod	VARCHAR(10)		NOT NULL,
	DateLastStocktakeWasTaken	DATE			NOT NULL,
	StockLevelAtLastStocktake	VARCHAR(10)		NOT NULL,
	SuggestedStockLevel			VARCHAR(10)		NOT NULL
)

--Create the MenuItemIngredient table
CREATE TABLE MenuItemIngredient (
	ItemNo					INT				NOT NULL CHECK (ItemNo > 0 AND ItemNo <= 9999),
	IngredientCode			INT				NOT NULL CHECK (IngredientCode > 0 AND IngredientCode <= 9999),
	IngredientQuantity		VARCHAR(10)		NOT NULL,
	PRIMARY KEY (ItemNo, IngredientCode),
	FOREIGN KEY(ItemNo)				REFERENCES MenuItem(ItemNo)				ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(IngredientCode)		REFERENCES Ingredient(IngredientCode)	ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the Supplier table
CREATE TABLE Supplier (
	SupplierNo		INT				PRIMARY KEY CHECK (SupplierNo > 0 AND SupplierNo <= 9999),
	Name			VARCHAR(50)		NOT NULL,
	AddressID			INT			NOT NULL	CHECK (AddressID > 0 AND AddressID <= 9999),
	PhoneNo			INT				NOT NULL	CHECK (PhoneNo > 0),
	FirstName		VARCHAR(15)		NOT NULL,
	LastName		VARCHAR(15)		NOT NULL,
	FOREIGN KEY(AddressID)		REFERENCES	Address (AddressID) ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the IngredientSupplier table
CREATE TABLE IngredientSupplier (
	IngredientCode		INT				NOT NULL CHECK (IngredientCode > 0 AND IngredientCode <= 9999),
	SupplierNo			INT				NOT NULL CHECK (SupplierNo > 0 AND SupplierNo <= 9999),
	SupplierPriority	VARCHAR(10)		NOT NULL DEFAULT 'Secondary',
	PRIMARY KEY (IngredientCode, SupplierNo),
	FOREIGN KEY(IngredientCode)		REFERENCES Ingredient(IngredientCode)	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(SupplierNo)			REFERENCES Supplier(SupplierNo)			ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the IngredientOrder table
CREATE TABLE IngredientOrder (
	OrderNo			INT				PRIMARY KEY	CHECK (OrderNo > 0 AND OrderNo <= 99999),
	DateOrdered		DATE			NOT NULL,
	DateReceived	DATE			NOT NULL,
	TotalAmount		VARCHAR(10)		NOT NULL,
	OrderTotal		DECIMAL(6,2)	NOT NULL,
	Tax				DECIMAL(4,2)	NOT NULL,
	Status			VARCHAR(10)		NOT NULL DEFAULT 'Processing',
	Description		VARCHAR(150),
	SupplierNo		INT				NOT NULL CHECK (SupplierNo > 0 AND SupplierNo <= 9999),
	FOREIGN KEY(SupplierNo)	REFERENCES Supplier(SupplierNo)	ON UPDATE NO ACTION ON DELETE NO ACTION
)

--Create the IngredientsInOrder table
CREATE TABLE IngredientsInOrder (
	IngredientCode		INT				NOT NULL CHECK (IngredientCode > 0 AND IngredientCode <= 9999),
	OrderNo				INT				NOT NULL CHECK (OrderNo > 0 AND OrderNo <= 99999),
	Quantity			VARCHAR(15),
	PRIMARY KEY (IngredientCode, OrderNo),
	FOREIGN KEY(IngredientCode)		REFERENCES Ingredient(IngredientCode)	ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(OrderNo)			REFERENCES IngredientOrder(OrderNo)		ON UPDATE CASCADE ON DELETE NO ACTION,
)

--Create the Delivery table
CREATE TABLE Delivery (
	OrderNo			INT				PRIMARY KEY	CHECK (OrderNo > 0 AND OrderNo <= 99999),
	EmployeeNo		INT				NOT NULL	CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
	DeliveryTime	TIME,
	AddressID		INT				NOT NULL	CHECK (AddressID > 0 AND AddressID <= 9999),
	FOREIGN KEY(AddressID)	REFERENCES	Address (AddressID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(OrderNo)	REFERENCES CustomerOrder(OrderNo)	ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(EmployeeNo)	REFERENCES	DriverStaff(EmployeeNo)	ON UPDATE CASCADE ON DELETE NO ACTION
)

--Create the Pickup table
CREATE TABLE Pickup (
	OrderNo			INT				PRIMARY KEY	CHECK (OrderNo > 0 AND OrderNo <= 99999),
	PickupName		VARCHAR(40)		NOT NULL,
	PickupTime		TIME,
	FOREIGN KEY(OrderNo)	REFERENCES CustomerOrder(OrderNo)	ON UPDATE CASCADE ON DELETE NO ACTION
)

--Create the Shift table
CREATE TABLE Shift (
	ShiftNo			INT				PRIMARY KEY	CHECK (ShiftNo > 0 AND ShiftNo <= 99999),
	EmployeeNo		INT				NOT NULL	CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
	ShiftStartDate	DATE,
	ShiftEndDate	DATE,
	ShiftStartTime	TIME,
	ShiftEndTime	TIME,
	FOREIGN KEY(EmployeeNo)	REFERENCES	Staff(EmployeeNo)	ON UPDATE CASCADE ON DELETE NO ACTION
)

--Create the DriverShift table
CREATE TABLE DriverShift (
	ShiftNo				INT				PRIMARY KEY	CHECK (ShiftNo > 0 AND ShiftNo <= 99999),
	OrdersDelivered		INT,
	FOREIGN KEY(ShiftNo)	REFERENCES	Shift(ShiftNo)	ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the InstoreShift table
CREATE TABLE InstoreShift (
	ShiftNo				INT				PRIMARY KEY	CHECK (ShiftNo > 0 AND ShiftNo <= 99999),
	HoursWorked			DECIMAL(3,1),
	FOREIGN KEY(ShiftNo)	REFERENCES	Shift(ShiftNo)	ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the Payment table
CREATE TABLE Payment (
	PaymentID		INT				PRIMARY KEY	CHECK (PaymentID > 0 AND PaymentID <= 9999999),
	EmployeeNo		INT				NOT NULL	CHECK (EmployeeNo > 0 AND EmployeeNo <= 9999),
	ShiftNo			INT				NOT NULL	CHECK (ShiftNo > 0 AND ShiftNo <= 99999),
	Amount			DECIMAL(6,2)	NOT NULL,
	DatePayed		DATE			NOT NULL,
	FOREIGN KEY(EmployeeNo)	REFERENCES	Staff(EmployeeNo)	ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(ShiftNo)	REFERENCES	Shift(ShiftNo)		ON UPDATE NO ACTION ON DELETE NO ACTION
)

--Create the DriverPayment table
CREATE TABLE DriverPayment (
	PaymentID			INT				PRIMARY KEY	CHECK (PaymentID > 0 AND PaymentID <= 9999999),
	OrdersDelivered		INT,
	FOREIGN KEY(PaymentID)	REFERENCES	Payment(PaymentID)	ON UPDATE CASCADE ON DELETE CASCADE
)

--Create the InstorePayment table
CREATE TABLE InstorePayment (
	PaymentID			INT				PRIMARY KEY	CHECK (PaymentID > 0 AND PaymentID <= 9999999),
	HoursWorked			DECIMAL(4,1),
	FOREIGN KEY(PaymentID)	REFERENCES	Payment(PaymentID)	ON UPDATE CASCADE ON DELETE CASCADE
)

GO

--CREATE TRIGGERS

--Check InstoreStaff not in DriverStaff
CREATE TRIGGER check_InstoreStaff
ON InstoreStaff
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @storeEmployeeNo INT
	DECLARE @duplicateCount INT

	SET @storeEmployeeNo = (SELECT EmployeeNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	DriverStaff d
							WHERE	d.EmployeeNo = @storeEmployeeNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check DriverStaff not in InstoreStaff
CREATE TRIGGER check_DriverStaff
ON DriverStaff
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @driverEmployeeNo INT
	DECLARE @duplicateCount INT

	SET @driverEmployeeNo = (SELECT EmployeeNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	InstoreStaff s
							WHERE	s.EmployeeNo = @driverEmployeeNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check if Discount code has expired
CREATE TRIGGER check_DiscountCodeExpiry
ON CustomerOrder
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @endDate		DATE
	DECLARE @date			DATE
	DECLARE @discountCode	INT

	SET @discountCode = (SELECT DiscountCode FROM inserted)
	SET @date = (SELECT Date FROM inserted)
	SET @endDate = (SELECT	EndDate
							FROM	DiscountProgram dp
							WHERE	dp.DiscountCode = @discountCode)

	IF @date > @endDate
		ROLLBACK TRANSACTION
END

GO

--Check WalkinOrder not in PhoneOrder
CREATE TRIGGER check_WalkinOrder
ON WalkinOrder
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @walkinOrderNo INT
	DECLARE @duplicateCount INT

	SET @walkinOrderNo = (SELECT OrderNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	PhoneOrder po
							WHERE	po.OrderNo = @walkinOrderNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check PhoneOrder not in WalkinOrder
CREATE TRIGGER check_PhoneOrder
ON PhoneOrder
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @phoneOrderNo INT
	DECLARE @duplicateCount INT

	SET @phoneOrderNo = (SELECT OrderNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	WalkinOrder wo
							WHERE	wo.OrderNo = @phoneOrderNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check PhoneOrder EmployeeNo not in DriverStaff
CREATE TRIGGER check_PhoneOrderEmployee
ON PhoneOrder
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @employeeNo INT
	DECLARE @duplicateCount INT

	SET @employeeNo = (SELECT EmployeeNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	DriverStaff ds
							WHERE	ds.EmployeeNo = @employeeNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check Delivery EmployeeNo exists in DriverStaff
CREATE TRIGGER check_Delivery
ON Delivery
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @employeeNo INT
	DECLARE @duplicateCount INT

	SET @employeeNo = (SELECT EmployeeNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	DriverStaff ds
							WHERE	ds.EmployeeNo = @employeeNo)

	IF @duplicateCount != 1
		ROLLBACK TRANSACTION
END

GO

--Check Pickup OrderNo not in Delivery
CREATE TRIGGER check_Pickup
ON Pickup
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @orderNo INT
	DECLARE @duplicateCount INT

	SET @orderNo = (SELECT OrderNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	Delivery d
							WHERE	d.OrderNo = @orderNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check DriverShift ShiftNo not in InstoreShift
CREATE TRIGGER check_DriverShift
ON DriverShift
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @shiftNo INT
	DECLARE @duplicateCount INT

	SET @shiftNo = (SELECT ShiftNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	InstoreShift i
							WHERE	i.ShiftNo = @shiftNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check InstoreShift ShiftNo not in DriverShift
CREATE TRIGGER check_InstoreShift
ON InstoreShift
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @shiftNo INT
	DECLARE @duplicateCount INT

	SET @shiftNo = (SELECT ShiftNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	DriverShift d
							WHERE	d.ShiftNo = @shiftNo)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check Payment EmployeeNo exists in Shift
CREATE TRIGGER check_Payment
ON Payment
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @employeeNo INT
	DECLARE @duplicateCount INT

	SET @employeeNo = (SELECT EmployeeNo FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	Staff s
							WHERE	s.EmployeeNo = @employeeNo)

	IF @duplicateCount < 1
		ROLLBACK TRANSACTION
END

GO

--Check DriverPayment PaymentID not in InstorePayment
CREATE TRIGGER check_DriverPayment
ON DriverPayment
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @paymentID INT
	DECLARE @duplicateCount INT

	SET @paymentID = (SELECT PaymentID FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	InstorePayment i
							WHERE	i.PaymentID = @paymentID)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--Check InstorePayment PaymentID not in DriverPayment
CREATE TRIGGER check_InstorePayment
ON InstorePayment
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @paymentID INT
	DECLARE @duplicateCount INT

	SET @paymentID = (SELECT PaymentID FROM inserted)
	SET @duplicateCount = (SELECT	COUNT(*)
							FROM	DriverPayment d
							WHERE	d.PaymentID = @paymentID)

	IF @duplicateCount > 0
		ROLLBACK TRANSACTION
END

GO

--INSERT DATA INTO TABLES

--Insert Staff address details into Address
INSERT INTO Address VALUES (1, '3', 'Smith Street', 'Newcastle', 'New South Wales', 2300);
INSERT INTO Address VALUES (2, '6', 'Botsford Cutting', 'Newcastle East', 'New South Wales', 2300);
INSERT INTO Address VALUES (3, '322a', 'Bradtke Amble', 'Adamstown', 'New South Wales', 2289);
INSERT INTO Address VALUES (4, '2', 'Catherine Circlet', 'Merewether', 'New South Wales', 2291);
INSERT INTO Address VALUES (5, '13b', 'Braxton Little St.', 'Hillsborough', 'New South Wales', 2290);
INSERT INTO Address VALUES (6, '27', 'Kreiger Ridge', 'Nelson Bay', 'New South Wales', 2315);

--Insert Staff bank account details into BankDetails
INSERT INTO BankDetails VALUES (1, 023454684, 'ANZ', 112298);
INSERT INTO BankDetails VALUES (2, 348374464247, 'Commonwealth Bank', 062903);
INSERT INTO BankDetails VALUES (3, 46813184, 'ING', 923200);
INSERT INTO BankDetails VALUES (4, 46813458, 'NAB', 082976);
INSERT INTO BankDetails VALUES (5, 8768305,'ANZ', 112298);
INSERT INTO BankDetails VALUES (6, 68490756,'ING', 923200);

--Insert details into Staff
INSERT INTO Staff VALUES (1, 'Robert', 'Brown', 1, 0491570156, 865414088, 1, 'Full time', NULL);
INSERT INTO Staff VALUES (2, 'Jeffrey', 'Gottlieb', 2, 0275473375, 459599230, 2, 'Part time' , NULL);
INSERT INTO Staff VALUES (3, 'Freda', 'Conroy', 3, 0262736850, 112474082, 3, 'Full time', NULL);
INSERT INTO Staff VALUES (4, 'Anna', 'Mueller', 4, 0241650502, 565051603, 4, 'Part time', NULL);
INSERT INTO Staff VALUES (5, 'Zakary', 'Shields', 5, 0359696483, 907974668, 5, 'Part time', NULL);
INSERT INTO Staff VALUES (6, 'Granville', 'Greenholt', 6, 0254364468, 907974654, 6, 'Full time', NULL);

--Insert details into InstoreStaff
INSERT INTO InstoreStaff VALUES (1, 12.5);
INSERT INTO InstoreStaff VALUES (2, 18.0);
INSERT INTO InstoreStaff VALUES (3, 14.0);

--Insert details into DriverStaff
INSERT INTO DriverStaff VALUES (4, 68545980, 4.0);
INSERT INTO DriverStaff VALUES (5, 97356180, 6.0);
INSERT INTO DriverStaff VALUES (6, 77012563, 4.6);

--Insert Customer address details into Address
INSERT INTO Address VALUES (7, '52', 'Kihn Terrace', 'Kotara East', 'New South Wales', 2305);
INSERT INTO Address VALUES (8, '2d', 'Howell Byway', 'Sandgate', 'New South Wales', 2304);
INSERT INTO Address VALUES (9, '4b', 'Jast Estate', 'Cooks Hill', 'New South Wales', 2300);
INSERT INTO Address VALUES (10, '11', 'Prohaska Street', 'Elermore Vale', 'New South Wales', 2287);
INSERT INTO Address VALUES (11, '54', 'Treutel Circle', 'Marks Point', 'New South Wales', 2280);
INSERT INTO Address VALUES (12, '71', 'Jess Slope', 'Wallsend', 'New South Wales', 2287);

--Insert details into Customer
INSERT INTO Customer VALUES (1, 0248518981, 'Guillermo', 'Schumm', 7);
INSERT INTO Customer VALUES (2, 0251341003, 'Lillian', 'Carroll', 8);
INSERT INTO Customer VALUES (3, 0885402466, 'Maya', 'Mosciski', 9);
INSERT INTO Customer VALUES (4, 0880427468, 'Ian', 'Denesik', 10);
INSERT INTO Customer VALUES (5, 0255777323, 'Jalen', 'Lowe', 11);
INSERT INTO Customer VALUES (6, 0243918997, 'Ramona', 'Blick', 12);

--Insert details into DiscountProgram
INSERT INTO DiscountProgram VALUES (1, '2017-08-01', '2017-10-21', 'Buy a cheese pizza', 0.25, 'Buy a cheese pizza and get 25% off');
INSERT INTO DiscountProgram VALUES (2, '2017-10-01', '2017-11-01', 'Buy two pizzas', 0.10, 'Buy two pizzas and get 10% off');
INSERT INTO DiscountProgram VALUES (3, '2017-10-16', '2017-10-27', 'Buy a hawaiian pizza', 0.30, 'Buy a hawaiian pizza and get 30% off');

--Insert details into CustomerOrder
INSERT INTO CustomerOrder VALUES (1, '2017-10-20', 'Pick up', 'Cash', 22.55, 2.05, 'Delivered', 1, 0.00, 20.50, NULL);
INSERT INTO CustomerOrder VALUES (2, '2017-10-20', 'Pick up', 'Savings', 35.20, 3.20, 'Delivered', 2, 0.00, 32.00, NULL);
INSERT INTO CustomerOrder VALUES (3, '2017-10-20', 'Pick up', 'Savings', 9.35, 0.85, 'Delivered', 3, 2.50, 10.00, 1);
INSERT INTO CustomerOrder VALUES (4, '2017-10-20', 'Pick up', 'Cash', 17.05, 1.55, 'Delivered', 4, 0.00, 15.50, NULL);
INSERT INTO CustomerOrder VALUES (5, '2017-10-20', 'Pick up', 'Credit', 27.50, 2.50, 'Delivered', 5, 0.00, 25.00, NULL);
INSERT INTO CustomerOrder VALUES (6, '2017-10-20', 'Pick up', 'Credit', 35.15, 3.20, 'Delivered', 6, 3.55, 35.50, 2);
INSERT INTO CustomerOrder VALUES (7, '2017-10-20', 'Delivery', 'Credit', 13.20, 1.20, 'Delivered', 7, 0.00, 12.00, NULL);
INSERT INTO CustomerOrder VALUES (8, '2017-10-20', 'Delivery', 'Credit', 20.08, 1.83, 'Delivered', 8, 0.00, 18.25, NULL);
INSERT INTO CustomerOrder VALUES (9, '2017-10-20', 'Delivery', 'Credit', 17.40, 1.58, 'Delivered', 9, 6.78, 22.60, 3);

--Insert details into WalkinOrder
INSERT INTO WalkinOrder VALUES (1, 'Jo');
INSERT INTO WalkinOrder VALUES (2, 'Mo');
INSERT INTO WalkinOrder VALUES (3, 'Bo');

--Insert details into PhoneOrder
INSERT INTO PhoneOrder VALUES (4, 1, 1, 0248518981, 'Verified', '17:40', '17:42');
INSERT INTO PhoneOrder VALUES (5, 2, 2, 0251341003, 'Verified', '17:55', '17:56');
INSERT INTO PhoneOrder VALUES (6, 3, 2, 0885402466, 'Verified', '18:00', '18:02');
INSERT INTO PhoneOrder VALUES (7, 4, 1, 0880427468, 'Verified', '18:23', '18:25');
INSERT INTO PhoneOrder VALUES (8, 5, 1, 0255777323, 'Verified', '18:48', '18:49');
INSERT INTO PhoneOrder VALUES (9, 6, 1, 0243918997, 'Verified', '19:30', '19:31');

--Insert details into MenuItem
INSERT INTO MenuItem VALUES (1, 'Cheese Pizza', 'A plain cheese pizza', 'Medium', 5.00);
INSERT INTO MenuItem VALUES (2, 'Hawaiian Pizza', 'Pizza containing pinapple, ham and cheese', 'Medium', 8.95);
INSERT INTO MenuItem VALUES (3, 'Pepperoni Pizza', 'Pizza containing pepperoni and cheese', 'Medium', 5.00);

--Insert details into OrderMenuItem
INSERT INTO OrderMenuItem VALUES (3, 1, 2, 10.0);
INSERT INTO OrderMenuItem VALUES (5, 3, 3, 15.0);
INSERT INTO OrderMenuItem VALUES (2, 2, 2, 37.9);

--Insert details into Ingredient
INSERT INTO Ingredient VALUES (1, 'Pizza Dough', 'Dough', 'Used to make the pizza crust', '156 kg', '2017-10-15', '25 kg', '300 kg');
INSERT INTO Ingredient VALUES (2, 'Tomato Sauce', 'Sauce', 'Base Pizza sauce', '200 l', '2017-10-15', '75 l', '300 l');
INSERT INTO Ingredient VALUES (3, 'Mozzarella Cheese', 'Dairy', 'Southern Italian dairy product made from Italian buffalos milk', '100 kg', '2017-10-15', '50 kg', '150 kg');
INSERT INTO Ingredient VALUES (4, 'Ham', 'Meat', 'Ham is pork that has been preserved through salting, smoking, or wet curing.', '50 kg', '2017-10-15', '5 kg', '120 kg');
INSERT INTO Ingredient VALUES (5, 'Pinapple', 'Fruit', 'A tropical fruit', '40 kg', '2017-10-15', '12 kg', '90 kg');
INSERT INTO Ingredient VALUES (6, 'Pepperoni', 'Meat', 'An American variety of salami', '20 kg', '2017-10-15', '61 kg', '120 kg');

--Insert details into MenuItemIngredient
INSERT INTO MenuItemIngredient VALUES (1, 1, '460 g');
INSERT INTO MenuItemIngredient VALUES (1, 2, '141 g');
INSERT INTO MenuItemIngredient VALUES (1, 3, '227 g');
INSERT INTO MenuItemIngredient VALUES (2, 1, '460 g');
INSERT INTO MenuItemIngredient VALUES (2, 2, '141 g');
INSERT INTO MenuItemIngredient VALUES (2, 3, '227 g');
INSERT INTO MenuItemIngredient VALUES (2, 4, '75 g');
INSERT INTO MenuItemIngredient VALUES (2, 5, '82 g');
INSERT INTO MenuItemIngredient VALUES (3, 1, '460 g');
INSERT INTO MenuItemIngredient VALUES (3, 2, '141 g');
INSERT INTO MenuItemIngredient VALUES (3, 3, '227 g');
INSERT INTO MenuItemIngredient VALUES (3, 6, '85 g');

--Insert Supplier address details into Address
INSERT INTO Address VALUES (13, '112', 'Kieran Street', 'Wallsend', 'New South Wales', 2287);
INSERT INTO Address VALUES (14, '14', 'Kemmer Street', 'Charlestown', 'New South Wales', 2290);
INSERT INTO Address VALUES (15, '86', 'Volkman Alley', 'Kotara', 'New South Wales', 2289);

--Insert details into Supplier
INSERT INTO Supplier VALUES (1, 'Joes Premium Meats', 13, 0277392976, 'Joe', 'Cormier');
INSERT INTO Supplier VALUES (2, 'Newcastle Dairy', 14, 0218040164, 'Colin', 'Crona');
INSERT INTO Supplier VALUES (3, 'Heldas Bakery', 15, 0290268071, 'Helda', 'Towne');

--Insert details into IngredientSupplier
INSERT INTO IngredientSupplier VALUES (1, 3, 'Primary');
INSERT INTO IngredientSupplier VALUES (3, 2, 'Primary');
INSERT INTO IngredientSupplier VALUES (4, 1, 'Primary');
INSERT INTO IngredientSupplier VALUES (6, 1, 'Primary');

--Insert details into IngredientOrder
INSERT INTO IngredientOrder VALUES (1, '2017-10-15', '2017-10-17', '50 kg', 80.0, 8.0, 'Delivered', 'Order for mozzarella cheese', 2);
INSERT INTO IngredientOrder VALUES (2, '2017-10-20', '2017-10-22', '100 kg', 250.0, 25.0, 'Delivered', 'Order for pepperoni and ham', 1);
INSERT INTO IngredientOrder VALUES (3, '2017-10-22', '2017-10-23', '30 kg', 50.0, 5.0, 'Delivered', 'Order for pizza dough', 3);

--Insert details into IngredientsInOrder
INSERT INTO IngredientsInOrder VALUES (3, 1, '50 kg');
INSERT INTO IngredientsInOrder VALUES (4, 2, '50 kg');
INSERT INTO IngredientsInOrder VALUES (6, 2, '50 kg');
INSERT INTO IngredientsInOrder VALUES (1, 3, '30 kg');

--Insert Delivery address details into Address
INSERT INTO Address VALUES (16, '14b', 'Ressie Street', 'Hillsborough', 'New South Wales', 2290);
INSERT INTO Address VALUES (17, '84', 'Jacobs Avenue', 'Black Hill', 'New South Wales', 2322);
INSERT INTO Address VALUES (18, '56', 'Lazaro Crossroad', 'Bar Beach', 'New South Wales', 2300);

--Insert details into Delivery
INSERT INTO Delivery VALUES (7, 4, '18:00', 16);
INSERT INTO Delivery VALUES (8, 5, '18:25', 17);
INSERT INTO Delivery VALUES (9, 6, '19:51', 18);

--Insert details into Pickup
INSERT INTO Pickup VALUES (1, 'Jo', '17:30');
INSERT INTO Pickup VALUES (2, 'Mo', '18:21');
INSERT INTO Pickup VALUES (3, 'Bo', '19:43');

--Insert details into Shift
INSERT INTO Shift VALUES (1, 1, '2017-10-21', '2017-10-21', '09:00', '17:00');
INSERT INTO Shift VALUES (2, 2, '2017-10-21', '2017-10-21', '16:00', '20:00');
INSERT INTO Shift VALUES (3, 3, '2017-10-21', '2017-10-21', '09:00', '17:00');
INSERT INTO Shift VALUES (4, 4, '2017-10-22', '2017-10-22', '16:00', '21:00');
INSERT INTO Shift VALUES (5, 5, '2017-10-22', '2017-10-22', '17:30', '21:30');
INSERT INTO Shift VALUES (6, 6, '2017-10-22', '2017-10-22', '09:00', '17:00');

--Insert details into DriverShift
INSERT INTO DriverShift VALUES (4, 8);
INSERT INTO DriverShift VALUES (5, 4);
INSERT INTO DriverShift VALUES (6, 20);

--Insert details into InstoreShift
INSERT INTO InstoreShift VALUES (1, 8.0);
INSERT INTO InstoreShift VALUES (2, 4.0);
INSERT INTO InstoreShift VALUES (3, 8.0);

--Insert details into Payment
INSERT INTO Payment VALUES (1, 1, 1, 100.0, '2017-10-22');
INSERT INTO Payment VALUES (2, 2, 2, 72.0, '2017-10-22');
INSERT INTO Payment VALUES (3, 3, 3, 112.0, '2017-10-22');
INSERT INTO Payment VALUES (4, 4, 4, 32.0, '2017-10-23');
INSERT INTO Payment VALUES (5, 5, 5,  24.0,'2017-10-23');
INSERT INTO Payment VALUES (6, 6, 6, 92.0, '2017-10-23');

--Insert details into DriverPayment
INSERT INTO DriverPayment VALUES (4, 8);
INSERT INTO DriverPayment VALUES (5, 4);
INSERT INTO DriverPayment VALUES (6, 20);

--Insert details into InstorePayment
INSERT INTO InstorePayment VALUES (1, 8.0);
INSERT INTO InstorePayment VALUES (2, 4.0);
INSERT INTO InstorePayment VALUES (3, 8.0);

GO

--QUERIES

--Query 1
--For  a  staff  with  id  number  xxx,  print  his/her  1stname, lname, and hourly payment rate.
SELECT	FirstName, LastName, PaymentRate
FROM	Staff s INNER JOIN InstoreStaff i ON s.EmployeeNo = i.EmployeeNo
WHERE	i.EmployeeNo = 1

--Query 2
--List the ingredient details of a menu item named xxx.
SELECT	i.*
FROM	MenuItem m	INNER JOIN MenuItemIngredient mi ON m.ItemNo = mi.ItemNo
					INNER JOIN Ingredient i ON mi.IngredientCode = i.IngredientCode
WHERE	m.Name = 'Cheese Pizza'

--Query 3
--List all the order details of the orders that are made by the customer with first name xxx
--via phone between date yyy and zzz.
SELECT	co.OrderNo, Date, DeliveryMethod, PaymentMethod, OrderTotal, Tax, Status, PaymentApprovalNo,
		DiscountAmount, SubTotal, DiscountCode
FROM	Customer c	INNER JOIN PhoneOrder p ON c.CustomerID = p.CustomerID
					INNER JOIN CustomerOrder co ON p.OrderNo = co.OrderNo
WHERE	c.FirstName = 'Guillermo' AND co.Date > '2017-10-15' AND co.Date < '2017-10-25'

--Query 4
--Print  the  salary  paid  to  a  delivery  staff  named  xxx  in current month.
SELECT	SUM(Amount) AS 'Salary Paid'
FROM	Staff s INNER JOIN DriverStaff ds ON s.EmployeeNo = ds.EmployeeNo
				INNER JOIN Payment p ON ds.EmployeeNo = p.EmployeeNo
WHERE	FirstName = 'Anna' AND LastName = 'Mueller' AND MONTH(DatePayed) = MONTH(getdate())

--Query 5
--List the menu item that is mostly ordered in current month.
SELECT		m.ItemNo, m.Name
FROM		CustomerOrder co	INNER JOIN OrderMenuItem om ON co.OrderNo = om.OrderNo
								RIGHT JOIN MenuItem m ON om.ItemNo = m.ItemNo
WHERE		UnitQuantity  >= ALL	(SELECT		SUM(UnitQuantity)
									 FROM		CustomerOrder co	INNER JOIN OrderMenuItem om ON co.OrderNo = om.OrderNo
																	RIGHT JOIN MenuItem m ON om.ItemNo = m.ItemNo
									 WHERE		MONTH(co.Date) = MONTH(getdate())
									 GROUP BY	m.ItemNo
									)
GROUP BY	m.ItemNo, m.Name

--Query 6
--List   the   ingredient(s)   that   was/were   supplied   by   the supplier with supplier ID xxx on date yyy
SELECT	i.IngredientCode, i.Name
FROM	IngredientsInOrder ii INNER JOIN Ingredient i ON ii.IngredientCode = i.IngredientCode
WHERE	ii.OrderNo =	(SELECT	OrderNo
						 FROM	IngredientOrder io	INNER JOIN Supplier s ON io.SupplierNo = s.SupplierNo
						 WHERE	s.SupplierNo = 2 AND DateReceived = '2017-10-17'
						)