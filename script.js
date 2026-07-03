// Seleccionar la base de datos
use('streamhub');

// Limpiar colecciones para evitar duplicados en pruebas
db.usuarios.drop();
db.contenido.drop();
db.valoraciones.drop();

// TASK 2: INSERCIÓN DE DATOS

//AQUI ESTA SUCEDIENDO UN CREATE, como la coleccion contenido y resto aun no existen, este las crea al referenciarlas como ruta
//e inserta en ellas

// Insertar peliculas y series
db.contenido.insertMany([
  {
    _id: ObjectId("65a1b2c3d4e5f6a7b8c90001"),
    titulo: "Poor Things",
    tipo: "pelicula",
    generos: ["Sci-Fi", "Romance", "Comedia"],
    duracion_min: 141,
    año: 2023,
    director: "Yorgos Lanthimos"
  },
  {
    _id: ObjectId("65a1b2c3d4e5f6a7b8c90002"),
    titulo: "Stranger Things",
    tipo: "serie",
    generos: ["Sci-Fi", "Drama", "Terror"],
    temporadas: 4,
    año: 2016,
    creador: "The Duffer Brothers"
  },
  {
    _id: ObjectId("65a1b2c3d4e5f6a7b8c90003"),
    titulo: "Interstellar",
    tipo: "pelicula",
    generos: ["Sci-Fi", "Aventura", "Drama"],
    duracion_min: 169,
    año: 2014,
    director: "Christopher Nolan"
  },
  {
    _id: ObjectId("65a1b2c3d4e5f6a7b8c90004"),
    titulo: "Parasite",
    tipo: "pelicula",
    generos: ["Thriller", "Drama", "Comedia"],
    duracion_min: 132,
    año: 2019,
    director: "Bong Joon Ho"
  },
  {
    _id: ObjectId("65a1b2c3d4e5f6a7b8c90005"),
    titulo: "Breaking Bad",
    tipo: "serie",
    generos: ["Crimen", "Drama", "Thriller"],
    temporadas: 5,
    año: 2008,
    creador: "Vince Gilligan"
  },
  {
    _id: ObjectId("65a1b2c3d4e5f6a7b8c90006"),
    titulo: "Inside Out",
    tipo: "pelicula",
    generos: ["Animacion", "Aventura", "Comedia"],
    duracion_min: 95,
    año: 2015,
    director: "Pete Docter"
  }
]);

// Insertar usuarios
db.usuarios.insertMany([
  {
    _id: ObjectId("65b2c3d4e5f6a7b8c9d00001"),
    nombre: "Jose Luis",
    email: "jose.luis@streamhub.com",
    fecha_registro: ISODate("2026-01-15T10:00:00Z"),
    historial: [
      ObjectId("65a1b2c3d4e5f6a7b8c90001"), 
      ObjectId("65a1b2c3d4e5f6a7b8c90003"), 
      ObjectId("65a1b2c3d4e5f6a7b8c90005")
    ]
  },
  {
    _id: ObjectId("65b2c3d4e5f6a7b8c9d00002"),
    nombre: "Maria Peralta",
    email: "maria.p@mail.com",
    fecha_registro: ISODate("2026-03-20T14:30:00Z"),
    historial: [
      ObjectId("65a1b2c3d4e5f6a7b8c90002"), 
      ObjectId("65a1b2c3d4e5f6a7b8c90006")
    ]
  },
  {
    _id: ObjectId("65b2c3d4e5f6a7b8c9d00003"),
    nombre: "Carlos Mendoza",
    email: "carlos.m@streamhub.com",
    fecha_registro: ISODate("2026-05-02T18:22:00Z"),
    historial: [
      ObjectId("65a1b2c3d4e5f6a7b8c90001"),
      ObjectId("65a1b2c3d4e5f6a7b8c90002"),
      ObjectId("65a1b2c3d4e5f6a7b8c90003"),
      ObjectId("65a1b2c3d4e5f6a7b8c90004"),
      ObjectId("65a1b2c3d4e5f6a7b8c90006")
    ]
  }
]);

// Insertar una valoracion individual
db.valoraciones.insertOne({
  usuario_id: ObjectId("65b2c3d4e5f6a7b8c9d00001"),
  contenido_id: ObjectId("65a1b2c3d4e5f6a7b8c90001"),
  calificacion: 5,
  comentario: "Brillante y visualmente espectacular. Una actuacion increible.",
  fecha: ISODate("2026-02-01T20:00:00Z")
});

