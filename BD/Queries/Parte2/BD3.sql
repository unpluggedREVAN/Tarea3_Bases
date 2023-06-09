USE [master]
GO
/****** Object:  Database [BDTarea3]    Script Date: 21/5/2023 13:52:35 ******/
CREATE DATABASE [BDTarea3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BDTarea3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BDTarea3.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
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
/****** Object:  Table [dbo].[CuentaTarjetaAdicional]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[CuentaTarjetaCredito]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaTarjetaCredito](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoCuenta] [int] NOT NULL,
	[Codigo] [int] NOT NULL,
	[EsMaestra] [bit] NOT NULL,
	[FechaCreacion] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaTarjetaMaestra]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaTarjetaMaestra](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTarjetaHabiente] [int] NOT NULL,
	[IdCuentaTarjeta] [int] NOT NULL,
	[InteresAcumuladoCorriente] [int] NULL,
	[InteresAcumuladoMoratorio] [int] NULL,
	[LimiteCredito] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DBErrors]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBErrors](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadodeCuenta]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[EventLog]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LogDescription] [varchar](2000) NOT NULL,
	[PostIdUser] [int] NOT NULL,
	[PostIP] [varchar](64) NOT NULL,
	[PostTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MotivoInvalidacion]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MotivoInvalidacion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movimiento]    Script Date: 21/5/2023 13:52:36 ******/
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
	[Nombre] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoInteresCorriente]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoInteresCorriente](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoInteresAcumuladoCorriente] [money] NOT NULL,
	[IdCuentaTarjetaMaestra] [int] NOT NULL,
	[IdTipoMovimiento] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoInteresMoratorio]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoInteresMoratorio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[NuevoInteresAcumuladoMoratorio] [money] NOT NULL,
	[IdCuentaTarjetaMaestra] [int] NOT NULL,
	[IdTipoMovimiento] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoSospechoso]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[RegladeNegocio]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegladeNegocio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NombreRegla] [varchar](250) NOT NULL,
	[IdTipoRegla] [int] NOT NULL,
	[Valor] [varchar](256) NOT NULL,
	[IdTipoCuenta] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubEstadodeCuenta]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TarjetaFisica]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarjetaFisica](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [int] NOT NULL,
	[CVV] [int] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaInvalidacion] [date] NULL,
	[IdCuentaTarjeta] [int] NOT NULL,
	[IdMotivoInvalidacion] [int] NULL,
	[FechaVencimiento] [date] NULL,
	[IdTCA] [int] NULL,
	[IdTCM] [int] NULL,
	[EstadoTF] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TarjetaHabiente]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarjetaHabiente](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](250) NOT NULL,
	[IdTipoDocumentoID] [int] NOT NULL,
	[ValorDocumentoID] [varchar](250) NOT NULL,
	[Password] [varchar](250) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[NombreUsuario] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjeta]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipodeCuentaTarjeta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocio]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioDias]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioMeses]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioMonto]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioOperacion]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TipodeCuentaTarjetaxRegladeNegocioTasa]    Script Date: 21/5/2023 13:52:36 ******/
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
/****** Object:  Table [dbo].[TipoDocumentoID]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocumentoID](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Formato] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Accion] [varchar](1000) NOT NULL,
	[Nombre] [varchar](1024) NOT NULL,
	[AcumulaOperacionATM] [bit] NOT NULL,
	[AcumulaOperacionVentana] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoInteres]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoInteres](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Accion] [varchar](128) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovInteresCorriente]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovInteresCorriente](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](32) NOT NULL,
	[Accion] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovInteresMoratorio]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovInteresMoratorio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](32) NOT NULL,
	[Accion] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoRegladeNegocio]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoRegladeNegocio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Tipo] [varchar](128) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 21/5/2023 13:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NombreUsuario] [varchar](250) NOT NULL,
	[Password] [varchar](128) NOT NULL,
	[EsAdmin] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DBErrors] ON 

INSERT [dbo].[DBErrors] ([ErrorID], [UserName], [ErrorNumber], [ErrorState], [ErrorSeverity], [ErrorLine], [ErrorProcedure], [ErrorMessage], [ErrorDateTime]) VALUES (1, N'DESKTOP-38G492P\Usuario', 515, 2, 16, 25, N'SP_Logout', N'Cannot insert the value NULL into column ''PostIdUser'', table ''BDTarea3.dbo.EventLog''; column does not allow nulls. INSERT fails.', CAST(N'2023-05-20T14:55:26.483' AS DateTime))
INSERT [dbo].[DBErrors] ([ErrorID], [UserName], [ErrorNumber], [ErrorState], [ErrorSeverity], [ErrorLine], [ErrorProcedure], [ErrorMessage], [ErrorDateTime]) VALUES (2, N'DESKTOP-38G492P\Usuario', 515, 2, 16, 25, N'SP_Logout', N'Cannot insert the value NULL into column ''PostIdUser'', table ''BDTarea3.dbo.EventLog''; column does not allow nulls. INSERT fails.', CAST(N'2023-05-20T14:59:36.457' AS DateTime))
INSERT [dbo].[DBErrors] ([ErrorID], [UserName], [ErrorNumber], [ErrorState], [ErrorSeverity], [ErrorLine], [ErrorProcedure], [ErrorMessage], [ErrorDateTime]) VALUES (3, N'DESKTOP-38G492P\Usuario', 515, 2, 16, 25, N'SP_Logout', N'Cannot insert the value NULL into column ''PostIdUser'', table ''BDTarea3.dbo.EventLog''; column does not allow nulls. INSERT fails.', CAST(N'2023-05-20T15:13:17.803' AS DateTime))
SET IDENTITY_INSERT [dbo].[DBErrors] OFF
GO
SET IDENTITY_INSERT [dbo].[EventLog] ON 

INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (1, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-17T22:25:22.743' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (2, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-17T22:25:25.920' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (3, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-17T22:25:27.807' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (4, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-17T22:26:11.760' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (5, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-17T22:26:13.307' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (6, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-17T22:28:33.213' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (7, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-17T22:28:38.667' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (8, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-17T22:28:56.967' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (9, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-19T12:34:40.980' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (10, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T12:35:03.237' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (11, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T12:38:39.960' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (12, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-19T12:41:09.480' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (13, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-19T12:41:13.717' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (14, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T12:41:18.453' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (15, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T12:48:53.957' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (16, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T12:50:55.367' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (17, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T15:27:18.447' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (18, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T15:50:31.013' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (19, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T15:58:21.037' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (20, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T16:00:50.633' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (21, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T16:02:04.750' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (22, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T20:21:04.957' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (23, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T22:35:50.483' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (24, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T22:51:20.740' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (25, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T22:56:29.783' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (26, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:01:51.993' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (27, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:03:09.930' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (28, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:06:47.043' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (29, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:13:34.123' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (30, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:16:12.407' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (31, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:19:26.160' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (32, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-19T23:50:47.823' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (33, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T00:07:08.290' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (34, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T10:03:45.203' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (35, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T10:03:53.753' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (36, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T10:47:18.403' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (37, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:13:42.027' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (38, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:43:49.783' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (39, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:43:51.273' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (40, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:53:33.540' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (41, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:56:06.530' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (42, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:56:08.007' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (43, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:59:17.337' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (44, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T12:59:25.890' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (48, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:21:48.153' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (49, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:22:09.920' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (50, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:22:11.900' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (51, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:22:14.710' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (52, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:26:16.723' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (53, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:38:30.833' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (54, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:38:49.793' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (55, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:40:03.543' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (56, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:42:32.833' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (57, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T18:47:06.097' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (58, N'{TipoAccion="Login no exitoso", Description=""}', 0, N'::1', CAST(N'2023-05-20T19:01:32.263' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (59, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:01:37.700' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (60, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:23:52.400' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (61, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:24:51.990' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (62, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:26:19.903' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (63, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:27:38.167' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (64, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:28:49.793' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (65, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:31:20.763' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (66, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:31:35.440' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (67, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:31:38.803' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (68, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:32:56.893' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (69, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:34:30.407' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (70, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:40:24.730' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (71, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:40:31.307' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (72, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:40:33.167' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (73, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:40:35.097' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (74, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:40:37.873' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (75, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:42:53.877' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (76, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:45:02.170' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (77, N'{TipoAccion="Logout", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:45:08.890' AS DateTime))
INSERT [dbo].[EventLog] ([Id], [LogDescription], [PostIdUser], [PostIP], [PostTime]) VALUES (78, N'{TipoAccion="Login exitoso", Description=""}', 1, N'::1', CAST(N'2023-05-20T19:47:35.480' AS DateTime))
SET IDENTITY_INSERT [dbo].[EventLog] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuario] ON 

INSERT [dbo].[Usuario] ([Id], [NombreUsuario], [Password], [EsAdmin]) VALUES (1, N'Tyler', N'h5LVg', 1)
SET IDENTITY_INSERT [dbo].[Usuario] OFF
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
ALTER TABLE [dbo].[RegladeNegocio]  WITH CHECK ADD  CONSTRAINT [fk_RegladeNegocio_TipodeCuentaTarjeta] FOREIGN KEY([IdTipoCuenta])
REFERENCES [dbo].[TipodeCuentaTarjeta] ([Id])
GO
ALTER TABLE [dbo].[RegladeNegocio] CHECK CONSTRAINT [fk_RegladeNegocio_TipodeCuentaTarjeta]
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
ALTER TABLE [dbo].[TarjetaHabiente]  WITH CHECK ADD  CONSTRAINT [fk_TarjetaHabiente_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([Id])
GO
ALTER TABLE [dbo].[TarjetaHabiente] CHECK CONSTRAINT [fk_TarjetaHabiente_Usuario]
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
/****** Object:  StoredProcedure [dbo].[SP_ListarTarjetas]    Script Date: 21/5/2023 13:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ListarTarjetas]
	@inPatron VARCHAR(32)
	, @outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;  
	BEGIN TRY
		SET @outResultCode = 0;  -- no error code

		-- SE HACEN VALIDACIONES

		--IF (@inPatron IS NULL)
		--BEGIN
		--	SET @outResultCode = 50002;  -- parametro de entrada es nulo
		--	RETURN;
		--END;
		SELECT 	'8406933161002673' AS [Numero Tarjeta]
				,'Activa' AS [Estado]
				,'CTA' AS [Tipo de Cuenta]
				,'10/10/2025' AS [Fecha Expiracion]
				--TF.Codigo AS [Numero Tarjeta]
				--,CASE
				-- WHEN TF.EstadoTF = 1 THEN 'Activa'
				-- ELSE 'Inactiva'
				-- END AS [Estado]
				--,CASE
				-- WHEN TF.IdTCA IS NOT NULL THEN 'TCA'
				-- ELSE 'TCM'
				-- END AS [Tipo de Cuenta] 
				--,TF.FechaVencimiento AS [Fecha Expiracion]
			--FROM [dbo].[TarjetaFisica] TF
			--INNER JOIN [dbo].[CuentaTarjetaAdicional] CTA on TF.IdTCA = CTA.Id
	END TRY
	BEGIN CATCH

		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME()
			, ERROR_NUMBER()
			, ERROR_STATE()
			, ERROR_SEVERITY()
			, ERROR_LINE()
			, ERROR_PROCEDURE()
			, ERROR_MESSAGE()
			, GETDATE()
		);

		Set @outResultCode=50005;
	
	END CATCH


	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Logout]    Script Date: 21/5/2023 13:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Logout]
	--Parametros del procedimiento almacenado
	@inNombre VARCHAR(128) --Nombre del usuario que hizo logout
	,@inIP VARCHAR(64)	   --IP del servidor del usuario
	,@inTime DATETIME	   --Fecha y hora en que se esta ejecutando
	,@outResultCode INT OUTPUT --Codigo resultado de salida

AS
BEGIN
	--Iniciamos NOCOUNT ON
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @LogDescription VARCHAR(120); --Descripcion del LogEvent
	DECLARE @UserID INT; --Entero que representa el id del usuario que hace logout
	
	BEGIN TRANSACTION tLogout--Se empieza el TRANSACTION tlogout
	
	SET @outResultCode = 0; --Por default el codigo de salida se define en 0
	SET @LogDescription = '{TipoAccion="Logout", Description=""}'; --Se define la descripcion del Eventlog
	--Se define el valor del id del usuario haciendo select de la tabla Usuario
	SET @UserID = (SELECT u.id FROM [dbo].[Usuario] u
				WHERE @inNombre = u.NombreUsuario)

	--Se hace la insercion a la tabla EventLog del logout
	INSERT [dbo].[EventLog](
			 [LogDescription]
			,[PostIdUser]
			,[PostIP]
			,[PostTime]
	) VALUES (
			 @LogDescription
			,@UserID
			,@inIP
			,@inTime
	)

	COMMIT TRANSACTION tLogout --Se finaliza el TRANSACTION

	END TRY
	--Se empieza el catch de errores 
	BEGIN CATCH
	-- Se procesan errores dentro del catch
		--Se verifica si es mayor que cero
		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tLogout; -- se deshacen los cambios realizados
		END;
		--Se hace la insercion a la tabla de errores
		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME()
			, ERROR_NUMBER()
			, ERROR_STATE()
			, ERROR_SEVERITY()
			, ERROR_LINE()
			, ERROR_PROCEDURE()
			, ERROR_MESSAGE()
			, GETDATE()
		);
		--Se define al codigo de salida en 50005 
		SET @outResultCode = 50005;--Codigo de salida de error
	END CATCH
	SET NOCOUNT OFF

	--Se retorna el codigo de salida con su valor respectivo
	RETURN @outResultCode;
END



GO
/****** Object:  StoredProcedure [dbo].[SP_VerificarUsuario]    Script Date: 21/5/2023 13:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_VerificarUsuario]
	@inNombre VARCHAR(128)		-- Nombre de usuario ingresado a verificar
	,@inContraseña VARCHAR(128) -- Contraseña ingresada a verificar
	,@inIP VARCHAR(64)          -- IP del ordenador del usuario
	,@inTime DATETIME           -- Fecha y hora
	,@outTipoUsuario INT OUTPUT	--1 es admin, 0 es usuario corriente
	,@outResultCode INT OUTPUT	-- Código de resultado del SP
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @LogDescription VARCHAR(120);
	DECLARE @UserID INT;
	--Llamar al Store procedure para cargar datos xml
	--EXEC SP_ImportarDatosXML 'C:\Users\Usuario\Desktop\DB\Queries\DatosXML_ejemplo.xml',0;

	--Validar que nombre y contraseña no sean hileras vacías
	BEGIN TRY

	SET @outResultCode = 0; --Valor inicial predeterminado del resultado de salida

	--Validar nombre ingresado 
	IF	(
		@inNombre IS NULL OR NOT LEN(@inNombre) > 0	 --Verificar si es nulo o tiene cero caracteres
		)

	BEGIN
		SET @LogDescription = '{TipoAccion="Login no exitoso", Description=""}';
		SET @UserID = 0;
		SET @outResultCode = 50001; --Nombre no se ha ingresado
	END;

	--Validar contraseña ingresada
		IF	(
		@inContraseña iS NULL OR NOT LEN(@inContraseña) > 0 --Verificar si es nulo o tiene cero caracteres
		)

	BEGIN
		-- procesar error
		SET @LogDescription = '{TipoAccion="Login no exitoso", Description=""}';
		SET @UserID = 0;
		SET @outResultCode = 50002 --Contraseña no se ha ingresado
	END;

	IF NOT EXISTS (
			SELECT 1 FROM Usuario WHERE NombreUsuario = @InNombre
			AND Password = @inContraseña
			)
	BEGIN
		-- procesar error
		SET @LogDescription = '{TipoAccion="Login no exitoso", Description=""}';
		SET @UserID = 0;
		SET @outResultCode = 50003; --Combinación de nombre y contraseña invalida
	END
	ELSE 
	BEGIN--Si el nombre y contraseña si existen se selecciona el id del usuario
		SET @UserID = (SELECT U.Id FROM [dbo].[Usuario] U 
				WHERE LOWER(@inNombre) = LOWER(U.NombreUsuario))
		--Mensaje de login exitoso 
		SET @outTipoUsuario = (SELECT U.EsAdmin FROM dbo.Usuario U 
							WHERE U.Id = @UserID);
		SET @LogDescription = '{TipoAccion="Login exitoso", Description=""}';
	END 



	BEGIN TRANSACTION tVerificarUsuario
		--Se inserta al EventLog la accion de validacion del usuario 
		INSERT [dbo].[EventLog](
			 [LogDescription]
			,[PostIdUser]
			,[PostIP]
			,[PostTime]
		) VALUES (
			 @LogDescription
			,@UserID
			,@inIP
			,@inTime
		)

		COMMIT TRANSACTION tVerificarUsuario
	
		END TRY
		BEGIN CATCH

			-- Validamos la transaccion en caso de errores
			IF @@TRANCOUNT>0    -- Si este valor es mayor 1, hay un error 
			BEGIN
				ROLLBACK TRANSACTION tVerificarUsuario  -- Se deshacen los cambios realizados
			END;

			INSERT INTO [dbo].[DBErrors] VALUES (
				SUSER_NAME()
				, ERROR_NUMBER()
				, ERROR_STATE()
				, ERROR_SEVERITY()
				, ERROR_LINE()
				, ERROR_PROCEDURE()
				, ERROR_MESSAGE()
				, GETDATE()
			);

			-- Codigo de salida de error
			SET @outResultCode = 50005;  

		END CATCH

	SET NOCOUNT OFF
	--Retornar el codigo de salida
	RETURN @outResultCode; 
END
GO
USE [master]
GO
ALTER DATABASE [BDTarea3] SET  READ_WRITE 
GO
