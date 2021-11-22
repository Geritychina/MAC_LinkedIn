/* CREATE DATABASE LinkedInDB */
/* USE LinkedInDB */


/*CREATE TABLES - ACCOUNT AND AccountHasProfile*/

CREATE TABLE Account(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name NVARCHAR(60) NOT NULL UNIQUE,
Age INT NOT NULL,
Email NVARCHAR(40),
DOB DATE NOT NULL,
Adress NVARCHAR(120),
AccountType NVARCHAR(30)

);

CREATE TABLE AccountHasProfile(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
AccountID  INT NOT NULL,
ProfileID INT  NOT NULL,
);

/* ALTER FK_AccountHasProfile */

ALTER TABLE AccountHasProfile
ADD CONSTRAINT FK_Account_AccountHasProfile_AccountID
FOREIGN KEY (AccountID) REFERENCES Account(ID);

ALTER TABLE AccountHasProfile
ADD CONSTRAINT FK_Profile_AccountHasProfile_ProfileID
FOREIGN KEY (ProfileID) REFERENCES Profile(ID);


/*CREATE TABLES - PROFILE AND ProfileHasOrganization, ORGANIZATION*/

CREATE TABLE Profile(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name NVARCHAR(60) NOT NULL UNIQUE,
Education NVARCHAR(50),
SearchAppears INT,
Posts INT,
ProfileViews INT,
Workplace NVARCHAR(40),
Contacts INT,
Certifications NVARCHAR(55),
Skills NVARCHAR(40),
Experience NVARCHAR(50),
Interests INT,
Followers INT
);

CREATE TABLE ProfileHasOrganization(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
ProfileID INT NOT NULL,
OrganizationID INT NOT NULL
);

CREATE TABLE Organization(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
OrganizationName NVARCHAR(100) NOT NULL UNIQUE,
OganizationType NVARCHAR(50),
OrganizationSize INT,
OrganizationDesc NVARCHAR(120)
);


/* ALTER FK_ProfileHasOrganization */

ALTER TABLE ProfileHasOrganization
ADD CONSTRAINT FK_Organization_ProfileHasOrg_ProfileID
FOREIGN KEY (ProfileID) REFERENCES Profile(ID);

ALTER TABLE ProfileHasOrganization
ADD CONSTRAINT FK_Organization_ProfileHasOrganization_OrganizationID
FOREIGN KEY (OrganizationID) REFERENCES Organization(ID);


/*CREATE TABLES CONNECTION AND ProfileHasConnection */
CREATE TABLE Connection(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
ConnectionCount INT NOT NULL,
Message NVARCHAR(120),
Groups INT
);

CREATE TABLE ProfileHasConnection(
ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
ProfileID INT NOT NULL,
ConnectionID INT NOT NULL
);


/* ALTER FK_ProfileHasConnection */

ALTER TABLE ProfileHasConnection
ADD CONSTRAINT FK_Connection_ProfileHasConn_ProfileID
FOREIGN KEY (ProfileID) REFERENCES Profile(ID);

ALTER TABLE ProfileHasConnection
ADD CONSTRAINT FK_Connection_ProfileHasConnection_ConnectionID
FOREIGN KEY (ConnectionID) REFERENCES Connection(ID);

/*INSERT into table Account*/
INSERT INTO Account(
Name,
Age,
Email,
DOB,
Adress,
AccountType
)
VALUES('Kevin Cheng',31,'xiaocheng@foxmail.com','04-23-1990','Beijing,Xisanhuan street','Premium');

SELECT * FROM Account

/*INSERT into table Profile*/


INSERT INTO Profile
(
Name,
Education,
SearchAppears,
Posts,
ProfileViews,
Workplace,
Contacts,
Certifications,
Skills,
Experience,
Interests,
Followers
)
VALUES('Kevin Cheng',' Peking Normal University',320,340,320,'Taobao LTE',230,'TOEIC english 3','Hard Work,Accuration','Tudou - 1 year',50,290);

SELECT * FROM Profile

/*INSERT into table Organization*/

INSERT INTO Organization(
OrganizationName,
OganizationType,
OrganizationSize,
OrganizationDesc
)
VALUES('Sina Programming Organzation','Mashine Learning Organization',300,'Based in Beijing, China organization for mashine learning');

SELECT * FROM Organization

/*INSERT into table Connection*/

INSERT INTO Connection(
ConnectionCount,
Message,
Groups
)
VALUES(34,'Hello! We need Gergana to help us! She is our chinese expert!:))',15);

SELECT * FROM Connection


/*INSERT into table AccountHasProfile*/

INSERT INTO AccountHasProfile(
AccountID,
ProfileID
)
VALUES(5,5);

SELECT * FROM AccountHasProfile

/*INSERT into table ProfileHasOrganization*/

