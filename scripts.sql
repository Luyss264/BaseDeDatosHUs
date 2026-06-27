-- CREANDO TABLAS

CREATE TABLE estudiantes (
    id_estudiante      SERIAL PRIMARY KEY,
    nombre_completo    VARCHAR(80)  NOT NULL,
    correo_electronico VARCHAR(80)  NOT NULL UNIQUE,
    genero             VARCHAR(20),
    identificacion     VARCHAR(20)  NOT NULL UNIQUE,
    carrera            VARCHAR(80)  NOT NULL,
    fecha_nacimiento   DATE         NOT NULL,
    fecha_ingreso      DATE         NOT NULL,
    CONSTRAINT chk_est_correo  CHECK (correo_electronico LIKE '%_@_%._%'),
    CONSTRAINT chk_est_genero  CHECK (genero IN ('Masculino','Femenino','Otro')),
    CONSTRAINT chk_est_fechas  CHECK (fecha_ingreso > fecha_nacimiento)
);

CREATE TABLE docentes (
    id_docente            SERIAL PRIMARY KEY,
    nombre_completo       VARCHAR(80)  NOT NULL,
    correo_institucional  VARCHAR(80)  NOT NULL UNIQUE,
    departamento_academico VARCHAR(80) NOT NULL,
    anios_experiencia     INTEGER      NOT NULL,
    CONSTRAINT chk_doc_correo      CHECK (correo_institucional LIKE '%_@_%._%'),
    CONSTRAINT chk_doc_experiencia CHECK (anios_experiencia >= 0)
);

CREATE TABLE cursos (
    id_curso   SERIAL PRIMARY KEY,
    nombre     VARCHAR(80) NOT NULL,
    codigo     VARCHAR(20) UNIQUE,
    creditos   INTEGER     NOT NULL,
    semestre   INTEGER     NOT NULL,
    id_docente INTEGER,
    CONSTRAINT fk_curso_docente FOREIGN KEY (id_docente)
        REFERENCES docentes(id_docente) ON DELETE SET NULL,
    CONSTRAINT chk_cur_creditos CHECK (creditos > 0),
    CONSTRAINT chk_cur_semestre CHECK (semestre BETWEEN 1 AND 10)
);

CREATE TABLE inscripciones (
    id_inscripcion     SERIAL PRIMARY KEY,
    id_estudiante      INTEGER NOT NULL,
    id_curso           INTEGER NOT NULL,
    fecha_inscripcion  DATE    DEFAULT CURRENT_DATE,
    calificacion_final DECIMAL(3,1) NOT NULL,
    CONSTRAINT fk_inscripcion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT fk_inscripcion_curso FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso) ON DELETE CASCADE,
    CONSTRAINT chk_ins_calificacion CHECK (calificacion_final BETWEEN 0.0 AND 5.0)
);

-- INSERTAR DATOS

-- 1. Insertar 3 Docentes (Uno con más de 5 años de experiencia, otros con menos)
INSERT INTO docentes (nombre_completo, correo_institucional, departamento_academico, anios_experiencia)
VALUES 
('Carlos Mendoza', 'carlos.mendoza@universidad.edu', 'Ingeniería de Sistemas', 8),
('Ana María Gómez', 'ana.gomez@universidad.edu', 'Matemáticas', 3),
('Roberto Silva', 'roberto.silva@universidad.edu', 'Ciencias Sociales', 6);

-- 2. Insertar 5 Estudiantes
INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso)
VALUES 
('Juan Pérez', 'juan.perez@correo.com', 'Masculino', '10203040', 'Ingeniería de Sistemas', '2002-05-15', '2021-02-01'),
('María Rodriguez', 'maria.rod@correo.com', 'Femenino', '50607080', 'Ingeniería de Sistemas', '2003-08-22', '2022-01-15'),
('Andrés Felipe Calixto', 'andres.calixto@correo.com', 'Masculino', '90102030', 'Administración', '2001-11-30', '2020-08-10'),
('Laura Sofía Restrepo', 'laura.restrepo@correo.com', 'Femenino', '40302010', 'Psicología', '2004-02-10', '2023-01-20'),
('Carlos Mario Marín', 'carlos.marin@correo.com', 'Masculino', '70809010', 'Ingeniería de Sistemas', '2002-12-05', '2021-08-15');

