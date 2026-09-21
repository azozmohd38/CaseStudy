IF DB_ID(N'CompanyCaseStudyDB') IS NULL
BEGIN
    CREATE DATABASE CompanyCaseStudyDB;
END;
GO

USE CompanyCaseStudyDB;
GO

CREATE TABLE Department (
    DNumber INT PRIMARY KEY,
    DName NVARCHAR(100) NOT NULL,
    ManagerSSN CHAR(9) NULL,
    ManagerHireDate DATE NULL,

    CONSTRAINT UQ_Department_Manager
        UNIQUE (ManagerSSN),

    CONSTRAINT CK_Department_ManagerDate CHECK (
        (ManagerSSN IS NULL AND ManagerHireDate IS NULL)
        OR
        (ManagerSSN IS NOT NULL AND ManagerHireDate IS NOT NULL)
    )
);

CREATE TABLE Employee (
    SSN CHAR(9) PRIMARY KEY,
    Fname NVARCHAR(60) NOT NULL,
    Lname NVARCHAR(60) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender VARCHAR(15) NOT NULL,
    DNumber INT NOT NULL,
    SupervisorSSN CHAR(9) NULL,

    CONSTRAINT UQ_Employee_Department
        UNIQUE (SSN, DNumber),

    CONSTRAINT FK_Employee_Department
        FOREIGN KEY (DNumber)
        REFERENCES Department(DNumber),

    CONSTRAINT FK_Employee_Supervisor
        FOREIGN KEY (SupervisorSSN)
        REFERENCES Employee(SSN)
);

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager
    FOREIGN KEY (ManagerSSN, DNumber)
    REFERENCES Employee(SSN, DNumber);

CREATE TABLE DepartmentLocation (
    DNumber INT NOT NULL,
    Location NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_DepartmentLocation
        PRIMARY KEY (DNumber, Location),

    CONSTRAINT FK_DepartmentLocation_Department
        FOREIGN KEY (DNumber)
        REFERENCES Department(DNumber)
        ON DELETE CASCADE
);

CREATE TABLE Project (
    PNumber INT PRIMARY KEY,
    PName NVARCHAR(120) NOT NULL,
    Location NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    DNumber INT NOT NULL,

    CONSTRAINT FK_Project_Department
        FOREIGN KEY (DNumber)
        REFERENCES Department(DNumber)
);

CREATE TABLE Dependent (
    EmployeeSSN CHAR(9) NOT NULL,
    DependentName NVARCHAR(120) NOT NULL,
    Gender VARCHAR(15) NOT NULL,
    BirthDate DATE NOT NULL,

    CONSTRAINT PK_Dependent
        PRIMARY KEY (EmployeeSSN, DependentName),

    CONSTRAINT FK_Dependent_Employee
        FOREIGN KEY (EmployeeSSN)
        REFERENCES Employee(SSN)
        ON DELETE CASCADE
);

CREATE TABLE WorksOn (
    SSN CHAR(9) NOT NULL,
    PNumber INT NOT NULL,
    WorkingHours DECIMAL(5,2) NOT NULL,

    CONSTRAINT PK_WorksOn
        PRIMARY KEY (SSN, PNumber),

    CONSTRAINT CK_WorksOn_Hours
        CHECK (WorkingHours >= 0),

    CONSTRAINT FK_WorksOn_Employee
        FOREIGN KEY (SSN)
        REFERENCES Employee(SSN),

    CONSTRAINT FK_WorksOn_Project
        FOREIGN KEY (PNumber)
        REFERENCES Project(PNumber)
);
GO