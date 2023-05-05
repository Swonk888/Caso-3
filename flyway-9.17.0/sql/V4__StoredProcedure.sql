IF OBJECT_ID('dbo.InsertarMov', 'P') IS NOT NULL
DROP PROCEDURE dbo.InsertarMov;

DECLARE @datos INT;
GO
CREATE PROCEDURE [dbo].[InsertarMov]
	@datos INT,
	@responsible_name1 Varchar(20)

AS
BEGIN
	SET NOCOUNT ON;
	WHILE @datos > 0 
		BEGIN
			DECLARE @posttime datetime, @ubicacion_id smallint, @recolector_id smallint, @productor_id smallint, @responsible_name Varchar(20) ;
			DECLARE @ev_id int, @tipomov_id smallint, @tiporec_id smallint, @reci_desecho_cantidad decimal(10,2), @user_id smallint, @computer varchar(20);
			DECLARE @user varchar(20), @proceso_id smallint, @contrato smallint;

			SET @posttime = DATEADD(day, ABS(CHECKSUM(NEWID())) % 244, '2023-05-01');
			
			DECLARE @firstName VARCHAR(20), @lastName VARCHAR(20)
			SET @responsible_name =  @responsible_name1 + CAST(@datos AS VARCHAR(5));

			SELECT TOP 1 @ubicacion_id = ubicacion_id FROM ubicaciones ORDER BY NEWID();
			SELECT TOP 1 @recolector_id = recolector_id FROM recolectores where recolectores.ubicacion_id = @ubicacion_id ORDER BY NEWID();
			SELECT TOP 1 @productor_id = productor_id FROM productores_residuos where productores_residuos.ubicaicon_id = @ubicacion_id ORDER BY NEWID();
			SELECT TOP 1 @ev_id = ev_id FROM local_ev where local_ev.ubicacion_id = @ubicacion_id ORDER BY NEWID();
			SELECT TOP 1 @tipomov_id =  tipomov_id FROM tipo_movimiento ORDER BY NEWID();
			SELECT TOP 1 @tiporec_id =  tiporec_id FROM tipo_recipientes ORDER BY NEWID();
			SET @reci_desecho_cantidad = RAND()*100;
			SELECT TOP 1 @user_id = user_id FROM usuarios ORDER BY NEWID();
			SET @computer = 'localhost';
			SET @user = 'root';
			SELECT TOP 1 @contrato = contrato_id FROM contrato where contrato.ubicacion_id = @ubicacion_id ORDER BY NEWID();
			SELECT TOP 1 @proceso_id = proceso_id FROM proceso where proceso.contrato_id = @contrato ORDER BY NEWID();
			

			INSERT INTO desecho_movimientos (posttime, responsible_name, ubicacion_id, recolector_id, productor_id, ev_id, tipomov_id, tiporec_id, reci_desecho_cantidad, user_id, computer, [user], proceso_id)
			VALUES (@posttime, @responsible_name, @ubicacion_id, @recolector_id, @productor_id, @ev_id, @tipomov_id, @tiporec_id, @reci_desecho_cantidad, @user_id, @computer, @user, @proceso_id);
			SET @datos =  @datos - 1;;
		END
		
END
GO

EXEC [dbo].[InsertarMov] 5, 'Kevin Vega';