-- 3. Insertar 4 Cursos (Asociados a los docentes y distribuidos en diferentes semestres)
INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente)
VALUES 
('Bases de Datos I', 'INF-301', 4, 3, 1),  -- Dictado por Carlos Mendoza (id_docente: 1)
('Cálculo Integral', 'MAT-102', 4, 2, 2),  -- Dictado por Ana Gómez (id_docente: 2)
('Programación Orientada a Objetos', 'INF-202', 3, 2, 1), -- Dictado por Carlos Mendoza (id_docente: 1)
('Sociología General', 'SOC-101', 2, 1, 3); -- Dictado por Roberto Silva (id_docente: 3)

-- 4. Insertar 8 Inscripciones (Distribuidas para cumplir con los requerimientos de las tareas posteriores)
INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion_final)
VALUES 
(1, 1, '2026-02-01', 4.5), -- Juan en Bases de Datos
(1, 3, '2026-02-02', 3.8), -- Juan en Programación (Estudiante en más de un curso)
(2, 1, '2026-02-01', 4.8), -- María en Bases de Datos
(2, 2, '2026-02-03', 2.9), -- María en Cálculo
(3, 2, '2026-02-02', 4.0), -- Andrés en Cálculo
(3, 4, '2026-02-05', 4.2), -- Andrés en Sociología (Estudiante en más de un curso)
(4, 1, '2026-02-01', 3.5), -- Laura en Bases de Datos (Hace que el curso 1 tenga > 2 estudiantes)
(5, 3, '2026-02-04', 4.7); -- Carlos en Programación





--1. Listar todos los estudiantes con sus inscripciones y cursos (JOIN)
--   Esta consulta une las tres tablas para mostrar qué estudiante está inscrito en qué curso y qué nota lleva.
SELECT 
    e.nombre_completo AS estudiante,
    c.nombre AS curso,
    i.fecha_inscripcion,
    i.calificacion_final
FROM estudiantes e
INNER JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
INNER JOIN cursos c ON i.id_curso = c.id_curso;

--2. Listar cursos dictados por docentes con > 5 años de experiencia
--   Filtramos los cursos uniendo la tabla de docentes y aplicando la condición en el WHERE.

SELECT 
    c.codigo,
    c.nombre AS curso,
    d.nombre_completo AS docente,
    d.anios_experiencia
FROM cursos c
INNER JOIN docentes d ON c.id_docente = d.id_docente
WHERE d.anios_experiencia > 5;

--3. Obtener promedio de calificaciones por curso (GROUP BY + AVG)
--   Agrupamos por el nombre del curso y calculamos el promedio. Usamos ROUND para que quede a un solo decimal.
SELECT 
    c.nombre AS curso,
    ROUND(AVG(i.calificacion_final), 1) AS promedio_calificaciones
FROM cursos c
INNER JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre;

--4. Mostrar estudiantes inscritos en más de un curso (HAVING COUNT)
SELECT 
    e.id_estudiante,
    e.nombre_completo AS estudiante,
    COUNT(i.id_inscripcion) AS total_cursos_inscritos
FROM estudiantes e
INNER JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo
HAVING COUNT(i.id_inscripcion) > 1;

--5. ALTER TABLE: Agregar columna estado_academico a estudiantes
ALTER TABLE estudiantes 
ADD COLUMN estado_academico VARCHAR(20) DEFAULT 'Activo';

--6. Eliminar un docente y observar el efecto en cursos
-- Eliminamos al docente
DELETE FROM docentes WHERE id_docente = 3;

-- Comprobamos el efecto en la tabla cursos
SELECT id_curso, nombre, id_docente FROM cursos;

