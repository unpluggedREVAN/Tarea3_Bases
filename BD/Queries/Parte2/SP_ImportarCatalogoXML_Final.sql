CREATE PROCEDURE dbo.SP_ImportarCatalogoXML
	@inRutaXML NVARCHAR(255)
	,@outResultCode INT

AS 
BEGIN
	SET NOCOUNT ON
	
	BEGIN TRY 
		SET @outResultCode = 0; --codigo default cuando no hubo error
		DECLARE @XmlData XML
		SELECT @XmlData = BulkColumn
		FROM OPENROWSET(BULK 'C:\Users\Usuario\Desktop\DB\Queries\XMLBD2_Catalogos.xml', SINGLE_BLOB) AS x

		--Metodo del profesor: En vez de insertar directamente a la tabla dbo.Usuario primero se inserta a @UsuarioAdminXML y luego se inserta de este a dbo.Usuario
		--Primero se crea la tabla @UsuarioAdminXML con sus columnas


		DECLARE @ReglaNegocioXML TABLE(
			Nombre VARCHAR(1024)
			,TCTM VARCHAR(50) --TCTM
			,TipoRN VARCHAR(50) --
			,Valor VARCHAR(256) --En las tablas con su operacion de la regla de negocio se hara la conversion del tiporn correspondiente 
		);
		
		DECLARE @TipoMovimientoXML TABLE(
			Nombre VARCHAR(1024)
			,Accion VARCHAR(258)
			,AcumulaOperacionATM VARCHAR(64)
			,AcumulaOperacionVentana VARCHAR (64)
		);

		-- Crear tabla temporal para NuevasTF
		DECLARE @NuevasTFXML TABLE(
			Numero VARCHAR(16)
		);


		--Transaction en donde se insertara a las tablas
		BEGIN TRANSACTION tImportarCatalogoXML
		--Esta tabla se le debe insertar cada dato  presente en el xml 

		--Se insertan los usuarios administradores 
		INSERT INTO dbo.Usuario (NombreUsuario, Password, EsAdmin)
		SELECT DISTINCT
			x.Usuario.value('@Nombre', 'NVARCHAR(50)') AS Nombre
			, x.Usuario.value('@Password', 'NVARCHAR(50)') AS Password
			, 1 AS EsAdmin --Bit en 1 indica que el usuario es administrador 
		FROM @XmlData.nodes('/root/UA/Usuario') AS x(Usuario)
		WHERE x.Usuario.value('@Nombre','NVARCHAR(50)') NOT IN (SELECT NombreUsuario FROM Usuario)
		AND x.Usuario.value('@Password','NVARCHAR(50)') NOT IN (SELECT Password FROM Usuario)



		--Se insertan los tipos de documento de identidad
		INSERT INTO dbo.TipoDocumentoID(Nombre,Formato)
		SELECT 
			x.tdi.value('@Nombre','NVARCHAR(50)') AS Nombre
			,x.tdi.value('@Formato','NVARCHAR(50)') AS Formato
		FROM @XmlData.nodes('/root/TDI/TDI') AS x(tdi)
		WHERE x.tdi.value('@Nombre','NVARCHAR(50)') NOT IN (SELECT Nombre FROM TipoDOcumentoID)

		--Inserciones para el tipo de cuenta de tarjeta 
		INSERT INTO dbo.TipodeCuentaTarjeta(Nombre)
		SELECT
			x.tctm.value('@Nombre','NVARCHAR(50)') AS Nombre
		FROM @XmlData.nodes('/root/TCTM/TCTM') AS x(tctm)
		WHERE x.tctm.value('@Nombre','NVARCHAR') NOT IN (SELECT Nombre FROM TipodeCuentaTarjeta)

	
		--Inserciones para el tipo de regla de negocio
		INSERT INTO dbo.TipoRegladeNegocio (Nombre,Tipo)
		SELECT
			x.trn.value('@Nombre','NVARCHAR(50)') AS Nombre
			,x.trn.value('@tipo','NVARCHAR(50)') AS Tipo
		FROM @XmlData.nodes('/root/TRN/TRN') AS x(trn)
		WHERE x.trn.value('@Nombre','NVARCHAR(50)') NOT IN (SELECT Nombre FROM TipoRegladeNegocio);

		--Inserciones para Regla de negocio XML
		INSERT INTO @ReglaNegocioXML (Nombre, TCTM ,TipoRN, Valor)
		SELECT 
			x.rn.value('@Nombre','NVARCHAR(1024)') AS Nombre
			,x.rn.value('@TCTM','NVARCHAR(50)') AS TCTM
			,x.rn.value('@TipoRN','NVARCHAR(50)') AS TipoRN
			,x.rn.value('@Valor','NVARCHAR(256)') AS Valor
		FROM @XmlData.nodes('/root/RN/RN') AS x(rn)

		INSERT INTO dbo.RegladeNegocio (NombreRegla,IdTipoRegla, Valor, IdTipoCuenta)
		SELECT 
			rn.Nombre
			,trn.Id --Id del tipo de regla 
			,CASE rn.TipoRN
				WHEN 'Monto Monetario' THEN CAST(rn.Valor AS MONEY)--()
				WHEN 'Porcentaje' THEN CAST(rn.Valor AS FLOAT)--('30', AS FLOAT)???
				WHEN 'Cantidad de Dias' THEN CAST(rn.Valor AS INT)
				WHEN 'Cantidad de Operaciones' THEN CAST(rn.Valor AS INT)
			 END
			,tc.Id --Id del tipo de cuenta
		FROM @ReglaNegocioXML rn
		INNER JOIN dbo.TipodeCuentaTarjeta tc ON rn.TCTM = tc.Nombre
		INNER JOIN dbo.TipoRegladeNegocio trn ON rn.TipoRN = trn.Nombre
		WHERE rn.Nombre NOT IN (SELECT NombreRegla FROM RegladeNegocio)


		--Inserciones para Motivo invalidacion tarjeta
		INSERT INTO dbo.MotivoInvalidacion (Descripcion)
		SELECT
			x.mit.value('@Nombre','NVARCHAR(50)') AS Descripcion
		FROM @XmlData.nodes('/root/MIT/MIT') AS x(mit)
		WHERE x.mit.value('@Nombre','NVARCHAR(50)') NOT IN (SELECT Descripcion FROM MotivoInvalidacion);
		
		--Inserciones para tipo de movimiento en la tabla Variable XML
		INSERT INTO @TipoMovimientoXML (Nombre,Accion, AcumulaOperacionATM, AcumulaOperacionVentana)
		SELECT 
			x.tm.value('@Nombre','NVARCHAR(1024)') AS Nombre 
			,x.tm.value('@Accion','NVARCHAR(1024)') AS Accion
			,x.tm.value('@Acumula_Operacion_ATM','NVARCHAR(1024)') AS AcumulaOperacionATM
			,x.tm.value('@Acumula_Operacion_Ventana','NVARCHAR(1024)') AS AcumulaOperacionVentana
		FROM @XmlData.nodes('/root/TM/TM') AS x(tm)

		--Ahora se inserta en la tabla de la BD
		INSERT INTO dbo.TipoMovimiento(Nombre,Accion,AcumulaOperacionATM,AcumulaOperacionVentana) 
		SELECT tm.Nombre
			,tm.Accion
			,CASE 
				WHEN (tm.AcumulaOperacionATM = 'SI') THEN 1  --Bit en 1 
				WHEN (tm.AcumulaOperacionATM = 'NO') THEN 0  --Bit en 0
			 END 
			,CASE 
				WHEN (tm.AcumulaOperacionVentana = 'SI') THEN 1 --Bit en 1 
				WHEN (tm.AcumulaOperacionVentana = 'NO') THEN 0 --Bit en 0
			 END
		FROM @TipoMovimientoXML tm
		WHERE tm.Nombre NOT IN (SELECT Nombre FROM TipoMovimiento)

		--Inserciones para el top de movimiento interes
		INSERT INTO dbo.TipoMovimientoInteres(Nombre,Accion)
		SELECT 
			x.tmti.value('@Nombre','NVARCHAR(50)') AS Nombre
			,x.tmti.value('@Accion','NVARCHAR(50)') AS Accion
		FROM @XmlData.nodes('/root/TMTI/TMTI') AS x(tmti)
		WHERE x.tmti.value('@Nombre','NVARCHAR(50)') NOT IN (SELECT Nombre FROM TipoMovimientoInteres)

		-- Insertar datos en la tabla temporal @NuevasTFXML
		INSERT INTO @NuevasTFXML (Numero)
		SELECT 
			x.tf.value('@Numero','VARCHAR(16)') AS Numero
		FROM @XmlData.nodes('/root/NuevasTF/NuevaTF') AS x(tf)

		-- Insertar datos en la tabla NuevaTarjetaFisica
		INSERT INTO dbo.NuevaTarjetaFisica (NumeroTarjetaFisica)
		SELECT 
			tf.Numero
		FROM @NuevasTFXML tf
		WHERE tf.Numero NOT IN (SELECT NumeroTarjetaFisica FROM NuevaTarjetaFisica)


	COMMIT TRANSACTION tImportarCatalogoXML
	END TRY 
	
	BEGIN CATCH
		-- Validamos la transaccion en caso de errores
		IF @@TRANCOUNT>0    -- Si este valor es mayor que 1, hay un error 
		BEGIN
			ROLLBACK TRANSACTION tImportarCatalogoXML  -- Se deshacen los cambios realizados
		END;
	--Se insertan la informacion del error a la tabla de errores
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

	SET NOCOUNT OFF 
END 