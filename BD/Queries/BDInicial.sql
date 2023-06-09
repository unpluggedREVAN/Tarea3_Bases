USE [master]
GO
/****** Object:  Database [BDTarea3]    Script Date: 25/4/2023 05:30:39 ******/
CREATE DATABASE [BDTarea3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BDTarea3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BDTarea3.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BDTarea3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BDTarea3_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BDTarea3] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BDTarea3].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BDTarea3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BDTarea3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BDTarea3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BDTarea3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BDTarea3] SET ARITHABORT OFF 
GO
ALTER DATABASE [BDTarea3] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BDTarea3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BDTarea3] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BDTarea3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BDTarea3] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BDTarea3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BDTarea3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BDTarea3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BDTarea3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BDTarea3] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BDTarea3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BDTarea3] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BDTarea3] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BDTarea3] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BDTarea3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BDTarea3] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BDTarea3] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BDTarea3] SET RECOVERY FULL 
GO
ALTER DATABASE [BDTarea3] SET  MULTI_USER 
GO
ALTER DATABASE [BDTarea3] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BDTarea3] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BDTarea3] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BDTarea3] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BDTarea3] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BDTarea3] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BDTarea3', N'ON'
GO
ALTER DATABASE [BDTarea3] SET QUERY_STORE = ON
GO
ALTER DATABASE [BDTarea3] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BDTarea3]
GO
/****** Object:  Table [dbo].[CuentaTarjetaAdicional]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaTarjetaAdicional](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCuentaMaestra] [int] NOT NULL,
	[IdTarjetaHabiente] [int] NOT NULL,
	[IdCuentaTarjeta] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaTarjetaCredito]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaTarjetaCredito](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoCuenta] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaTarjetaMaestra]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaTarjetaMaestra](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTarjetaHabiente] [int] NOT NULL,
	[IdCuentaTarjeta] [int] NOT NULL,
	[InteresAcumuladoCorriente] [money] NOT NULL,
	[InteresAcumuladoMoratorio] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadodeCuenta]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadodeCuenta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Saldo] [money] NOT NULL,
	[IdCuentaTarjetaMaestra] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MotivoInvalidacion]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MotivoInvalidacion](
	[Id] [int] NOT NULL,
	[Descripcion] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movimiento]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movimiento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](1000) NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoSaldo] [money] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Referencia] [int] NOT NULL,
	[IdTipoMovimiento] [int] NOT NULL,
	[IdEstadoCuenta] [int] NOT NULL,
	[IdTarjetaFisica] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoInteresCorriente]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoInteresCorriente](
	[Id] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoInteresAcumuladoCorriente] [money] NOT NULL,
	[IdTipoMovimiento] [int] NOT NULL,
	[IdCuentaTarjetaMaestra] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoInteresMoratorio]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoInteresMoratorio](
	[Id] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoInteresAcumuladoMoratorio] [money] NOT NULL,
	[IdTipoMovimiento] [int] NOT NULL,
	[IdCuentaTarjetaMaestra] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoSospechoso]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoSospechoso](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCuentaTarjetaMaestra] [int] NOT NULL,
	[IdTarjetaFisica] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[Descripcion] [varchar](1000) NOT NULL,
	[Referencia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegladeNegocio]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegladeNegocio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NombreRegla] [varchar](250) NOT NULL,
	[IdTipoRegla] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubEstadodeCuenta]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubEstadodeCuenta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdEstadodeCuenta] [int] NOT NULL,
	[IdCuentaTarjetaAdicional] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TarjetaFisica]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarjetaFisica](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [int] NOT NULL,
	[CVV] [int] NOT NULL,
	[PIN] [int] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaInvalidacion] [datetime] NOT NULL,
	[AñoVencimiento] [datetime] NOT NULL,
	[MesVencimiento] [datetime] NOT NULL,
	[IdMotivoInvalidacion] [int] NOT NULL,
	[IdCuentaTarjeta] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TarjetaHabiente]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarjetaHabiente](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](250) NOT NULL,
	[IdTipoDocumentoID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjeta]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjeta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocio]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocio](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoCuenta] [int] NOT NULL,
	[IdRegladeNegocio] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioDias]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioDias](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CantDias] [int] NOT NULL,
	[IdTCTxRN] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioMeses]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioMeses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CantMeses] [int] NOT NULL,
	[IdTCTxRN] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioMonto]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioMonto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Monto] [money] NOT NULL,
	[IdTCTxRN] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioOperacion]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioOperacion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CantOperaciones] [int] NOT NULL,
	[IdTCTxRN] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioTasa]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioTasa](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tasa] [money] NOT NULL,
	[IdTCTxRN] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocumentoID]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocumentoID](
	[Id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Accion] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovInteresCorriente]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovInteresCorriente](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovInteresMoratorio]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovInteresMoratorio](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoRegladeNegocio]    Script Date: 25/4/2023 05:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoRegladeNegocio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CuentaTarjetaAdicional]  WITH CHECK ADD  CONSTRAINT [fk_CuentaTarjetaAdicional_CuentaTarjeta] FOREIGN KEY([IdCuentaTarjeta])
REFERENCES [dbo].[CuentaTarjetaCredito] ([Id])
GO
ALTER TABLE [dbo].[CuentaTarjetaAdicional] CHECK CONSTRAINT [fk_CuentaTarjetaAdicional_CuentaTarjeta]
GO
ALTER TABLE [dbo].[CuentaTarjetaAdicional]  WITH CHECK ADD  CONSTRAINT [fk_CuentaTarjetaAdicional_CuentaTarjetaMaestra] FOREIGN KEY([IdCuentaMaestra])
REFERENCES [dbo].[CuentaTarjetaMaestra] ([Id])
GO
ALTER TABLE [dbo].[CuentaTarjetaAdicional] CHECK CONSTRAINT [fk_CuentaTarjetaAdicional_CuentaTarjetaMaestra]
GO
ALTER TABLE [dbo].[CuentaTarjetaAdicional]  WITH CHECK ADD  CONSTRAINT [fk_CuentaTarjetaAdicional_TarjetaHabiente] FOREIGN KEY([IdTarjetaHabiente])
REFERENCES [dbo].[TarjetaHabiente] ([Id])
GO
ALTER TABLE [dbo].[CuentaTarjetaAdicional] CHECK CONSTRAINT [fk_CuentaTarjetaAdicional_TarjetaHabiente]
GO
ALTER TABLE [dbo].[CuentaTarjetaCredito]  WITH CHECK ADD  CONSTRAINT [fk_CuentaTarjeta_TipodeCuentaTarjeta] FOREIGN KEY([IdTipoCuenta])
REFERENCES [dbo].[TipodeCuentaTarjeta] ([Id])
GO
ALTER TABLE [dbo].[CuentaTarjetaCredito] CHECK CONSTRAINT [fk_CuentaTarjeta_TipodeCuentaTarjeta]
GO
ALTER TABLE [dbo].[CuentaTarjetaMaestra]  WITH CHECK ADD  CONSTRAINT [fk_CuentaTarjetaMaestra_CuentaTarjeta] FOREIGN KEY([IdCuentaTarjeta])
REFERENCES [dbo].[CuentaTarjetaCredito] ([Id])
GO
ALTER TABLE [dbo].[CuentaTarjetaMaestra] CHECK CONSTRAINT [fk_CuentaTarjetaMaestra_CuentaTarjeta]
GO
ALTER TABLE [dbo].[CuentaTarjetaMaestra]  WITH CHECK ADD  CONSTRAINT [fk_CuentaTarjetaMaestra_TarjetaHabiente] FOREIGN KEY([IdTarjetaHabiente])
REFERENCES [dbo].[TarjetaHabiente] ([Id])
GO
ALTER TABLE [dbo].[CuentaTarjetaMaestra] CHECK CONSTRAINT [fk_CuentaTarjetaMaestra_TarjetaHabiente]
GO
ALTER TABLE [dbo].[EstadodeCuenta]  WITH CHECK ADD  CONSTRAINT [fk_EstadodeCuenta_CuentaTarjetaMaestra] FOREIGN KEY([IdCuentaTarjetaMaestra])
REFERENCES [dbo].[CuentaTarjetaMaestra] ([Id])
GO
ALTER TABLE [dbo].[EstadodeCuenta] CHECK CONSTRAINT [fk_EstadodeCuenta_CuentaTarjetaMaestra]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [fk_Movimiento_EstadodeCuenta] FOREIGN KEY([IdEstadoCuenta])
REFERENCES [dbo].[EstadodeCuenta] ([Id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [fk_Movimiento_EstadodeCuenta]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [fk_Movimiento_TarjetaFisica] FOREIGN KEY([IdTarjetaFisica])
REFERENCES [dbo].[TarjetaFisica] ([Id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [fk_Movimiento_TarjetaFisica]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [fk_Movimiento_TipoMovimiento] FOREIGN KEY([IdTipoMovimiento])
REFERENCES [dbo].[TipoMovimiento] ([Id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [fk_Movimiento_TipoMovimiento]
GO
ALTER TABLE [dbo].[MovimientoInteresCorriente]  WITH CHECK ADD  CONSTRAINT [fk_MovimientoInteresCorriente_CuentaTarjetaMaestra] FOREIGN KEY([IdCuentaTarjetaMaestra])
REFERENCES [dbo].[CuentaTarjetaMaestra] ([Id])
GO
ALTER TABLE [dbo].[MovimientoInteresCorriente] CHECK CONSTRAINT [fk_MovimientoInteresCorriente_CuentaTarjetaMaestra]
GO
ALTER TABLE [dbo].[MovimientoInteresCorriente]  WITH CHECK ADD  CONSTRAINT [fk_MovimientoInteresCorriente_TipoMovInteresCorriente] FOREIGN KEY([IdTipoMovimiento])
REFERENCES [dbo].[TipoMovInteresCorriente] ([Id])
GO
ALTER TABLE [dbo].[MovimientoInteresCorriente] CHECK CONSTRAINT [fk_MovimientoInteresCorriente_TipoMovInteresCorriente]
GO
ALTER TABLE [dbo].[MovimientoInteresMoratorio]  WITH CHECK ADD  CONSTRAINT [fk_MovimientoInteresMoratorio_CuentaTarjetaMaestra] FOREIGN KEY([IdCuentaTarjetaMaestra])
REFERENCES [dbo].[CuentaTarjetaMaestra] ([Id])
GO
ALTER TABLE [dbo].[MovimientoInteresMoratorio] CHECK CONSTRAINT [fk_MovimientoInteresMoratorio_CuentaTarjetaMaestra]
GO
ALTER TABLE [dbo].[MovimientoInteresMoratorio]  WITH CHECK ADD  CONSTRAINT [fk_MovimientoInteresMoratorio_TipoMovInteresMoratorio] FOREIGN KEY([IdTipoMovimiento])
REFERENCES [dbo].[TipoMovInteresMoratorio] ([Id])
GO
ALTER TABLE [dbo].[MovimientoInteresMoratorio] CHECK CONSTRAINT [fk_MovimientoInteresMoratorio_TipoMovInteresMoratorio]
GO
ALTER TABLE [dbo].[MovimientoSospechoso]  WITH CHECK ADD  CONSTRAINT [fk_MovimientoSospechoso_CuentaTarjetaMaestra] FOREIGN KEY([IdCuentaTarjetaMaestra])
REFERENCES [dbo].[CuentaTarjetaMaestra] ([Id])
GO
ALTER TABLE [dbo].[MovimientoSospechoso] CHECK CONSTRAINT [fk_MovimientoSospechoso_CuentaTarjetaMaestra]
GO
ALTER TABLE [dbo].[MovimientoSospechoso]  WITH CHECK ADD  CONSTRAINT [fk_MovimientoSospechoso_TarjetaFisica] FOREIGN KEY([IdTarjetaFisica])
REFERENCES [dbo].[TarjetaFisica] ([Id])
GO
ALTER TABLE [dbo].[MovimientoSospechoso] CHECK CONSTRAINT [fk_MovimientoSospechoso_TarjetaFisica]
GO
ALTER TABLE [dbo].[RegladeNegocio]  WITH CHECK ADD  CONSTRAINT [fk_RegladeNegocio_TipoRegladeNegocio] FOREIGN KEY([IdTipoRegla])
REFERENCES [dbo].[TipoRegladeNegocio] ([Id])
GO
ALTER TABLE [dbo].[RegladeNegocio] CHECK CONSTRAINT [fk_RegladeNegocio_TipoRegladeNegocio]
GO
ALTER TABLE [dbo].[SubEstadodeCuenta]  WITH CHECK ADD  CONSTRAINT [fk_SubEstadodeCuenta_CuentaTarjetaAdicional] FOREIGN KEY([IdCuentaTarjetaAdicional])
REFERENCES [dbo].[CuentaTarjetaAdicional] ([Id])
GO
ALTER TABLE [dbo].[SubEstadodeCuenta] CHECK CONSTRAINT [fk_SubEstadodeCuenta_CuentaTarjetaAdicional]
GO
ALTER TABLE [dbo].[SubEstadodeCuenta]  WITH CHECK ADD  CONSTRAINT [fk_SubEstadodeCuenta_EstadodeCuenta] FOREIGN KEY([IdEstadodeCuenta])
REFERENCES [dbo].[EstadodeCuenta] ([Id])
GO
ALTER TABLE [dbo].[SubEstadodeCuenta] CHECK CONSTRAINT [fk_SubEstadodeCuenta_EstadodeCuenta]
GO
ALTER TABLE [dbo].[TarjetaFisica]  WITH CHECK ADD  CONSTRAINT [fk_TarjetaFisica_CuentaTarjeta] FOREIGN KEY([IdCuentaTarjeta])
REFERENCES [dbo].[CuentaTarjetaCredito] ([Id])
GO
ALTER TABLE [dbo].[TarjetaFisica] CHECK CONSTRAINT [fk_TarjetaFisica_CuentaTarjeta]
GO
ALTER TABLE [dbo].[TarjetaFisica]  WITH CHECK ADD  CONSTRAINT [fk_TarjetaFisica_MotivoInvalidacion] FOREIGN KEY([IdMotivoInvalidacion])
REFERENCES [dbo].[MotivoInvalidacion] ([Id])
GO
ALTER TABLE [dbo].[TarjetaFisica] CHECK CONSTRAINT [fk_TarjetaFisica_MotivoInvalidacion]
GO
ALTER TABLE [dbo].[TarjetaHabiente]  WITH CHECK ADD  CONSTRAINT [fk_TarjetaHabiente_TipoDocumentoID] FOREIGN KEY([IdTipoDocumentoID])
REFERENCES [dbo].[TipoDocumentoID] ([Id])
GO
ALTER TABLE [dbo].[TarjetaHabiente] CHECK CONSTRAINT [fk_TarjetaHabiente_TipoDocumentoID]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocio]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocio_RegladeNegocio] FOREIGN KEY([IdRegladeNegocio])
REFERENCES [dbo].[RegladeNegocio] ([Id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocio] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocio_RegladeNegocio]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocio]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocio_TipodeCuentaTarjeta] FOREIGN KEY([IdTipoCuenta])
REFERENCES [dbo].[TipodeCuentaTarjeta] ([Id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocio] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocio_TipodeCuentaTarjeta]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioDias]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioDias_TipodeCuentaTarjetaxRegladeNegocio] FOREIGN KEY([IdTCTxRN])
REFERENCES [dbo].[TipodeCuentaTarjetaxRegladeNegocio] ([id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioDias] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioDias_TipodeCuentaTarjetaxRegladeNegocio]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioMeses]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioMeses_TipodeCuentaTarjetaxRegladeNegocio] FOREIGN KEY([IdTCTxRN])
REFERENCES [dbo].[TipodeCuentaTarjetaxRegladeNegocio] ([id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioMeses] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioMeses_TipodeCuentaTarjetaxRegladeNegocio]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioMonto]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioMonto_TipodeCuentaTarjetaxRegladeNegocio] FOREIGN KEY([IdTCTxRN])
REFERENCES [dbo].[TipodeCuentaTarjetaxRegladeNegocio] ([id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioMonto] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioMonto_TipodeCuentaTarjetaxRegladeNegocio]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioOperacion]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioOperacion_TipodeCuentaTarjetaxRegladeNegocio] FOREIGN KEY([IdTCTxRN])
REFERENCES [dbo].[TipodeCuentaTarjetaxRegladeNegocio] ([id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioOperacion] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioOperacion_TipodeCuentaTarjetaxRegladeNegocio]
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioTasa]  WITH CHECK ADD  CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioTasa_TipodeCuentaTarjetaxRegladeNegocio] FOREIGN KEY([IdTCTxRN])
REFERENCES [dbo].[TipodeCuentaTarjetaxRegladeNegocio] ([id])
GO
ALTER TABLE [dbo].[TipodeCuentaTarjetaxRegladeNegocioTasa] CHECK CONSTRAINT [fk_TipodeCuentaTarjetaxRegladeNegocioTasa_TipodeCuentaTarjetaxRegladeNegocio]
GO
USE [master]
GO
ALTER DATABASE [BDTarea3] SET  READ_WRITE 
GO