--7. Consultar cursos con más de 2 estudiantes inscritos
SELECT 
    c.codigo,
    c.nombre AS curso,
    COUNT(i.id_estudiante) AS total_estudiantes
FROM cursos c
INNER JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.codigo, c.nombre
HAVING COUNT(i.id_estudiante) > 2;



-- SUBCONSULTAS Y FUNCIONES

--1. Estudiantes cuya calificación promedio sea mayor al promedio general
SELECT 
    e.nombre_completo AS estudiante,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_estudiante
FROM estudiantes e
INNER JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo
HAVING AVG(i.calificacion_final) > (SELECT AVG(calificacion_final) FROM inscripciones);

--2. Carreras con estudiantes inscritos en cursos del semestre $\ge$ 2
SELECT DISTINCT e.carrera
FROM estudiantes e
WHERE EXISTS (
    SELECT 1 
    FROM inscripciones i
    INNER JOIN cursos c ON i.id_curso = c.id_curso
    WHERE i.id_estudiante = e.id_estudiante AND c.semestre >= 2
);

--3. Indicadores generales del sistema académico
SELECT 
    COUNT(id_estudiante) AS total_estudiantes_registrados,
    ROUND(SUM(calificacion_final), 1) AS suma_todas_las_notas,
    MAX(calificacion_final) AS nota_mas_alta,
    MIN(calificacion_final) AS nota_mas_baja,
    ROUND(AVG(calificacion_final), 2) AS promedio_general_sistema
FROM inscripciones;


--CREACION DE UNA VISTA

CREATE OR REPLACE VIEW vista_historial_academico AS
SELECT 
    e.nombre_completo AS estudiante,
    c.nombre AS curso,
    COALESCE(d.nombre_completo, 'Sin Docente Asignado') AS docente,
    c.semestre,
    i.calificacion_final
FROM inscripciones i
INNER JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
INNER JOIN cursos c ON i.id_curso = c.id_curso
LEFT JOIN docentes d ON c.id_docente = d.id_docente;

-- Prueba de la vista
SELECT * FROM vista_historial_academico;


--CONTROL DE ACCESO Y TRANSACCIONES

--1. Gestión de Permisos (DCL)
-- Crear el rol/usuario de ejemplo
CREATE ROLE revisor_academico WITH LOGIN PASSWORD 'Segura123';

-- Asignar permiso de solo lectura sobre la vista
GRANT SELECT ON vista_historial_academico TO revisor_academico;

-- Revocar explícitamente cualquier permiso de modificación en inscripciones
REVOKE INSERT, UPDATE, DELETE ON inscripciones FROM revisor_academico;


--2. Simulación de Transacción con SAVEPOINT (TCL)
-- 1. Iniciamos la transacción
BEGIN;

-- 2. Modificación válida: Juan Pérez mejora su nota en Bases de Datos (id_estudiante: 1, id_curso: 1)
UPDATE inscripciones 
SET calificacion_final = 4.8 
WHERE id_estudiante = 1 AND id_curso = 1;

-- 3. Creamos un punto de restauración antes de un proceso masivo o arriesgado
SAVEPOINT actualizacion_primer_bloque;

-- 4. Modificación errónea: Por error de digitación se le asigna 1.0 a María en su curso de Cálculo
UPDATE inscripciones 
SET calificacion_final = 1.0 
WHERE id_estudiante = 2 AND id_curso = 2;

-- Verificamos cómo se ve temporalmente el error en la transacción
SELECT * FROM inscripciones WHERE id_estudiante = 2;

-- 5. Detectamos el error y regresamos al Savepoint intacto
ROLLBACK TO SAVEPOINT actualizacion_primer_bloque;

-- Verificamos que la nota de María regresó a su valor original (2.9) y la de Juan sigue modificada (4.8)
SELECT * FROM inscripciones;

-- 6. Confirmamos y consolidamos definitivamente en la Base de Datos
COMMIT;

