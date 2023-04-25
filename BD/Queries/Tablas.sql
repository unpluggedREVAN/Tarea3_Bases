--Creacion y alteracion de tablas script Tarea3 

CREATE TABLE dbo.TarjetaHabiente
(
	Id INT IDENTITY (1,1) NOT NULL PRIMARY KEY
	,Nombre VARCHAR(250) NOT NULL
	--,idTipoDocumentoID INT NOT NULL FOREIGN KEY REFERENCES TipoDocumentoID(id) 
	--,ValorDocumentoID INT NOT NULL
);
ALTER TABLE dbo.TarjetaHabiente--ID que referencia al tipo documento
ADD IdTipoDocumentoID INT NOT NULL;



ALTER TABLE dbo.TarjetaHabiente
ADD CONSTRAINT fk_TarjetaHabiente_TipoDocumentoID
FOREIGN KEY (IdTipoDocumentoID)
REFERENCES dbo.TipoDocumentoID (Id);

--TarjetaHabiente REFERENCE->TipoDocumentoID
CREATE TABLE dbo.TipoDocumentoID
(
	Id INT IDENTITY (1,1) NOT NULL PRIMARY KEY 
);

CREATE TABLE dbo.CuentaTarjetaAdicional   --CTA
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY 
);

ALTER TABLE dbo.CuentaTarjetaAdicional
ADD IdCuentaMaestra INT NOT NULL;

ALTER TABLE dbo.CuentaTarjetaAdicional
ADD CONSTRAINT fk_CuentaTarjetaAdicional_CuentaTarjetaMaestra
FOREIGN KEY (IdCuentaMaestra)
REFERENCES dbo.CuentaTarjetaMaestra (Id);

ALTER TABLE dbo.CuentaTarjetaAdicional--Id que referencia a la cuentahabiente de esta tarjetaAdicional
ADD IdTarjetaHabiente INT NOT NULL;

ALTER TABLE dbo.CuentaTarjetaAdicional
ADD CONSTRAINT fk_CuentaTarjetaAdicional_TarjetaHabiente
FOREIGN KEY (IdTarjetaHabiente)
REFERENCES dbo.TarjetaHabiente (Id);

--CTA REFERENCES->CTM
CREATE TABLE dbo.CuentaTarjetaMaestra   --CTM
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	--,idEstadodeCuenta INT NOT NULL FOREIGN KEY REFERENCES EstadodeCuenta(id)
	--,Saldo MONEY NOT NULL
	
);
ALTER TABLE dbo.MovimientoInteresMoratorio ADD IdCuentaTarjetaMaestra INT NOT NULL;

ALTER TABLE dbo.CuentaTarjetaAdicional
ADD IdCuentaTarjeta INT NOT NULL 

ALTER TABLE dbo.CuentaTarjetaAdicional
ADD CONSTRAINT fk_CuentaTarjetaAdicional_CuentaTarjeta
FOREIGN KEY (IdCuentaTarjeta)
REFERENCES dbo.CuentaTarjeta (Id);


CREATE TABLE dbo.CuentaTarjeta
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
);

ALTER TABLE dbo.CuentaTarjeta ADD IdTipoCuenta INT NOT NULL;

ALTER TABLE dbo.CuentaTarjeta
ADD CONSTRAINT fk_CuentaTarjeta_TipodeCuentaTarjeta
FOREIGN KEY (IdTipoCuenta)
REFERENCES dbo.TipodeCuentaTarjeta (Id);
--Max limite credito,tasaInteresMensual,tasaInteresMensualMoratorio,CargoxServicioMensualCTM,CargoxServicioMensualCTA
--,PlazoPagoenMeses,ReposicionFisicaCTA,ReposicionFisicaCTM,CargoMensualSeguro,RenovacionFisicaCTA,
--,RenovacionFisicaCTM,CantMaxOperacionesxMesATM,CantMaxOperacionesxMesVentanilla,MultaExcesoOperacionesATM
--,MultaExcesoOperacionesVentanilla, CantDiasPagoMin
CREATE TABLE dbo.TipodeCuentaTarjeta--Referenciara a TarjetaFisica
(--Son del tipo Corporativo, oro platino
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY 
);


--Maybe map tipocuenta based on the name rule using fk key in TipodeCuenta
CREATE TABLE dbo.RegladeNegocio--RN
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,NombreRegla VARCHAR(250) NOT NULL
	,IdTipoRegla INT NOT NULL
);


