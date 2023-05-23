CREATE PROCEDURE dbo.SP_ImportarOperacionesXML
    @inRutaXML NVARCHAR(255),
    @outResultCode INT OUTPUT
AS 
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY 
        SET @outResultCode = 0;
        DECLARE @XmlData XML;
		SELECT @XmlData = BulkColumn
		FROM OPENROWSET(BULK 'C:\Users\Usuario\Desktop\DB\Queries\XMLBD2_Operaciones.xml', SINGLE_BLOB) AS x

        DECLARE @fechaOperacion TABLE (Fecha DATE);
        DECLARE @FechaItera DATE
			, @FechaFinal DATE;

        -- Tablas temporales para cada nodo del XML

		DECLARE @NuevosTH TABLE(
			Nombre VARCHAR(256)
			, Tipo_Doc_Identidad VARCHAR(256) 
			, Valor_Doc_Identidad VARCHAR(256)
			, NombreUsuario VARCHAR(256)
			, Password VARCHAR(256) 
		);

		DECLARE @NuevosTCM TABLE(
			Codigo VARCHAR(1024)
			, TipoCTM VARCHAR(50)
			, LimiteCredito VARCHAR(50) 
			, TH VARCHAR(256) 
		);

		DECLARE @NuevosTCA TABLE(
			CodigoTCM VARCHAR(1024)
			, CodigoTCA VARCHAR(50)
			, TH VARCHAR(50) --
		);

		DECLARE @NuevosTF TABLE(
			Codigo VARCHAR(1024)
			, TCAsociada VARCHAR(50)
			, MesVencimiento INT
			, AñoVencimiento INT
			--, FechaVencimiento VARCHAR(50)
			, CCV VARCHAR(256)
		);

		DECLARE @NuevosMovimientos TABLE(
			Nombre VARCHAR(1024)
			, TF VARCHAR(50) 
			, FechaMovimiento VARCHAR(50) 
			, Monto VARCHAR(256) 
			, Descripcion VARCHAR(50)
			, Referencia VARCHAR(50) 
		);

		-- Declaramos una tabla temporal para almacenar los datos del XML (Usuarios no administradores)
		DECLARE @NuevosUsuarios TABLE(
			FechaOperacion DATE
			, NombreUsuario varchar(250)
			, Password varchar(128)
		);

        -- Extraer todas las fechas del XML y almacenarlas en @fechaOperacion
        INSERT INTO @fechaOperacion (Fecha)
        SELECT T.c.value('@Fecha', 'DATE') AS Fecha
        FROM @XmlData.nodes('/root/fechaOperacion') AS T(c);

        SELECT @FechaItera = MIN(F.Fecha)
				, @FechaFinal = MAX(F.Fecha)
        FROM @fechaOperacion F;

		BEGIN TRANSACTION tImportarOperacionesXML

		--Validación de XML nulo
		IF (@inRutaXML IS NULL)
		BEGIN
			-- Procesar error xml archivo no pasado o no existe
			SET @outResultadoCode = 50008;
			RETURN @outResultadoCode;
		END;

        WHILE (@FechaItera <= @FechaFinal)
        BEGIN

			IF EXISTS (SELECT 1 FROM @fechaOperacion WHERE Fecha = @FechaItera)
				BEGIN

					-- Extraer del XML los nuevos TH e insertarlos en @NuevosTH
					INSERT INTO @NuevosTH (Nombre, Tipo_Doc_Identidad, Valor_Doc_Identidad, NombreUsuario, Password)
					SELECT 
						T.th.value('@Nombre', 'NVARCHAR(256)') AS Nombre,
						T.th.value('@Tipo_Doc_Identidad', 'NVARCHAR(256)') AS Tipo_Doc_Identidad,
						T.th.value('@Valor_Doc_Identidad', 'NVARCHAR(256)') AS Valor_Doc_Identidad,
						T.th.value('@NombreUsuario', 'NVARCHAR(256)') AS NombreUsuario,
						T.th.value('@Password', 'NVARCHAR(256)') AS Password
					FROM @XmlData.nodes('/root/fechaOperacion/TH/TH') AS T(th)
					LEFT JOIN @NuevosTH AS N
					ON N.Valor_Doc_Identidad = T.th.value('@Valor_Doc_Identidad', 'NVARCHAR(256)')
					AND N.Nombre = T.th.value('@Nombre', 'NVARCHAR(256)')
					WHERE T.th.value('@Fecha', 'DATE') = @FechaItera
					AND N.Valor_Doc_Identidad IS NULL;

					-- Repite este patrón para NTCM, NTCA, NTF y Movimiento
					-- Insertar en @NuevosTCM
					INSERT INTO @NuevosTCM (Codigo, TipoCTM, LimiteCredito, TH)
					SELECT 
						T.tcm.value('@Codigo', 'NVARCHAR(64)') AS Codigo,
						T.tcm.value('@TipoCTM', 'NVARCHAR(64)') AS TipoCTM,
						T.tcm.value('@LimiteCredito', 'NVARCHAR(64)') AS LimiteCredito,
						T.tcm.value('@TH', 'NVARCHAR(64)') AS TH,
						F.Fecha AS fechaCreacion
					FROM @XmlData.nodes('/root/fechaOperacion/NTCM/NTCM') AS T(tcm)
					INNER JOIN @fechaOperacion F ON Fecha = T.tcm.value('../../@Fecha', 'DATE')
					LEFT JOIN @NuevosTCM AS N
					ON N.Codigo = T.tcm.value('@Codigo', 'NVARCHAR(64)')
					WHERE T.tcm.value('@Fecha', 'DATE') = @FechaItera
					AND N.Codigo IS NULL;
					
					-- Insertar en @NuevosTCA
					INSERT INTO @NuevosTCA (CodigoTCM, CodigoTCA, TH)
					SELECT 
						T.tca.value('@CodigoTCM', 'NVARCHAR(64)') AS CodigoTCM,
						T.tca.value('@CodigoTCA', 'NVARCHAR(64)') AS CodigoTCA,
						T.tca.value('@TH', 'NVARCHAR(64)') AS TH,
						F.Fecha AS fechaCreacion
					FROM @XmlData.nodes('/root/fechaOperacion/NTCA/NTCA') AS T(tca)
					INNER JOIN @fechaOperacion F ON Fecha = T.tca.value('../../@Fecha', 'DATE')
					LEFT JOIN @NuevosTCA AS N
					ON N.CodigoTCA = T.tca.value('@CodigoTCA', 'NVARCHAR(64)')
					WHERE T.tca.value('(Fecha/text())[1]', 'DATE') = @FechaItera
					AND N.CodigoTCA IS NULL;

					-- Insertar en @NuevosTF
					INSERT INTO @NuevosTF (Codigo, TCAsociada, MesVencimiento, AñoVencimiento, CCV)
					SELECT 
						T.tf.value('@Codigo', 'NVARCHAR(64)') AS Codigo,
						T.tf.value('@TCAsociada', 'NVARCHAR(64)') AS TCAsociada,
						PARSE(t.fechaVence AS date USING 'en-US').Month AS MesVencimiento,
						PARSE(t.fechaVence AS date USING 'en-US').Year AS AñoVencimiento,
						T.tf.value('@CCV', 'NVARCHAR(64)') AS CCV
					FROM @XmlData.nodes('/root/fechaOperacion/NTF/NTF') AS T(tf)
					CROSS APPLY(
						SELECT T.tf.value('@FechaVencimiento', 'NVARCHAR(10)') AS fechaVence
					) AS t
					LEFT JOIN @NuevosTF AS N
					ON N.Codigo = T.tf.value('@Codigo', 'NVARCHAR(64)')
					AND N.CCV = T.tf.value('@CCV','INT')
					WHERE T.tf.value('(Fecha/text())[1]', 'DATE') = @FechaItera
					AND N.Codigo IS NULL AND N.CCV IS NULL;

					-- Código y CVV no pueden existir dos veces (no estoy seguro si el CVV)

					-- Insertar en @NuevosMovimientos
					INSERT INTO @NuevosMovimientos (Nombre, TF, FechaMovimiento, Monto, Descripcion, Referencia)
					SELECT 
						T.m.value('@Nombre', 'NVARCHAR(64)') AS Nombre, 
						T.m.value('@TF', 'NVARCHAR(64)') AS TF,
						T.m.value('@FechaMovimiento', 'NVARCHAR(64)') AS FechaMovimiento,
						T.m.value('@Monto', 'NVARCHAR(64)') AS Monto,
						T.m.value('@Descripcion', 'NVARCHAR(64)') AS Descripcion,
						T.m.value('@Referencia', 'NVARCHAR(64)') AS Referencia
					FROM @XmlData.nodes('/root/fechaOperacion/Movimiento/Movimiento') AS T(m)
					LEFT JOIN @NuevosMovimientos AS N
					ON N.TF = T.m.value('@TF', 'NVARCHAR(64)')
					AND N.FechaMovimiento = T.m.value('@FechaMovimiento', 'DATE')
					AND N.Referencia = T.m.value('@Referencia', 'NVARCHAR(10)')
					WHERE T.m.value('(Fecha/text())[1]', 'DATE') = @FechaItera
					AND N.TF IS NULL AND N.FechaMovimiento IS NULL AND N.Referencia IS NULL;

					-- Se insertan los usuarios en la tabla temporal
					INSERT INTO @NuevosUsuarios (FechaOperacion, NombreUsuario, Password)
					SELECT 
						T.c.value('../../@Fecha', 'date') as FechaOperacion,
						T.c.value('@NombreUsuario', 'varchar(250)') as NombreUsuario,
						T.c.value('@Password', 'varchar(128)') as Password
					FROM @XmlData.nodes('/root/fechaOperacion/TH/TH') as T(c)

					-- Insertamos los datos de la tabla temporal en la tabla Usuario
					INSERT INTO Usuario (NombreUsuario, Password, EsAdmin)
					SELECT 
						NombreUsuario
						, Password
						, 0
					FROM @NuevosUsuarios

					-- Insertar en dbo.TarjetaHabiente
					INSERT INTO dbo.TarjetaHabiente(Nombre, IdTipoDocumentoID, ValorDocumentoID, Usuario, Password)
					SELECT DISTINCT
						oth.Nombre,
						TipoDocumentoID.id,
						oth.ValorDocumentoID,
						oth.Usuario,
						oth.Password
					FROM @NuevosTH oth
					INNER JOIN TipoDocumentoID 
					ON LOWER(TipoDocumentoID.Nombre) = LOWER(oth.IdTipoDocumentoID)
					LEFT JOIN TarjetaHabiente TH
					ON TH.ValorDocumentoID = oth.ValorDocumentoID
					AND TH.IdTipoDocumentoID = TipoDocumentoID.id
					WHERE TH.ValorDocumentoID IS NULL AND TH.IdTipoDocumentoID IS NULL;

					-- Considerar cambio
					-- Insertar en CuentaTarjetaCredito
					INSERT INTO CuentaTarjetaCredito(Codigo, EsMaestra, idTipoCuenta, FechaCreacion)
					SELECT DISTINCT
						ntcm.Codigo,
						1,
						TipodeCuentaTarjeta.id,
						ntcm.FechaCreacion
					FROM @NuevosTCM ntcm
					INNER JOIN TipodeCuentaTarjeta ON LOWER(TipodeCuentaTarjeta.Nombre) = LOWER(ntcm.TipoCTM)
					LEFT JOIN CuentaTarjetaCredito CTC ON CTC.Codigo = ntcm.Codigo AND CTC.esMaestra = 1 AND CTC.idTCT = TipodeCuentaTarjeta.id
					WHERE CTC.Codigo IS NULL
					UNION ALL
					SELECT DISTINCT
						ntca.CodigoCTA,
						0,
						NULL,
						ntca.FechaCreacion
					FROM @NuevosTCA ntca
					LEFT JOIN CuentaTarjetaCredito CTC ON CTC.Codigo = ntca.CodigoCTA AND CTC.esMaestra = 0
					WHERE CTC.Codigo IS NULL;

					-- Insertar en las tablas de la base de datos correspondientes: NTCM, NTCA, NTF y Movimiento

					-- Insertar en dbo.CuentaTarjetaMaestra
					INSERT INTO dbo.CuentaTarjetaMaestra(IdTarjetaHabiente, IdCuentaTarjeta, LimiteCredito)
					SELECT DISTINCT
						TarjetaHabiente.id,
						CuentaTarjetaCredito.id,
						ntcm.LimiteCredito
					FROM @NuevosNTCM ntcm
					INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaCredito.Codigo = ntcm.Codigo AND CuentaTarjetaCredito.esMaestra = 1
					INNER JOIN TarjetaHabiente ON NuevoTH.valorDocId = ntcm.idDocumentoTH
					LEFT JOIN CuentaTarjetaMaestra CTM ON CTM.idCT = CuentaTarjetaCredito.id
					WHERE CTM.idCT IS NULL;

					-- No necesariamente a la hora de crear cuenta, sino activado por las fechas

					-- Create Trigger, crear un trigger IF NOT EXISTS, después que algo ocurra, ejemplo:
					-- CREATE TRIGGER IF NOT EXISTS actualizar_estado_cuenta AFTER INSERT INTO CTM
					
					--Trigger cuando sucede un insert ON CTM y en el trigger se crea un estado de cuenta 

					-- Crear un Trigger conectado con una fecha o store almacenado, y de acuerdo a si pasa el tiempo, crear un 
					-- estado de cuenta.


					SELECT * FROM dbo.CuentaTarjetaAdicional; -- Quitar/Solo prueba


					-- Insertar en dbo.CuentaTarjetaAdicional
					INSERT INTO dbo.CuentaTarjetaAdicional(IdCuentaMaestra, IdTarjetaHabiente, IdCuentaTarjeta)
					SELECT DISTINCT
						CuentaTarjetaMaestra.id,
						NuevosTH.id,
						CuentaTarjetaCredito.id
					FROM @NuevosTCA ntca
					INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaCredito.Codigo = ntca.CodigoCTA AND CuentaTarjetaCredito.esMaestra = 0
					INNER JOIN CuentaTarjetaMaestra ON CuentaTarjetaMaestra.idCT = (
						SELECT id
						FROM CuentaTarjetaCredito
						WHERE Codigo = ntca.CodigoCTM AND esMaestra = 1
					)
					INNER JOIN TarjetaHabiente ON TarjetaHabiente.valorDocId = ntca.idDocumentoTH
					LEFT JOIN CuentaTarjetaAdicional CTA ON CTA.idCT = CuentaTarjetaCredito.id AND CTA.idCTM = CuentaTarjetaMaestra.id AND CTA.idTHPertenece = TarjetaHabiente.id
					WHERE CTA.idCT IS NULL AND CTA.idCTM IS NULL AND CTA.idTHPertenece IS NULL;

					SELECT * FROM dbo.TarjetaFisica;
					INSERT INTO dbo.TarjetaFisica(Codigo, CVV, Pin, FechaEmision, FechaInvalidacion, AñoVencimiento, MesVencimiento, IdCuentaTarjeta, IdMotivoInvalidacion)
					SELECT ...
					FROM @NuevosNTF tf; -- Utilizar el siguiente/Pero se debe adaptar, al igual que el resto


					--Trigger cuando sucede un insert ON CTA

					-- Insertar en TarjetaFisica
					INSERT INTO TarjetaFisica(Codigo, idCT, MesVence, AñoVence, CVV)
					SELECT DISTINCT
						ntf.Codigo,
						CuentaTarjetaCredito.id,
						ntf.MesVence,
						ntf.AñoVence,
						ntf.CCV
					FROM @NuevosTF ntf
					INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaCredito.Codigo = ntf.CTCodigoAsociada
					LEFT JOIN TarjetaFisica TF ON TF.idCT = CuentaTarjetaCredito.id AND TF.Codigo = ntf.Codigo
					WHERE TF.idCT IS NULL AND TF.Codigo IS NULL;

					INSERT INTO dbo.Movimiento(Descripcion, Monto, NuevoSaldo, Fecha, Referencia, IdTipoMovimiento, IdEstadoCuenta, IdTarjetaFisica)
					SELECT ...
					FROM @NuevosMovimientos m;

				END -- Fin del IF

