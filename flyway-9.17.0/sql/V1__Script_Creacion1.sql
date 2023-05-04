/****** Object:  Database [caso3]    Script Date: 5/2/2023 8:18:36 PM ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'caso3')
BEGIN
    CREATE DATABASE [caso3]
     CONTAINMENT = NONE
     ON  PRIMARY
    ( NAME = N'caso3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\caso3.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
     LOG ON
    ( NAME = N'caso3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\caso3_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
     WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
END;
