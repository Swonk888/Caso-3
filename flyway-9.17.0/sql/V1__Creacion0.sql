use master;
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'case3')
BEGIN
	ALTER DATABASE [case3] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [case3]
END

CREATE DATABASE [case3]
    CONTAINMENT = NONE
    ON  PRIMARY
( NAME = N'case3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\case3.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
    LOG ON
( NAME = N'case3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\case3_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
    WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
USE case3;
CREATE TABLE [dbo].[flyway_schema_history] (
    [installed_rank] INT NOT NULL,
    [version] VARCHAR(50),
    [description] VARCHAR(200) NOT NULL,
    [type] VARCHAR(20) NOT NULL,
    [script] VARCHAR(1000) NOT NULL,
    [checksum] INT,
    [installed_by] VARCHAR(100) NOT NULL,
    [installed_on] DATETIME NOT NULL DEFAULT GETDATE(),
    [execution_time] INT NOT NULL,
    [success] BIT NOT NULL
);