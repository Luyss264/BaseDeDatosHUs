# Base de Datos - Sistema Médico

Base de datos relacional para la gestión de citas y diagnósticos médicos. Incluye el diseño en MER y DER.

---

## Tablas

### MEDICOS
| Campo | Tipo |
|---|---|
| `id_medico` PK | Identificador único |
| `nombre_medico` | Nombre |
| `apellido_medico` | Apellido |
| `especialidad` | Especialidad médica |
| `email_medico` U | Correo electrónico |

### PACIENTES
| Campo | Tipo |
|---|---|
| `id_paciente` PK | Identificador único |
| `nombre_paciente` | Nombre |
| `apellido_paciente` | Apellido |
| `email_paciente` U | Correo electrónico |
| `documento` U | Documento de identidad |

### CITAS
| Campo | Tipo |
|---|---|
| `id_cita` PK | Identificador único |
| `id_paciente` FK | Referencia a PACIENTES |
| `id_medico` FK | Referencia a MEDICOS |
| `fecha` | Fecha de la cita |
| `lugar` | Lugar de la cita |

### DIAGNOSTICO
| Campo | Tipo |
|---|---|
| `id_diagnostico` PK | Identificador único |
| `id_cita` FK U | Referencia a CITAS |
| `descripcion` | Descripción del diagnóstico |

---

## Relaciones y Cardinalidades

| Relación | Cardinalidad | Descripción |
|---|---|---|
| PACIENTES → CITAS | 1 : M | Un paciente puede tener muchas citas |
| MEDICOS → CITAS | 1 : M | Un médico puede atender muchas citas |
| CITAS → DIAGNOSTICO | 1 : 1 | Cada cita genera un único diagnóstico |

> La relación 1:1 entre CITAS y DIAGNOSTICO se refuerza con el campo `id_cita` como FK UNIQUE en la tabla DIAGNOSTICO.

---

## Archivos

| Archivo | Descripción |
|---|---|
| `MER.jpg` | Modelo Entidad-Relación |
| `DER.jpg` | Diagrama Entidad-Relación físico |
