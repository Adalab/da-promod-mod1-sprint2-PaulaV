USE northwind;

/*Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, 
que tengan stock en el almacén, y al mismo tiempo que sus precios unitarios estén entre 50 y 100. 
Por último, ordena los resultados por código de proveedor de forma ascendente.*/

SELECT *
FROM products
WHERE supplier_id IN (1,3,7,8,9) AND units_in_stock > 0 AND unit_price BETWEEN 50 AND 100
ORDER BY supplier_id ASC;

/*Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, 
además que hayan vendido a clientes que tengan códigos que comiencen con las letras de la A hasta la G. 
Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año*/

SELECT e1.first_name, e1.last_name, e1.employee_id, o1.customer_id, o1.order_date
FROM employees AS e1
INNER JOIN orders AS o1 
ON e1.employee_id = o1.employee_id
WHERE e1.employee_id BETWEEN 3 AND 6 AND customer_id BETWEEN 'A' AND 'G' AND MONTH(order_date) = 12 AND DAY(order_date) BETWEEN 22 AND 31;

/*Calcula el precio de venta de cada pedido una vez aplicado el descuento.
Muestra el id del la orden, el id del producto, el nombre del producto, el precio unitario, la cantidad, el descuento y el precio de venta después de haber aplicado el descuento.*/

SELECT o1.order_id, p1.product_id, p1.product_name, p1.unit_price, od1.quantity, od1.discount, ROUND(SUM(od1.unit_price * od1.quantity * (1 - od1.discount)),2) AS Total
FROM order_details AS od1
INNER JOIN orders AS o1
ON od1.order_id = o1.order_id
INNER JOIN products AS p1
ON od1.product_id = p1.product_id
GROUP BY o1.order_id, p1.product_id;

/*Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.*/

SELECT product_name, unit_price
FROM products
WHERE unit_price > (
SELECT ROUND(AVG(unit_price), 2)
FROM products);

/*¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?*/

SELECT employees.employee_id, employees.first_name, employees.last_name, products.product_name, SUM(order_details.quantity) AS CantidadVendida
FROM employees
INNER JOIN orders 
ON employees.employee_id = orders.employee_id
INNER JOIN order_details
ON order_details.order_id = orders.order_id
INNER JOIN products
ON products.product_id = order_details.product_id
GROUP BY employee_id,product_name;

/*Basándonos en la query anterior, ¿qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery*/

SELECT first_name , last_name , COUNT(product_name) AS "producto_mas_vendido"
FROM (
	SELECT DISTINCT first_name, last_name, employees.employee_id, product_name
	FROM employees
	INNER JOIN orders
	ON employees.employee_id = orders.employee_id
	INNER JOIN order_details
	ON order_details.order_id = orders.order_id
	INNER JOIN products
	ON order_details.product_id = products.product_id) AS empleados_productos
    GROUP BY employee_id 
    ORDER BY producto_mas_vendido DESC
    LIMIT 1;

/*BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?*/
