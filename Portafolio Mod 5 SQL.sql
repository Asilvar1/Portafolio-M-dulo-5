BEGIN;


CREATE TABLE IF NOT EXISTS public.clientes
(
    id_cliente serial NOT NULL,
    nombre character varying(100) COLLATE pg_catalog."default" NOT NULL,
    apellidos character varying(100) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) NOT NULL,
    CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente)
);

CREATE TABLE IF NOT EXISTS public.productos
(
    id_producto serial NOT NULL,
    "descripción" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "sub_descripción" character varying(100) NOT NULL,
    valor money NOT NULL,
    stock numeric(100) NOT NULL,
    CONSTRAINT productos_pkey PRIMARY KEY (id_producto)
);

CREATE TABLE IF NOT EXISTS public.ventas
(
    id_venta serial NOT NULL,
    id_cliente serial NOT NULL,
    id_producto serial NOT NULL,
    fecha date NOT NULL,
    cantidad_prod integer NOT NULL,
    valor_prod integer NOT NULL,
    PRIMARY KEY (id_venta)
);

ALTER TABLE IF EXISTS public.ventas
    ADD CONSTRAINT fk_cliente FOREIGN KEY (id_cliente)
    REFERENCES public.clientes (id_cliente) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.ventas
    ADD CONSTRAINT fk_producto FOREIGN KEY (id_producto)
    REFERENCES public.productos (id_producto) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

/* Insertamos 5 datos para cada tabla */ 

insert into clientes (id_cliente, nombre, apellidos, email)values 
(1, 'Juan Carlos', 'Sanford', 'jcsanford@gmail.com'),
(2, 'Cecilia','Powell', 'jcsanford@gmail.com'),
(3, 'Esteban','Houston', 'jcsanford@gmail.com'),
(4, 'María','Hood', 'jcsanford@gmail.com'),
(5, 'Marcos','Coleman', 'jcsanford@gmail.com');
select * from clientes

insert into productos (id_producto, descripción, sub_descripción, valor, stock)values 
(1, 'Analisis ROI', '6 sesiones', 300.000, 2),
(2, 'Atracción de Talento', 'Base de datos TENS', 150.000, 4),
(3, 'Evaluación Psicolaboral', '1 Informe', 30.000, 12),
(4, 'Atracción de Talento', 'Base de datos Call Center', 150.000, 2),
(5, 'Atracción de Talento', 'Base de datos Profesores', 150.000, 6);
select * from productos

insert into ventas (id_venta, id_cliente, id_producto, fecha, cantidad_prod, valor_prod)values 
(1, 1, 5, '2022-04-22', 2, 240),
(2, 2, 4, '2022-04-22', 1, 120),
(3, 3, 3, '2022-04-22', 10, 24),
(4, 4, 2, '2022-04-22', 2, 120),
(5, 5, 1, '2022-04-22', 1, 120);
select * from ventas

/* 1) Actualizamos el precio de todos los productos, -20% por concepto de oferta de verano */ 

update productos set valor = (valor * 0.8)
select * from productos

/* 2) Listamos todos los productos con stock crítico ( menor o igual a 5 unidades) */ 

select * from productos where stock <= 5

/* 3) Simulamos la compra de al menos 3 productos, calculamos el sub total, agregmaos el iva y mostrar el total de la compra */ 

-- Tuve que primero agregar las columnas de valor total y valor total más iva con sus respectivos calculos.
ALTER TABLE ventas ADD Valor_total int;
update ventas set valor_total = (cantidad_prod * valor_prod)
select valor_total from ventas
ALTER TABLE ventas ADD Valor_total_mas_iva int;
update ventas set valor_total_mas_iva = (cantidad_prod * valor_prod * 1.19)
-- Dado que fueron agregadas, cualquiera de las 3 funcionaría para lograr el objetivo del ejercicio 3
select * from ventas
select (cantidad_prod * valor_prod) as "Sub_total" from ventas;
select ((cantidad_prod * valor_prod)*1.19)  as "Sub_Total + iva" from ventas;

/* 4) Mostramos el total de ventas del mes de diciembre del 2022 */ 

select valor_total_mas_iva from ventas
where fecha between '2022/12/01' and '2022/12/30';
-- No hay ventas en diciembre del 2022

/* 5) Listar el comportamiento de compra del usuario que más compras realizó durante el 2022  */ 

-- Selecciono la fecha que solicitan, utilizo un estilo de inner join para obtener la mayor cantidad de datos que pudiesen ser importantes de este cliente y ordeno por quien consumió más 

select nombre, apellidos, email, fecha, cantidad_prod, valor_prod, valor_total_mas_iva from ventas, clientes where ventas.id_cliente = clientes.id_cliente and fecha between '2022/01/01' and '2022/12/31' order by valor_total_mas_iva DESC;