ALTER TABLE dbo.RegladeNegocio
ADD CONSTRAINT fk_RegladeNegocio_TipoRegladeNegocio
FOREIGN KEY (IdTipoRegla)
REFERENCES dbo.TipoRegladeNegocio (Id);


--RN References TRN
CREATE TABLE dbo.TipoRegladeNegocio--TRN
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,Nombre VARCHAR(128) NOT NULL
);


CREATE TABLE dbo.TipodeCuentaTarjetaxRegladeNegocio
(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	--,idTipoReglaNegocio  NOT NULL FOREIGN KEY REFERENCES ReglaNegocioxTipoReglaNegocioCantDias(id) 
);

--Tablas TctxRN

ALTER TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioMonto ADD IdTCTxRN INT NOT NULL;

ALTER TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioMonto
ADD CONSTRAINT fk_TipodeCuentaTarjetaxRegladeNegocioMonto_TipodeCuentaTarjetaxRegladeNegocio
FOREIGN KEY (IdTCTxRN)
REFERENCES dbo.TipodeCuentaTarjetaxRegladeNegocio (id);

CREATE TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioDias
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,CantDias INT NOT NULL 
);

CREATE TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioOperacion
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,CantOperaciones INT NOT NULL  
);

CREATE TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioMeses
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,CantMeses INT NOT NULL 
);

CREATE TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioTasa
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,Tasa MONEY  NOT NULL 
);

CREATE TABLE dbo.TipodeCuentaTarjetaxRegladeNegocioMonto
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,Monto MONEY NOT NULL 
);

ALTER TABLE dbo.TipodeCuentaTarjetaxRegladeNegocio ADD IdTipoCuenta INT NOT NULL;

ALTER TABLE dbo.TipodeCuentaTarjetaxRegladeNegocio
ADD CONSTRAINT fk_TipodeCuentaTarjetaxRegladeNegocio_TipodeCuentaTarjeta
FOREIGN KEY (IdTipoCuenta)
REFERENCES dbo.TipodeCuentaTarjeta (Id);

ALTER TABLE dbo.TipodeCuentaTarjetaxRegladeNegocio ADD IdRegladeNegocio INT NOT NULL;

ALTER TABLE dbo.TipodeCuentaTarjetaxRegladeNegocio
ADD CONSTRAINT fk_TipodeCuentaTarjetaxRegladeNegocio_RegladeNegocio
FOREIGN KEY (IdRegladeNegocio)
REFERENCES dbo.RegladeNegocio (Id);

CREATE TABLE dbo.EstadodeCuenta
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,Fecha DATETIME NOT NULL
	,Saldo MONEY NOT NULL
	--idSubEstadodeCuenta MONEY NOT NULL FOREIGN KEY REFERENCES SubEstadodeCuenta(id)
);

ALTER TABLE dbo.EstadodeCuenta ADD IdCuentaTarjetaMaestra INT NOT NULL;

ALTER TABLE dbo.EstadodeCuenta
ADD CONSTRAINT fk_EstadodeCuenta_CuentaTarjetaMaestra
FOREIGN KEY (IdCuentaTarjetaMaestra)
REFERENCES dbo.CuentaTarjetaMaestra (Id);

CREATE TABLE dbo.SubEstadodeCuenta
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY 
	,IdEstadodeCuenta INT NOT NULL
	,IdCuentaTarjetaAdicional INT NOT NULL
);

ALTER TABLE dbo.SubEstadodeCuenta
ADD CONSTRAINT fk_SubEstadodeCuenta_CuentaTarjetaAdicional
FOREIGN KEY (IdCuentaTarjetaAdicional)
REFERENCES dbo.CuentaTarjetaAdicional (Id);

CREATE TABLE dbo.Movimiento
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY 
	,Descripcion VARCHAR(1000) NOT NULL
	,Monto MONEY NOT NULL
	,NuevoSaldo MONEY NOT NULL
	,Fecha DATETIME NOT NULL
	,Referencia INT NOT NULL--INT OR VARCHAR
	,IdTipoMovimiento INT NOT NULL
);

ALTER TABLE dbo.Movimiento ADD IdTarjetaFisica INT NOT NULL;

ALTER TABLE dbo.Movimiento
ADD CONSTRAINT fk_Movimiento_TarjetaFisica
FOREIGN KEY (IdTarjetaFisica)
REFERENCES dbo.TarjetaFisica (Id);