// Insertar multiples valoraciones
db.valoraciones.insertMany([
  {
    usuario_id: ObjectId("65b2c3d4e5f6a7b8c9d00003"),
    contenido_id: ObjectId("65a1b2c3d4e5f6a7b8c90001"),
    calificacion: 4,
    comentario: "Muy extravagante y divertida, propuesta muy original.",
    fecha: ISODate("2026-05-10T11:15:00Z")
  },
  {
    usuario_id: ObjectId("65b2c3d4e5f6a7b8c9d00002"),
    contenido_id: ObjectId("65a1b2c3d4e5f6a7b8c90002"),
    calificacion: 5,
    comentario: "La atmosfera ochentera es increible.",
    fecha: ISODate("2026-04-01T22:40:00Z")
  },
  {
    usuario_id: ObjectId("65b2c3d4e5f6a7b8c9d00003"),
    contenido_id: ObjectId("65a1b2c3d4e5f6a7b8c90006"),
    calificacion: 2,
    comentario: "No me logro enganchar tanto como la primera parte.",
    fecha: ISODate("2026-05-20T09:30:00Z")
  }
]);

// TASK 3: CONSULTAS CON OPERADORES

// Peliculas con duracion mayor a 120 minutos
db.contenido.find({ tipo: { $eq: "pelicula" }, duracion_min: { $gt: 120 } });

// Contenido indexado en los generos Sci-Fi o Terror
db.contenido.find({ generos: { $in: ["Sci-Fi", "Terror"] } });

// Valoraciones con calificacion menor a 4 estrellas
db.valoraciones.find({ calificacion: { $lt: 4 } });

// Contenido lanzado entre los años 2000 y 2015
db.contenido.find({ $and: [ { año: { $gt: 2000 } }, { año: { $lt: 2015 } } ] });

// Usuarios con correo de streamhub o registrados despues de abril de 2026
db.usuarios.find({
  $or: [
    { email: { $regex: "@streamhub\\.com$", $options: "i" } },
    { fecha_registro: { $gt: ISODate("2026-04-01T00:00:00Z") } }
  ]
});

// TASK 4: ACTUALIZACIONES Y ELIMINACIONES

// Actualizar el correo de un usuario por su ID
db.usuarios.updateOne(
  { _id: ObjectId("65b2c3d4e5f6a7b8c9d00002") },
  { $set: { email: "maria.peralta.nuevo@mail.com" } }
);

// Agregar propiedad a peliculas con duracion menor a 100 minutos
db.contenido.updateMany(
  { tipo: "pelicula", duracion_min: { $lt: 100 } },
  { $set: { apto_para_todo_publico: true } }
);

// Eliminar una valoracion especifica
db.valoraciones.deleteOne({
  usuario_id: ObjectId("65b2c3d4e5f6a7b8c9d00003"),
  contenido_id: ObjectId("65a1b2c3d4e5f6a7b8c90006")
});

// Eliminar contenidos lanzados antes de 1990
db.contenido.deleteMany({ año: { $lt: 1990 } });

// TASK 5: ÍNDICES

// Crear indice unico por titulo
db.contenido.createIndex({ titulo: 1 }, { unique: true });

// Crear indice multillave para el arreglo de generos
db.contenido.createIndex({ generos: 1 });

// Mostrar los indices creados en la coleccion
db.contenido.getIndexes();

// AGREGACIONES

// Pipeline 1: Calcular duracion promedio y cantidad de peliculas por genero
db.contenido.aggregate([
  { $match: { tipo: "pelicula" } },
  { $unwind: "$generos" },
  { 
    $group: {
      _id: "$generos",
      total_titulos: { $sum: 1 },
      duracion_promedio: { $avg: "$duracion_min" }
    } 
  },
  { $sort: { total_titulos: -1 } },
  {
    $project: {
      _id: 0,
      genero: "$_id",
      cantidadPeliculas: "$total_titulos",
      minutosPromedio: { $round: ["$duracion_promedio", 1] }
    }
  }
]);

// Pipeline 2: Obtener usuarios con mas de 2 contenidos vistos
db.usuarios.aggregate([
  { $unwind: "$historial" },
  {
    $group: {
      _id: "$nombre",
      total_visto: { $sum: 1 }
    }
  },
  { $match: { total_visto: { $gt: 2 } } },
  { $sort: { total_visto: -1 } },
  {
    $project: {
      _id: 0,
      nombreUsuario: "$_id",
      totalContenidosVistos: "$total_visto",
      nivelFidelidad: { $literal: "Premium Fan" }
    }
  }
]);