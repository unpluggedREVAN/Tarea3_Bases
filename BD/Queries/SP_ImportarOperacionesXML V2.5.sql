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
							T.th.value('@Nombre', 'NVARCHAR(256)') AS Nombre
							, T.th.value('@Tipo_Doc_Identidad', 'NVARCHAR(256)') AS Tipo_Doc_Identidad
							, T.th.value('@Valor_Doc_Identidad', 'NVARCHAR(256)') AS Valor_Doc_Identidad
							, T.th.value('@NombreUsuario', 'NVARCHAR(256)') AS NombreUsuario
							, T.th.value('@Password', 'NVARCHAR(256)') AS Password
					FROM @XmlData.nodes('/root/fechaOperacion/TH/TH') AS T(th)
					WHERE T.th.value('@Fecha', 'DATE') = @FechaItera; --
					WHERE NOT EXISTS (SELECT 1 FROM @NuevosTH
					WHERE Valor_Doc_Identidad = x.TH.value('@Valor_Doc_Identidad', 'NVARCHAR(256)')
						AND Nombre = x.th.value('@Nombre', 'VARCHAR(32)')
					)

					-- Repite este patrón para NTCM, NTCA, NTF y Movimiento
					INSERT INTO @NuevosTCM (Codigo, TipoCTM, LimiteCredito, TH)
					SELECT 
							T.tcm.value('@Codigo', 'NVARCHAR(64)') AS Codigo
							, T.tcm.value('@TipoCTM', 'NVARCHAR(64)') AS TipoCTM
							, T.tcm.value('@LimiteCredito', 'NVARCHAR(64)') AS LimiteCredito
							, T.tcm.value('@TH', 'NVARCHAR(64)') AS TH
							, F.Fecha AS fechaCreacion
					FROM @XmlData.nodes('/root/fechaOperacion/NTCM/NTCM') AS T(tcm)
					WHERE T.tcm.value('@Fecha', 'DATE') = @FechaItera;
					INNER JOIN @fechaOperacion F ON Fecha = T.tcm.value('../../@Fecha', 'DATE')
					WHERE NOT EXISTS (SELECT 1 FROM @NuevosTCM
						WHERE Codigo = T.tcm.value('@Codigo', 'NVARCHAR(64)')
					)

					/* El único valor que no podría repetirse acá es el código de una tarjeta, ya que no pueden haber más de una
					tarjeta con mismo código, pero un TH si puede tener múltiples NCTM, y los tipos pueden variar o repetirse */

					INSERT INTO @NuevosTCA (CodigoTCM, CodigoTCA, TH)
					SELECT 
							T.tca.value('@CodigoTCM', 'NVARCHAR(64)') AS CodigoTCM
							, T.tca.value('@CodigoTCA', 'NVARCHAR(64)') AS CodigoTCA
							, T.tca.value('@TH', 'NVARCHAR(64)') AS TH
							, F.Fecha AS fechaCreacion
					FROM @XmlData.nodes('/root/fechaOperacion/NTCA/NTCA') AS T(tca)
					WHERE T.tca.value('(Fecha/text())[1]', 'DATE') = @FechaItera;
					INNER JOIN @fechaOperacion F ON Fecha = T.tca.value('../../@Fecha', 'DATE')
					WHERE NOT EXISTS (SELECT 1 FROM @NuevosTCA
						WHERE CodigoCTA = T.tca.value('@CodigoTCA', 'NVARCHAR(64)')
					)

					INSERT INTO @NuevosTF (Codigo, TCAsociada, MesVencimiento, AñoVencimiento, CCV) -- Hubo cambio de la tabla
					SELECT 
							T.tf.value('@Codigo', 'NVARCHAR(64)') AS Codigo
							, T.tf.value('@TCAsociada', 'NVARCHAR(64)') AS TCAsociada
							, CAST(SUBSTRING(fechaVence, 1, CHARINDEX('/', fechaVence) - 1 ) AS INT) AS MesVencimiento
							, CAST(SUBSTRING(fechaVence,
											CHARINDEX('/', fechaVence) + 1,
											LEN(fechaVence) - CHARINDEX('/', fechaVence) + 1) AS INT) AS AñoVencimiento
							--, T.tf.value('@FechaVencimiento', 'NVARCHAR(64)') AS FechaVencimiento
							, T.tf.value('@CCV', 'NVARCHAR(64)') AS CCV
					FROM @XmlData.nodes('/root/fechaOperacion/NTF/NTF') AS T(tf)
					WHERE T.tf.value('(Fecha/text())[1]', 'DATE') = @FechaItera;
					CROSS APPLY(
						SELECT T.tf.value('@FechaVencimiento', 'NVARCHAR(10)') AS fechaVence   -- definimos una variable local a cada recorrido
						-- Sea fecha vence un valor como 6/2023, primer valor mes, segundo año
					) AS t
					WHERE NOT EXISTS (SELECT 1 FROM @NuevosTF
						WHERE Codigo = T.tf.value('@Codigo', 'NVARCHAR(64)')
						AND CCV = T.tf.value('@CCV','INT')
					)

					-- Código y CVV no pueden existir dos veces (no estoy seguro si el CVV)

					INSERT INTO @NuevosMovimientos (Nombre, TF, FechaMovimiento, Monto, Descripcion, Referencia)
					SELECT 
							T.m.value('@Nombre', 'NVARCHAR(64)') AS Nombre, 
							, T.m.value('@TF', 'NVARCHAR(64)') AS TF
							, T.m.value('@FechaMovimiento', 'NVARCHAR(64)') AS FechaMovimiento
							, T.m.value('@Monto', 'NVARCHAR(64)') AS Monto
							, T.m.value('@Descripcion', 'NVARCHAR(64)') AS Descripcion
							, T.m.value('@Referencia', 'NVARCHAR(64)') AS Referencia
					FROM @XmlData.nodes('/root/fechaOperacion/Movimiento/Movimiento') AS T(m)
					WHERE T.m.value('(Fecha/text())[1]', 'DATE') = @FechaItera;
					WHERE NOT EXISTS(SELECT 1 FROM @NuevosMovimientos
						WHERE TF = T.m.value('@TF', 'NVARCHAR(64)') 
						AND   FechaMovimiento = T.m.value('@FechaMovimiento', 'DATE')
						AND   Referencia = T.m.value('@Referencia', 'NVARCHAR(10)')
					)
					

					-- Tratar a los usuarios

					-- Insertar en la tabla TarjetaHabiente lo contenido en @NuevosTH
					-- y mapearlo con inner join para obtener los Id
					INSERT INTO dbo.TarjetaHabiente(Nombre, IdTipoDocumentoID, ValorDocumentoID, Usuario, Password)
					SELECT DISTINCT
						oth.Nombre
						, TipoDocumentoID.id
						, ValorDocumentoID
						, Usuario
						, Password
					FROM @NuevosTH oth;
					INNER JOIN TipoDocumentoID ON LOWER(TipoDocumentoID.Nombre) = LOWER(oth.IdTipoDocumentoID)
					WHERE NOT EXISTS(
						SELECT 1 FROM TarjetaHabiente
						WHERE ValorDocumentoID = oth.ValorDocumentoID
						AND IdTipoDocumentoID = TipoDocumentoID.id
					)

					-- Considerar cambio
					INSERT INTO CuentaTarjetaCredito(Codigo, esMaestra, idTCT, FechaCreacion) -- Considerar/Cambiar CT
					SELECT DISTINCT
						ntcm.Codigo
						, 1
						, TipodeCuentaTarjeta.id
						, ntcm.FechaCreacion
					FROM @NuevosTCM ntcm
					INNER JOIN TipodeCuentaTarjeta ON LOWER(TipodeCuentaTarjeta.Nombre) = LOWER(ntcm.TipoCTM)
					WHERE NOT EXISTS(
						SELECT 1 FROM CuentaTarjetaCredito
						WHERE Codigo = ntcm.Codigo
						AND esMaestra = 1
						AND idTCT = TipodeCuentaTarjeta.id
					)
					UNION ALL
					SELECT DISTINCT
						ntca.CodigoCTA
						, 0
						, NULL
						, ntca.FechaCreacion
					FROM @NuevosTCA ntca
					WHERE NOT EXISTS(
						SELECT 1 FROM CuentaTarjetaCredito
						WHERE Codigo = ntca.CodigoCTA
						AND esMaestra = 0
					)

					-- Insertar en las tablas de la base de datos correspondientes: NTCM, NTCA, NTF y Movimiento
					INSERT INTO dbo.CuentaTarjetaMaestra(IdTarjetaHabiente, IdCuentaTarjeta, LimiteCredito) -- Considerar InteresAcumuladoCorriente, InteresAcumuladoMoratorio
					SELECT DISTINCT
						TarjetaHabiente.id -- Cambiar/revisar
						, CuentaTarjetaCredito.id
						, ntcm.LimiteCredito
					FROM @NuevosNTCM ntcm;
					INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaCredito.Codigo = ntcm.Codigo AND CuentaTarjetaCredito.esMaestra = 1
					-- Hacemos inner join cuando haya conexión con la cuenta y cuando dicho valor es de cuenta maestra
					INNER JOIN TarjetaHabiente ON NuevoTH.valorDocId = ntcm.idDocumentoTH
					WHERE NOT EXISTS(
						SELECT 1 FROM CuentaTarjetaMaestra
						WHERE idCT = CuentaTarjetaCredito.id
					)

					-- No necesariamente a la hora de crear cuenta, sino activado por las fechas

					-- Create Trigger, crear un trigger IF NOT EXISTS, después que algo ocurra, ejemplo:
					-- CREATE TRIGGER IF NOT EXISTS actualizar_estado_cuenta AFTER INSERT INTO CTM

					-- Crear un Trigger conectado con una fecha o store almacenado, y de acuerdo a si pasa el tiempo, crear un 
					-- estado de cuenta.

					INSERT INTO dbo.CuentaTarjetaAdicional(IdCuentaMaestra, IdTarjetaHabiente, IdCuentaTarjeta)
					SELECT DISTINCT
						CuentaTarjetaMaestra.id -- Cambiar/revisar
						, NuevosTH.id -- Cambiar/revisar
						, CuentaTarjetaCredito.id -- Cambiar/revisar
					FROM @NuevosTCA ntca;
					INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaCredito.Codigo = ntca.CodigoCTA AND CuentaTarjetaCredito.esMaestra = 0
					INNER JOIN CuentaTarjetaMaestra ON CuentaTarjetaMaestra.idCT = (
						SELECT id
						FROM CuentaTarjetaCredito
						WHERE Codigo = ntca.CodigoCTM AND esMaestra = 1
					)
					INNER JOIN TarjetaHabiente ON TarjetaHabiente.valorDocId = ntca.idDocumentoTH
					WHERE NOT EXISTS(
						SELECT 1 FROM CuentaTarjetaAdicional 
						WHERE idCT = CuentaTarjetaCredito.id
							AND idCTM = CuentaTarjetaMaestra.id
							AND idTHPertenece = TarjetaHabiente.id
					)

					INSERT INTO dbo.TarjetaFisica(Codigo, CVV, Pin, FechaEmision, FechaInvalidacion, AñoVencimiento, MesVencimiento, IdCuentaTarjeta, IdMotivoInvalidacion)
					SELECT ...
					FROM @NuevosNTF tf; -- Utilizar el siguiente/Pero se debe adaptar, al igual que el resto

					INSERT INTO TarjetaFisica(Codigo, idCT, MesVence, AñoVence, CVV)
					SELECT DISTINCT
						ntf.Codigo
						, CuentaTarjetaCredito.id
						, ntf.MesVence
						, ntf.AñoVence
						, ntf.CCV
					FROM @NuevosTF ntf   -- temporary new tarjeta fisica
					INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaCredito.Codigo = ntf.CTCodigoAsociada
					WHERE NOT EXISTS(
						SELECT 1 FROM TarjetaFisica
						WHERE idCT = CuentaTarjetaCredito.id
						AND Codigo = ntf.Codigo
					)

					INSERT INTO dbo.Movimiento(Descripcion, Monto, NuevoSaldo, Fecha, Referencia, IdTipoMovimiento, IdEstadoCuenta, IdTarjetaFisica)
					SELECT ...
					FROM @NuevosMovimientos m;

				END -- Fin del IF

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
					INSERT INTO dbo.Movimientos(Nombre, IdTarjetaFisica, Fecha, Monto, Descripcion, Referencia)
					VALUES (@NombreMovimiento, (SELECT Id FROM dbo.TarjetaFisica WHERE Codigo = @TF), @FechaMovimiento, @Monto, @Descripcion, @Referencia);

					FETCH NEXT FROM mov_cursor INTO @NombreMovimiento, @TF, @FechaMovimiento, @Monto, @Descripcion, @Referencia
				END

				CLOSE mov_cursor;
				DEALLOCATE mov_cursor;

				--Procesar vencimientos de TF
				--Calcular intereses

				-- Declarar variables
				DECLARE @SaldoActual DECIMAL(18,2);
				DECLARE @TasaInteresCorriente DECIMAL(5,2);
				DECLARE @MontoDebitoInteresesCorrientes DECIMAL(18,2);
				DECLARE @SaldoInteresesCorrientes DECIMAL(18,2);

				-- Inicializar la tasa de interés corriente (esto debe ser reemplazado por la regla de negocio real para obtener la tasa)
				SET @TasaInteresCorriente = 1.0; -- Por ejemplo, 1%

				-- Cursor para iterar sobre todas las Cuentas Tarjeta Maestra (CTM) con saldo actual mayor a cero
				DECLARE ctm_cursor CURSOR FOR 
				SELECT SaldoActual, SaldoInteresesCorrientes
				FROM dbo.CuentaTarjetaMaestra
				WHERE SaldoActual > 0;

				OPEN ctm_cursor
				FETCH NEXT FROM ctm_cursor INTO @SaldoActual, @SaldoInteresesCorrientes

				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Calcular el monto del débito de intereses corrientes
					SET @MontoDebitoInteresesCorrientes = @SaldoActual / @TasaInteresCorriente / 100 / 30;

					-- Acumular el monto del débito de intereses corrientes en el saldo de intereses corrientes
					SET @SaldoInteresesCorrientes = @SaldoInteresesCorrientes + @MontoDebitoInteresesCorrientes;

					-- Actualizar el saldo de intereses corrientes en la base de datos
					UPDATE dbo.CuentaTarjetaMaestra
					SET SaldoInteresesCorrientes = @SaldoInteresesCorrientes
					WHERE CURRENT OF ctm_cursor;

					FETCH NEXT FROM ctm_cursor INTO @SaldoActual, @SaldoInteresesCorrientes
				END

				CLOSE ctm_cursor;
				DEALLOCATE ctm_cursor;


				--SI TCM tiene corte en @FechaItera
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