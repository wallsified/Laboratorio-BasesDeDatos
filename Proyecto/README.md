# Sistema de Tickets de Soporte Técnico

## 1. Descripción del Problema y Requerimientos

La empresa Equilibra S.A de C.V ofrece sus servicios de consultoría química, manejo de desechos químicos y de verificaciones de cumplimiento de las N.O.M. Al tener aproximadamente 30 empleados, es una PYME, por lo que no cuenta con un departamento de TI propio. Esto lleva a que Equilibra S.A de C.V rente servicios de este tipo a terceros. En particular, renta un servicio de tickets de Soporte Técnico para el mantenimiento y/o reparación del equipo de cómputo de la empresa.

La empresa Sudo Services es la empresa que provee servicios de TI a Equilibra S.A de C.V. Para cumplir con las necesidades de la empresa, el sistema de tickets cuenta con una base de datos que almacena información sobre:

- Equipos de cómputo de la empresa
- Usuarios que usan los equipos
- Áreas a las que pertenecen
- Tickets creados por los usuarios
- Técnicos encargados de resolver los tickets
- Categorías de los tickets

## 2. Modelo ER

![Modelo ER](modelo_er.png)

El modelo contiene 7 entidades principales con las siguientes relaciones:

- Area - Tecnico (1:N): Un área puede tener varios técnicos
- Area - UsuarioEmpleado (1:N): Un área puede tener varios usuarios
- UsuarioEmpleado - EquipoComputo (1:N): Un usuario puede tener varios equipos
- EquipoComputo - Ticket (1:N): Un equipo puede tener varios tickets
- Ticket - CategoriaTicket (N:1): Varios tickets pueden pertenecer a una categoría
- Ticket - Asignacion (1:1): Un ticket tiene una única asignación
- Ticket - Comentarios (1:N): Un ticket puede tener varios comentarios

## 3. Implementación del Modelo Relacional

Se eligió MySQL como SGBD por:

- Soporte robusto para transacciones ACID
- Capacidad de implementar triggers y procedimientos almacenados
- Amplio soporte para restricciones y llaves foráneas
- Facilidad de uso y administración
- Gratuito y de código abierto

La implementación incluye:

- Tablas normalizadas hasta 3FN
- Restricciones de integridad referencial
- Triggers para validaciones de negocio
- Índices para optimizar consultas frecuentes

## 4. Nivel de Normalización

La base de datos está normalizada hasta la Tercera Forma Normal (3FN):

1NF:

- Todos los atributos son atómicos
- No hay grupos repetitivos
- Cada tabla tiene una llave primaria

2NF:

- Cumple 1NF
- No hay dependencias parciales
- Todos los atributos dependen completamente de la llave primaria

3FN:

- Cumple 2NF
- No hay dependencias transitivas
- Los atributos no-llave dependen directamente de la llave primaria

## 5. Implementación de Restricciones

Restricciones implementadas:

Dominio:

- Niveles de técnico limitados a ('Junior', 'Medio', 'Senior')
- Estados de ticket limitados a ('Abierto', 'En Proceso', 'Cerrado')
- Prioridades limitadas a ('Baja', 'Media', 'Alta')
- Fechas de cierre posteriores a fechas de creación

Referenciales:

- ON DELETE RESTRICT para prevenir eliminación de registros relacionados
- ON UPDATE CASCADE para mantener consistencia
- UNIQUE para números de serie y nombres únicos
- NOT NULL en campos obligatorios

De Usuario:

- Trigger para validar que un ticket no pueda cerrarse sin asignación
- Trigger para validar que solo el técnico asignado pueda hacer comentarios
- Validaciones de fechas mediante CHECK constraints

## 6. Escenarios de Control de Acceso

1. Usuario Técnico:

- Solo puede ver tickets asignados
- Puede actualizar estado de tickets
- Puede agregar comentarios

2. Usuario Empleado:

- Solo puede ver sus propios tickets
- Puede crear nuevos tickets
- No puede modificar asignaciones

3. Usuario Administrador:

- Acceso completo a todas las tablas
- Puede asignar tickets
- Puede gestionar usuarios y técnicos

## 7. Procedimientos Almacenados y Triggers

1. create_new_order:

- Crea un nuevo ticket
- Valida existencia de equipo y usuario
- Asigna automáticamente al técnico disponible

2. update_order_status:

- Actualiza el estado de un ticket
- Valida que exista asignación
- Registra fecha de cierre si aplica

3. update_product_price:

- Actualiza información de equipo
- Valida que no tenga tickets abiertos
- Mantiene historial de cambios

## 8. Entregables del Proyecto

- [x] Reporte detallado que cubre todos los puntos anteriores
- [x] Script para crear la base de datos y registros de prueba
- [x] Diccionario de datos
