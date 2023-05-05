

SELECT 
	dbo.contrato.descripcion, 
	dbo.proceso.proceso_id, 
	dbo.proceso.clasificacion, 
	dbo.desecho_movimientos.posttime, 
	dbo.desecho_movimientos.responsible_name, 
	dbo.desecho_movimientos.reci_desecho_cantidad, 
	dbo.ubicaciones.descripcion AS Expr1, 
	dbo.paises.nombre, 
	dbo.productores_residuos.nombre AS Expr2, 
	dbo.productores_residuos.porcentaje_carbon, 
	dbo.productores_residuos.balance,
	COUNT(*) AS total,
	SUM(dbo.desecho_movimientos.reci_desecho_cantidad) AS total_desechos,
	MIN(dbo.desecho_movimientos.posttime) AS fecha_minima,
	MAX(dbo.desecho_movimientos.posttime) AS fecha_maxima
FROM dbo.contrato 
	INNER JOIN dbo.proceso 
		ON dbo.contrato.contrato_id = dbo.proceso.contrato_id 
	INNER JOIN dbo.desecho_movimientos 
		ON dbo.proceso.proceso_id = dbo.desecho_movimientos.proceso_id 
	INNER JOIN dbo.ubicaciones 
		ON dbo.contrato.ubicacion_id = dbo.ubicaciones.ubicacion_id 
		AND dbo.desecho_movimientos.ubicacion_id = dbo.ubicaciones.ubicacion_id 
	INNER JOIN dbo.paises 
		ON dbo.ubicaciones.pais_id = dbo.paises.pais_id 
	INNER JOIN dbo.productores_residuos 
		ON dbo.desecho_movimientos.productor_id = dbo.productores_residuos.productor_id 
		AND dbo.ubicaciones.ubicacion_id = dbo.productores_residuos.ubicaicon_id
WHERE dbo.contrato.contrato_id < 12
	AND dbo.desecho_movimientos.reci_desecho_cantidad > 0
	AND dbo.desecho_movimientos.posttime BETWEEN '2022-01-01' AND '2022-12-31'
	AND dbo.productores_residuos.balance < 0
GROUP BY 
	dbo.contrato.descripcion, 
	dbo.proceso.proceso_id, 
	dbo.proceso.clasificacion, 
	dbo.desecho_movimientos.posttime, 
	dbo.desecho_movimientos.responsible_name, 
	dbo.desecho_movimientos.reci_desecho_cantidad, 
	dbo.ubicaciones.descripcion, 
	dbo.paises.nombre, 
	dbo.productores_residuos.nombre, 
	dbo.productores_residuos.porcentaje_carbon, 
	dbo.productores_residuos.balance
HAVING COUNT(*) > 1
ORDER BY 
	dbo.contrato.descripcion, 
	dbo.desecho_movimientos.posttime DESC
FOR JSON AUTO;


CREATE NONCLUSTERED INDEX idx_posttime ON dbo.desecho_movimientos (posttime);
CREATE NONCLUSTERED INDEX idx_ubicacion_id ON dbo.contrato (ubicacion_id);

SELECT 
	dbo.contrato.descripcion, 
	dbo.proceso.proceso_id, 
	dbo.proceso.clasificacion, 
	dbo.desecho_movimientos.posttime, 
	dbo.desecho_movimientos.responsible_name, 
	dbo.desecho_movimientos.reci_desecho_cantidad, 
	dbo.ubicaciones.descripcion AS Expr1, 
	dbo.paises.nombre, 
	dbo.productores_residuos.nombre AS Expr2, 
	dbo.productores_residuos.porcentaje_carbon, 
	dbo.productores_residuos.balance,
	COUNT(*) AS total,
	SUM(dbo.desecho_movimientos.reci_desecho_cantidad) AS total_desechos,
	MIN(dbo.desecho_movimientos.posttime) AS fecha_minima,
	MAX(dbo.desecho_movimientos.posttime) AS fecha_maxima
FROM dbo.contrato 
	INNER JOIN dbo.proceso 
		ON dbo.contrato.contrato_id = dbo.proceso.contrato_id 
	INNER JOIN dbo.desecho_movimientos 
		ON dbo.proceso.proceso_id = dbo.desecho_movimientos.proceso_id 
	INNER JOIN dbo.ubicaciones 
		ON dbo.contrato.ubicacion_id = dbo.ubicaciones.ubicacion_id 
		AND dbo.desecho_movimientos.ubicacion_id = dbo.ubicaciones.ubicacion_id 
	INNER JOIN dbo.paises 
		ON dbo.ubicaciones.pais_id = dbo.paises.pais_id 
	INNER JOIN dbo.productores_residuos 
		ON dbo.desecho_movimientos.productor_id = dbo.productores_residuos.productor_id 
		AND dbo.ubicaciones.ubicacion_id = dbo.productores_residuos.ubicaicon_id
WHERE dbo.contrato.contrato_id < 12
	AND dbo.desecho_movimientos.reci_desecho_cantidad > 0
	AND dbo.desecho_movimientos.posttime BETWEEN '2022-01-01' AND '2022-12-31'
	AND dbo.productores_residuos.balance < 0
GROUP BY 
	dbo.contrato.descripcion, 
	dbo.proceso.proceso_id, 
	dbo.proceso.clasificacion, 
	dbo.desecho_movimientos.posttime, 
	dbo.desecho_movimientos.responsible_name, 
	dbo.desecho_movimientos.reci_desecho_cantidad, 
	dbo.ubicaciones.descripcion, 
	dbo.paises.nombre, 
	dbo.productores_residuos.nombre, 
	dbo.productores_residuos.porcentaje_carbon, 
	dbo.productores_residuos.balance
HAVING COUNT(*) > 1
ORDER BY 
	dbo.contrato.descripcion,
	dbo.desecho_movimientos.posttime DESC
FOR JSON AUTO;