INSERT INTO ProfileHasOrganization(
ProfileID,
OrganizationID
)
VALUES(5,5);

SELECT * FROM ProfileHasOrganization

/*INSERT into table ProfileHasConnection*/

INSERT INTO ProfileHasConnection(
ProfileID,
ConnectionID
)
VALUES(5,5);

SELECT * FROM ProfileHasConnection

/*Stored procedures: table Account  */

CREATE PROCEDURE GetAccounts
AS
BEGIN
	SELECT
		
		Name,
		Age,
		Email
	FROM
		Account
	ORDER BY
		Name
END;

EXECUTE GetAccounts; // Call procedure

/*Stored procedures: table Profile*/

CREATE PROCEDURE GetProfiles
AS
BEGIN
	SELECT
		
		Name,
		Education,
		Contacts
		
	FROM
		Profile
	ORDER BY
		Contacts
END;

EXECUTE GetProfiles; //Call procedure

/*Stored procedures: table Organization*/

CREATE PROCEDURE GetOrganization
AS
BEGIN
	SELECT
		
		OrganizationName,
		OganizationType,
		OrganizationDesc
		
	FROM
		Organization
	ORDER BY
		OrganizationSize
END;

EXECUTE GetOrganization;

/*Stored procedures: table Connection*/

CREATE PROCEDURE GetConnections
AS
BEGIN
	SELECT
		
		ConnectionCount,
		Message,
		Groups
		
	FROM
		Connection
	ORDER BY
		ConnectionCount
END;

EXECUTE GetConnections;

/* Create audit table with trigger: Account */

CREATE TABLE AccountAudit(
AccountID INT IDENTITY(1,1) PRIMARY KEY,
ProfileID INT NOT NULL,
AccName NVARCHAR(60) NOT NULL,
Age INT,
AccEmail NVARCHAR(40),
DOB DATE NULL,
Adress NVARCHAR(120),
AccountType NVARCHAR(30),
update_at DATETIME NOT NULL,
operation CHAR(3) NOT NULL,
CHECK(operation = 'INS' or operation = 'DEL')
);


CREATE TRIGGER trg_account_audit
ON Account
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO AccountAudit(
		ProfileID,
		AccName,
		Age,
		AccEmail,
		DOB,
		Adress,
		AccountType,
		update_at,
		operation
	)SELECT
		i.ID,
		Name,
		Age,
		i.Email,
		DOB,
		Adress,
		AccountType,
		GETDATE(),
		'INS'
		FROM
		inserted i
		UNION ALL
	SELECT
	d.ID,
	Name,
	Age,
	d.Email,
	DOB,
	Adress,
	AccountType,
	GETDATE(),
	'DEL'
	FROM
		deleted d;
END

SELECT * FROM AccountAudit;

INSERT INTO Account(
Name,
Age,
Email,
DOB,
Adress,
AccountType
)
VALUES('Viktor',28,'v1ktor@mail.com','04-15-1993','Sofia, Vitosha Street','Free');

SELECT * FROM AccountAudit;

/*Create audit table and trigger for table: Organization */

CREATE TABLE OrganizationAudit(
OrganizationID INT IDENTITY(1,1) PRIMARY KEY,
ProfileID INT NOT NULL,
OrgName NVARCHAR(100),
OrgType NVARCHAR(50),
OrgSize INT,
OrgDesc NVARCHAR(120),
update_at DATETIME NOT NULL,
operation CHAR(3) NOT NULL,
CHECK(operation = 'INS' or operation = 'DEL')
);

CREATE TRIGGER trg_organization_audit
ON Organization
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO OrganizationAudit(
		ProfileID,
		OrgName,
		OrgType,
		OrgSize,
		OrgDesc,
		update_at,
		operation
	)
	SELECT
		i.ID,
		OrganizationName,
		OganizationType,
		i.OrganizationSize,
		OrganizationDesc,
		GETDATE(),
		'INS'
		FROM
		inserted i
		UNION ALL
	SELECT
	d.ID,
	OrganizationName,
	OganizationType,
	d.OrganizationSize,
	OrganizationDesc,
	GETDATE(),
	'DEL'
	FROM
		deleted d;
END

INSERT INTO Organization(
OrganizationName,
OganizationType,
OrganizationSize,
OrganizationDesc
)
VALUES('V Organization','IT Organization',90,'IT organization for Distributed specialists');

SELECT * FROM OrganizationAudit;

/* Create Table functions for table: Account */

CREATE FUNCTION Check_Accounts()
returns table
as
return(SELECT * FROM Account);

/* Create Table functions for table: Organization */


CREATE FUNCTION Check_Organizations()
returns table
as
return(SELECT * FROM Organization);

/* Create Table functions for table: Connection */


CREATE FUNCTION Check_Connections()
returns table
as
return(SELECT * FROM Connection);
