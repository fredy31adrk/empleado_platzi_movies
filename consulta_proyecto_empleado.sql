WITH ventas_empleado AS(
	SELECT date_trunc('month',b.fecha_pago)::date AS fecha_pago, 
	a.tienda_id,
	concat_ws(' ',a.nombre,a.apellido) AS nombre_empleado,
	SUM(b.cantidad) AS ventas_totales
	FROM empleados a LEFT join pagos b
	USING(empleado_id)--LEFT JOIN
	GROUP BY 1,2,3
	order by fecha_pago asc, ventas_totales desc
),
mejor_empleado AS(	
SELECT 
	a.fecha_pago,
	a.nombre_empleado,
	d.ciudad,
	a.ventas_totales,
	ROW_NUMBER()OVER(PARTITION BY a.fecha_pago order by a.ventas_totales DESC) AS orden_ventas
FROM ventas_empleado a LEFT JOIN tiendas b
	USING (tienda_id)
	LEFT JOIN direcciones c ON
	b.direccion_id = c.direccion_id
	LEFT JOIN ciudades d ON
	c.ciudad_id = d.ciudad_id
WHERE fecha_pago is not null
)

SELECT * FROM mejor_empleado WHERE orden_ventas = 1