--JUAN:
			--Iniciar proceso diario para cada TCM:
				
				-- Procesar movimientos
				DECLARE @NombreMovimiento NVARCHAR(256);
				DECLARE @TF NVARCHAR(256);
				DECLARE @FechaMovimiento DATE;
				DECLARE @Monto DECIMAL(18, 2);
				DECLARE @Descripcion NVARCHAR(256);
				DECLARE @Referencia NVARCHAR(256);



				DECLARE mov_cursor CURSOR FOR 
				SELECT m.Nombre, m.TF, m.FechaMovimiento, m.Monto, m.Descripcion, m.Referencia
				FROM @NuevosMovimientos m;

				OPEN mov_cursor
				FETCH NEXT FROM mov_cursor INTO @NombreMovimiento, @TF, @FechaMovimiento, @Monto, @Descripcion, @Referencia

				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Aquí puedes realizar las operaciones necesarias para procesar cada movimiento.
					-- Por ejemplo, puedes actualizar el saldo de la cuenta asociada a la tarjeta física.

					-- Actualizar el saldo de la cuenta asociada a la tarjeta física
					UPDATE dbo.CuentaTarjeta
					SET Saldo = Saldo - @Monto
					WHERE IdTarjetaFisica = (SELECT Id FROM dbo.TarjetaFisica WHERE Codigo = @TF);

					-- Registrar el movimiento en una tabla de movimientos
					SELECT * FROM dbo.Movimiento
					ALTER TABLE dbo.Movimiento ADD Nombre VARCHAR(1000) NOT NULL;
					INSERT INTO dbo.Movimiento(Nombre, IdTarjetaFisica, Fecha, Monto, Descripcion, Referencia,idEstadoCuenta,NuevoSaldo)
					VALUES (@NombreMovimiento, (SELECT Id FROM dbo.TarjetaFisica WHERE Codigo = @TF), @FechaMovimiento, @Monto, @Descripcion, @Referencia);

					FETCH NEXT FROM mov_cursor INTO @NombreMovimiento, @TF, @FechaMovimiento, @Monto, @Descripcion, @Referencia
				END

				CLOSE mov_cursor;
				DEALLOCATE mov_cursor;

				--Procesar vencimientos de TF
				-- Actualiza el estado de la tarjeta física si la fecha de vencimiento es igual a @FechaItera
				UPDATE TarjetaFisica
				SET EstadoTF = 0
				WHERE FechaVencimiento = @FechaItera
						
				--HAY QUE GENERAR NUEVO TF 

				--Calcular intereses
				EXECUTE CalcularInteresCorriente @FechaItera
				EXECUTE CalcularInteresMoratorio @FechaItera

				--SI TCM tiene corte en @FechaItera, es decir, que @fechaItera es igual a fecha creacion tarjeta 
				--Funcion para verificar si se cumple esto, y aqui ejecutar:
					--Cerrar EC del TCM
					--Abrir EC del TCM
				--Fin SI

			-- Actualizar @FechaItera para el próximo ciclo
			SET @FechaItera = DATEADD(day, 1, @FechaItera);

		END -- Fin del WHILE

	COMMIT TRANSACTION tImportarOperacionesXML
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION tImportarOperacionesXML;
		END;

		INSERT INTO dbo.DBErrors    VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);

		SET @outResultCode = 50005;

	END CATCH

	SET NOCOUNT OFF;
END