--Movimiento references tipomovimiento
CREATE TABLE dbo.TipoMovimiento
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY 
	,Accion VARCHAR(1000) NOT NULL
);

CREATE TABLE dbo.MovimientoSospechoso
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,IdCuentaTarjetaMaestra INT NOT NULL
	,IdTarjetaFisica INT NOT NULL
	,Fecha DATETIME NOT NULL
	,Monto MONEY NOT NULL
	,Descripcion VARCHAR(1000) NOT NULL
	,Referencia INT NOT NULL
);

ALTER TABLE dbo.MovimientoSospechoso
ADD CONSTRAINT fk_MovimientoSospechoso_TarjetaFisica
FOREIGN KEY (IdTarjetaFisica)
REFERENCES dbo.TarjetaFisica (Id);

--ct -> tarjetafisica
CREATE TABLE dbo.TarjetaFisica
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY 
	,Codigo INT NOT NULL
	,CVV INT NOT NULL
	,PIN INT NOT NULL
	,FechaEmision DATETIME NOT NULL
	,FechaInvalidacion DATETIME NOT NULL
	,AñoVencimiento DATETIME NOT NULL
	,MesVencimiento DATETIME NOT NULL
	,IdMotivoInvalidacion INT NOT NULL
	,IdCuentaTarjeta INT NOT NULL
);


ALTER TABLE dbo.TarjetaFisica
ADD CONSTRAINT fk_TarjetaFisica_MotivoInvalidacion
FOREIGN KEY (IdMotivoInvalidacion)
REFERENCES dbo.MotivoInvalidacion (Id);


ALTER TABLE dbo.TarjetaFisica
ADD CONSTRAINT fk_TarjetaFisica_CuentaTarjeta
FOREIGN KEY (IdCuentaTarjeta)
REFERENCES dbo.CuentaTarjeta (Id);


CREATE TABLE dbo.MotivoInvalidacion
(
	Id INT NOT NULL PRIMARY KEY
	,Descripcion VARCHAR(1000) NOT NULL
);


CREATE TABLE dbo.MovimientoInteresCorriente
(
	Id INT NOT NULL PRIMARY KEY
	,Fecha DATETIME NOT NULL
	,Monto MONEY NOT NULL
	,NuevoInteresAcumuladoCorriente MONEY NOT NULL
);



ALTER TABLE dbo.MovimientoInteresCorriente ADD IdCuentaTarjetaMaestra INT NOT NULL;

ALTER TABLE dbo.MovimientoInteresCorriente
ADD CONSTRAINT fk_MovimientoInteresCorriente_CuentaTarjetaMaestra
FOREIGN KEY (IdCuentaTarjetaMaestra)
REFERENCES dbo.CuentaTarjetaMaestra (Id);

CREATE TABLE dbo.TipoMovInteresCorriente
(
	Id INT NOT NULL PRIMARY KEY
	,Nombre VARCHAR(32) NOT NULL
	--1:credito,2:debito
);



CREATE TABLE dbo.MovimientoInteresMoratorio
(
	Id INT NOT NULL PRIMARY KEY
	,Fecha DATETIME NOT NULL
	,Monto MONEY NOT NULL
	,NuevoInteresAcumuladoMoratorio MONEY NOT NULL
);

ALTER TABLE dbo.MovimientoInteresMoratorio ADD IdCuentaTarjetaMaestra INT NOT NULL;

ALTER TABLE dbo.MovimientoInteresMoratorio
ADD CONSTRAINT fk_MovimientoInteresMoratorio_CuentaTarjetaMaestra
FOREIGN KEY (IdCuentaTarjetaMaestra)
REFERENCES dbo.CuentaTarjetaMaestra (Id);


ALTER TABLE dbo.MovimientoInteresMoratorio ADD IdTipoMovimiento INT NOT NULL;

ALTER TABLE dbo.MovimientoInteresMoratorio
ADD CONSTRAINT fk_MovimientoInteresMoratorio_TipoMovInteresMoratorio
FOREIGN KEY (IdTipoMovimiento)
REFERENCES dbo.TipoMovInteresMoratorio (Id);

CREATE TABLE dbo.TipoMovInteresMoratorio
(
	Id INT NOT NULL PRIMARY KEY 
	,Nombre VARCHAR(32) NOT NULL 
	--1:credito,2:debito
);