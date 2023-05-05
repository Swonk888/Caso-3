
WITH CTE_contracts AS (
    SELECT *
    FROM dbo.contrato
    WHERE contrato_id < 12
), CTE_movements AS (
    SELECT *
    FROM dbo.desecho_movimientos
    WHERE reci_desecho_cantidad > 0
        AND posttime BETWEEN '2022-01-01' AND '2022-12-31'
), CTE_producers AS (
    SELECT *
    FROM dbo.productores_residuos
    WHERE balance < 0
)
SELECT 
    CTE_contracts.descripcion, 
    dbo.proceso.proceso_id, 
    dbo.proceso.clasificacion, 
    CTE_movements.posttime, 
    CTE_movements.responsible_name, 
    CTE_movements.reci_desecho_cantidad, 
    dbo.ubicaciones.descripcion AS Expr1, 
    dbo.paises.nombre, 
    CTE_producers.nombre AS Expr2, 
    CTE_producers.porcentaje_carbon, 
    CTE_producers.balance,
    COUNT(*) AS total,
    SUM(CTE_movements.reci_desecho_cantidad) AS total_desechos,
    MIN(CTE_movements.posttime) AS fecha_minima,
    MAX(CTE_movements.posttime) AS fecha_maxima
FROM CTE_contracts 
	INNER JOIN dbo.proceso 
		ON CTE_contracts.contrato_id = dbo.proceso.contrato_id 
	INNER JOIN CTE_movements 
		ON dbo.proceso.proceso_id = CTE_movements.proceso_id 
	INNER JOIN dbo.ubicaciones 
		ON CTE_contracts.ubicacion_id = dbo.ubicaciones.ubicacion_id 
		AND CTE_movements.ubicacion_id = dbo.ubicaciones.ubicacion_id 
	INNER JOIN dbo.paises 
		ON dbo.ubicaciones.pais_id = dbo.paises.pais_id 
	INNER JOIN CTE_producers 
		ON CTE_movements.productor_id = CTE_producers.productor_id 
		AND dbo.ubicaciones.ubicacion_id = CTE_producers.ubicaicon_id
GROUP BY 
    CTE_contracts.descripcion, 
    dbo.proceso.proceso_id, 
    dbo.proceso.clasificacion, 
    CTE_movements.posttime, 
    CTE_movements.responsible_name, 
    CTE_movements.reci_desecho_cantidad, 
    dbo.ubicaciones.descripcion, 
    dbo.paises.nombre, 
    CTE_producers.nombre, 
    CTE_producers.porcentaje_carbon, 
    CTE_producers.balance
HAVING COUNT(*) > 1
ORDER BY 
    CTE_contracts.descripcion,
    CTE_movements.posttime DESC
FOR JSON AUTO;

