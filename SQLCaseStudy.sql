CREATE DATABASE CompanyCaseStudyDB;
GO

USE CompanyCaseStudyDB;
GO

CREATE TABLE Department (
    DNUM INT PRIMARY KEY,
    DName NVARCHAR(100),
    ManagerSSN CHAR(9) NULL,
    ManagerHireDate DATE NULL
);

CREATE TABLE Employee (
    SSN CHAR(9) PRIMARY KEY,
    Fname NVARCHAR(100),
    Lname NVARCHAR(100),
    BirthDate DATE,
    Gender NVARCHAR(20),
    DNUM INT NOT NULL,
    SupervisorSSN CHAR(9) NULL,
    FOREIGN KEY (DNUM) REFERENCES Department(DNUM),
    FOREIGN KEY (SupervisorSSN) REFERENCES Employee(SSN)
);

ALTER TABLE Department
ADD FOREIGN KEY (ManagerSSN) REFERENCES Employee(SSN);

CREATE TABLE DepartmentLocation (
    DNUM INT NOT NULL,
    Location NVARCHAR(100) NOT NULL,
    PRIMARY KEY (DNUM, Location),
    FOREIGN KEY (DNUM) REFERENCES Department(DNUM)
);

CREATE TABLE Project (
    PNumber INT PRIMARY KEY,
    Pname NVARCHAR(100),
    Location NVARCHAR(100),
    City NVARCHAR(100),
    DNUM INT NOT NULL,
    FOREIGN KEY (DNUM) REFERENCES Department(DNUM)
);

CREATE TABLE Dependent (
    EmployeeSSN CHAR(9) NOT NULL,
    DependentName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(20),
    BirthDate DATE,
    PRIMARY KEY (EmployeeSSN, DependentName),
    FOREIGN KEY (EmployeeSSN)
        REFERENCES Employee(SSN)
        ON DELETE CASCADE
);

CREATE TABLE WorksOn (
    SSN CHAR(9) NOT NULL,
    PNumber INT NOT NULL,
    WorkingHours DECIMAL(5, 2),
    PRIMARY KEY (SSN, PNumber),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNumber) REFERENCES Project(PNumber)
);
