# Backie - Backend para Aprender Programación Funcional

Este proyecto es una API backend construida con Gleam 1.10.0, diseñada como un viaje de aprendizaje hacia la programación funcional. Sirve como ejemplo práctico para desarrolladores que están familiarizados con la teoría de la programación funcional pero no tienen experiencia práctica.

## Descripción del Proyecto

Esta es una API REST que implementa funcionalidad básica de gestión de usuarios utilizando principios de programación funcional en Gleam. El proyecto demuestra el uso práctico de:

- Funciones puras
- Estructuras de datos inmutables
- Pattern matching
- Tipos Result para manejo de errores
- Seguridad de tipos

## Stack Tecnológico

### Librerías Core

- `gleam_stdlib` (>= 0.44.0) - Librería estándar de Gleam
- `wisp` (>= 1.6.0) - Framework web para Gleam
- `gleam_http` (>= 4.0.0) - Tipos y utilidades HTTP
- `mist` (>= 4.0.7) - Implementación del servidor HTTP

### Base de Datos y Manejo de Datos

- `pog` (>= 3.2.0) - Cliente PostgreSQL para Gleam
- `gleam_json` (>= 2.3.0) - Codificación/decodificación JSON

### Autenticación y Seguridad

- `gwt` (>= 2.0.0) - Implementación de JWT (JSON Web Token)
- `antigone` (>= 1.1.0) - Operaciones criptográficas

### Librerías de Utilidad

- `envoy` (>= 1.0.2) - Gestión de variables de entorno
- `youid` (>= 1.4.0) - Generación de UUIDs
- `dot_env` (>= 1.2.0) - Carga de archivos .env
- `cors_builder` (>= 2.0.4) - Middleware CORS
- `birl` (>= 1.8.0) - Utilidades para manejo de fechas

## Rutas de la API

Endpoints implementados actualmente:

### Gestión de Usuarios

```
POST /user
Descripción: Registrar un nuevo usuario
Cuerpo: { "username": string, "email": string, "password": string }
```

### Búsqueda de Usuarios

```
POST /user/find/email
Descripción: Buscar usuario por email
Cuerpo: { "email": string }

POST /user/find/username
Descripción: Buscar usuario por nombre de usuario
Cuerpo: { "username": string }
```

### Verificación de Estado

```
GET /
Descripción: Verificación de estado de la API
Respuesta: { "status": "Ok", "message": "API Working" }
```

## Estado del Proyecto y TODOs

- [x] Registro básico de usuarios
- [x] Búsqueda de usuarios por email y username
- [ ] Implementación de middleware JWT
- [ ] Autenticación de usuarios
- [ ] Rutas protegidas
- [ ] Gestión de perfiles de usuario
- [ ] Funcionalidad de restablecimiento de contraseña

## Enfoque de Aprendizaje

Este proyecto enfatiza varios conceptos clave de programación funcional:

1. **Funciones Puras**: La mayoría de las operaciones están implementadas como funciones puras, asegurando un comportamiento predecible y facilitando las pruebas.

2. **Tipos Result**: En lugar de lanzar excepciones, usamos el tipo Result de Gleam para manejar errores de manera elegante.
   Ejemplo:

   ```gleam
   pub fn find_user_by_email(db, email) -> Result(User, String)
   ```

3. **Pattern Matching**: Extensivamente usado en el manejo de rutas y procesamiento de datos.
   Ejemplo en el router:

   ```gleam
   case path, req.method {
     [], Get -> handle_root()
     ["user"], Post -> handle_form_submission(req, db)
     ...
   }
   ```

4. **Seguridad de Tipos**: Aprovechando el sistema de tipos de Gleam para prevenir errores en tiempo de ejecución.

## Primeros Pasos

1. Instalar Gleam 1.10.0
2. Clonar este repositorio
3. Copiar `.env.example` a `.env` y configurar las variables de entorno
4. Ejecutar PostgreSQL (se proporciona archivo docker-compose)
5. Iniciar el servidor con `gleam run`

## Notas de Desarrollo

Este es un proyecto de aprendizaje que intencionalmente comienza simple, introduciendo gradualmente más conceptos de programación funcional a medida que crece. La implementación actual se centra en operaciones CRUD básicas y manejo adecuado de errores, con características de autenticación y autorización planificadas para futuras actualizaciones.
