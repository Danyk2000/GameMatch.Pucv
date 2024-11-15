/* Creacion de tablas 
	(sin llave fóranea) 
*/

--creacion de tabla genero (hombre/mujer)--
create table genero(
	id_genero serial PRIMARY KEY,
	nombre_genero char(10) not null
	check (id_genero >= 1 and id_genero <=2)
);

insert into genero(nombre_genero) values ('Masculino');
insert into genero(nombre_genero) values ('Femenino');

--creacion de tabla nacionalidades--
create table nacionalidad(
	id_nacionalidad serial PRIMARY KEY,
	nacionalidad char(50) not null,
	bandera varchar(250) not null
);


CREATE OR REPLACE FUNCTION bandera_nacionalidad_directorio()
RETURNS TRIGGER AS $$
BEGIN
	NEW.bandera := 'imagenes/Bandera_' || NEW.nacionalidad;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_banderas
BEFORE INSERT OR UPDATE ON nacionalidad
FOR EACH ROW
EXECUTE FUNCTION bandera_nacionalidad_directorio();


insert into nacionalidad(nacionalidad) VALUES ('Chile');
insert into nacionalidad(nacionalidad) VALUES ('Argentina');
insert into nacionalidad(nacionalidad) VALUES ('Colombia');
insert into nacionalidad(nacionalidad) VALUES ('Perú');
insert into nacionalidad(nacionalidad) VALUES ('Paraguay');
insert into nacionalidad(nacionalidad) VALUES ('Venezuela');
insert into nacionalidad(nacionalidad) VALUES ('Ecuador');
insert into nacionalidad(nacionalidad) VALUES ('Uruguay');
insert into nacionalidad(nacionalidad) VALUES ('Brasil');
insert into nacionalidad(nacionalidad) VALUES ('Bolivia');
insert into nacionalidad(nacionalidad) VALUES ('México');
insert into nacionalidad(nacionalidad) VALUES ('España');

UPDATE nacionalidad SET bandera = 'imagenes/Bandera_' || nacionalidad;


--creación de tablas de plataformas(consola, pc u otros dispositivos)--
create table plataforma(
	id_plataforma SERIAL primary key not null,
	consola varchar(250) not null
);
	
--creación de tabla escala de calificación para las preguntas (escala likert)--

create table escala_pregunta(
	id_escala SERIAL PRIMARY KEY,
	escala char(50) not null,
	CHECK (id_escala >= 1 and id_escala <= 5)
	--Totalmente en desacuerdo, en desacuerdo, neutral, de acuerdo, totalmente de acuerdo--
);

insert into escala_pregunta(escala) VALUES ('Totalmente en desacuerdo');
insert into escala_pregunta(escala) VALUES ('En desacuerdo');
insert into escala_pregunta(escala) VALUES ('Neutral');
insert into escala_pregunta(escala) VALUES ('De acuerdo');
insert into escala_pregunta(escala) VALUES ('Totalmente de acuerdo');

--creación de tabla de categorías que agrupan a especialidades--

create table categoria(
	id_categoria SERIAL PRIMARY KEY,
	categoria varchar(20) not null,
	CHECK (id_categoria >= 1 and id_categoria <= 8)
);

insert into categoria(categoria) values ('Acción');
insert into categoria(categoria) values ('Socialización');
insert into categoria(categoria) values ('Maestría');
insert into categoria(categoria) values ('Logro');
insert into categoria(categoria) values ('Inmersión');
insert into categoria(categoria) values ('Creatividad');
insert into categoria(categoria) values ('Estética');
insert into categoria(categoria) values ('Descubrimiento');


--creacion de tabla decisiones de recomendaciones(Aceptar-True,Rechazar-False)--
create table decision_recomendacion(
	id_opcion serial PRIMARY KEY,
	recomendacion_aceptada boolean not null default false,
	check(id_opcion >= 1 and id_opcion <=2)    
);

INSERT INTO decision_recomendacion (recomendacion_aceptada, id_opcion)VALUES (true, 1);
INSERT INTO decision_recomendacion (recomendacion_aceptada, id_opcion) VALUES (false, 2);


/*
	Creaciones de tablas 
	(con solo 1 llave foránea)

*/

--creacion de tabla usuarios--
create table usuario(
	id_usuario serial PRIMARY KEY,
	nombre_usuario varchar(20) UNIQUE not null,
	genero integer not null,
	correo_electronico varchar(250) not null,
	fecha_nacimiento date not null,
	nacionalidad integer not null,
	CONSTRAINT fk_usuario_genero FOREIGN KEY (genero) REFERENCES genero(id_genero),
	CONSTRAINT fk_usuario_nacionalidad FOREIGN KEY (nacionalidad) REFERENCES nacionalidad(id_nacionalidad)
);

ALTER TABLE usuario RENAME COLUMN nacionalidad TO nacionalidad_id;	
ALTER TABLE usuario RENAME COLUMN genero TO genero_id;	

ALTER TABLE usuario ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE usuario ADD COLUMN is_staff BOOLEAN DEFAULT FALSE;
ALTER TABLE usuario ADD COLUMN is_superuser BOOLEAN DEFAULT FALSE;
ALTER TABLE usuario ADD COLUMN last_login TIMESTAMP NULL;
ALTER TABLE usuario ADD COLUMN "password" VARCHAR(250) not null;


--creación de tabla de videojuegos--
create table videojuego(
	id_videojuego SERIAL PRIMARY KEY not null,
	nombre varchar(500) UNIQUE not null,
	portada varchar(250) not null,
	genero char(100) not null, 
	fecha_lanzamiento date not null,
	empresa_desarrollo varchar(500) not null,
	distribuidor varchar(500) not null
);

UPDATE videojuego
SET genero = CASE 
             		WHEN genero = 'Sports' THEN 'Deportes'
                	WHEN genero = 'MMO' THEN 'MMO (Multijugador Masivo en Línea)'
					WHEN genero = 'Party' THEN 'Fiesta'
                	WHEN genero = 'Music' THEN 'Música'
					WHEN genero = 'Role-Playing' THEN 'Rol'
                	WHEN genero = 'Board Game' THEN 'Juego de Mesa'
					WHEN genero = 'Misc' THEN 'Varios/Mixto'
                	WHEN genero = 'Sandbox' THEN 'Mundo Abierto'
					WHEN genero = 'Racing' THEN 'Carreras'
                	WHEN genero = 'Fighting' THEN 'Peleas'
					WHEN genero = 'Action' THEN 'Acción'
                	WHEN genero = 'Shooter' THEN 'Disparos'
					WHEN genero = 'Visual Novel' THEN 'Novela Visual'
                	WHEN genero = 'Platform' THEN 'Plataformas'
					WHEN genero = 'Adventure' THEN 'Aventura'
                	WHEN genero = 'Puzzle' THEN 'Rompecabezas'
					WHEN genero = 'Strategy' THEN 'Estrategia'
                	WHEN genero = 'Action-Adventure' THEN 'Acción-Aventura'
					WHEN genero = 'Simulation' THEN 'Simulación'
                	WHEN genero = 'Education' THEN 'Educación'
             END
WHERE genero IN ('Sports', 
				'MMO',
				'Party',
				'Music',
				'Role-Playing',
				'Board Game',
				'Misc',
				'Sandbox',
				'Racing',
				'Fighting',
				'Action',
				'Shooter',
				'Visual Novel',
				'Platform',
				'Adventure',
				'Puzzle',
				'Strategy',
				'Action-Adventure',
				'Simulation',
				'Education');  

--creación de tabla especialidades (2 subcategorías derivadas de 1 categoría)--
create table especialidad(
	id_especialidad SERIAL PRIMARY KEY,
	especialidad varchar(25) not null,
	categoria int not null,
    CHECK(id_especialidad >= 1 and id_especialidad <= 16),
	CONSTRAINT FK_especi_categ FOREIGN KEY (categoria) REFERENCES categoria(id_categoria)
);


insert into especialidad(especialidad,categoria) VALUES ('Destrucción',1);
insert into especialidad(especialidad,categoria) VALUES ('Intensidad',1);
insert into especialidad(especialidad,categoria) VALUES ('Competencia',2);
insert into especialidad(especialidad,categoria) VALUES ('Colaboración',2);
insert into especialidad(especialidad,categoria) VALUES ('Dificultad',3);
insert into especialidad(especialidad,categoria) VALUES ('Estrategia',3);
insert into especialidad(especialidad,categoria) VALUES ('Avance',4);
insert into especialidad(especialidad,categoria) VALUES ('Fortaleza',4);
insert into especialidad(especialidad,categoria) VALUES ('Fantasía',5);
insert into especialidad(especialidad,categoria) VALUES ('Narrativa',5);
insert into especialidad(especialidad,categoria) VALUES ('Individualización',6);
insert into especialidad(especialidad,categoria) VALUES ('Creación',6);
insert into especialidad(especialidad,categoria) VALUES ('Apreciación Visual',7);
insert into especialidad(especialidad,categoria) VALUES ('Estilo Artístico',7);
insert into especialidad(especialidad,categoria) VALUES ('Aventura',8);
insert into especialidad(especialidad,categoria) VALUES ('Curiosidad',8);

ALTER TABLE especialidad RENAME COLUMN categoria TO categoria_id;	


--creación de tabla preguntas de factores motivacionales (2 provienen de 1 especialidad)--
create table preguntas_motivacion(
	id_pregunta SERIAL PRIMARY KEY,
	pregunta varchar(250) not null,
	especialidad int not null,
	CHECK (id_pregunta >= 1 and id_pregunta <= 32),
	CONSTRAINT FK_preg_especi FOREIGN KEY (especialidad) REFERENCES especialidad(id_especialidad)
);


insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta destruir objetos, enemigos o ambos en un ambiente de un videojuego?',1);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta causar caos/desastre en un videojuego, como volar cosas por los aires?',1);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas de juegos de acción rápida que requieren decisiones rápidas y reflejos ágiles?',2);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te atraen los juegos que mantienen un ritmo trepidante y constante, sin momentos de pausa prolongados?',2);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta competir con otros jugadores para demostrar tus habilidades, ya sea en estrategia o tácticas?',3);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te motiva la idea de ser el mejor en un juego multijugador competitivo?',3);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Prefieres juegos donde puedas colaborar con amigos o formar equipos para completar objetivos juntos?',4);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas interactuar con otros jugadores, más allá del juego en sí como por ejemplo en chats?',4);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te atraen los juegos que presentan niveles de dificultad elevados, donde el fracaso forma parte del aprendizaje?',5);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas superar retos en videojuegos que requieren mucha habilidad y concentración?',5);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gustan los juegos que requieren planificación y pensamiento táctico antes de tomar decisiones?',6);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta crear estrategias complejas en videojuegos de diferentes géneros?',6);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta sentir que estás progresando en un juego a través de niveles, habilidades o mejoras de equipo?',7);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas acumular puntos, monedas o recursos, sintiendo que esto contribuye al desarrollo de tu personaje?',7);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te motiva la idea de que tu personaje se vuelva más poderoso y tenga nuevas habilidades a medida que avanzas en el juego?',8);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta obtener habilidades o equipamiento especial que te permitan superar desafíos más difíciles en el juego?',8);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te atraen los juegos que te permiten sumergirte en mundos imaginarios o fantásticos, donde la exploración es crucial?',9);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta interpretar personajes con poderes o habilidades extraordinarias que no existen en la vida real?',9);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas de juegos con una historia envolvente, que sea atrapante y haga querer descubrir más?',10);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Prefieres juegos donde puedes seguir una trama compleja y rica en detalles, con personajes bien desarrollados y arcos narrativos intrigantes?',10);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta poder personalizar tu personaje o las opciones visuales del juego, como ropa, accesorios y habilidades?',11);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te motiva la idea de hacer que tu avatar sea único, cambiando su apariencia como colores, atuendos y peinados?',11);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te atraen los juegos que te permiten crear o modificar estructuras, mundos o entornos, personalizando cada detalle a tu propio gusto?',12);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas construir cosas dentro del juego, como casas, ciudades o vehículos o cualquier tipo de estructura que puedas imaginar?',12);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te atraen los juegos con gráficos detallados y visualmente impresionantes, que mejoran la experiencia del videojuego?',13);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas de los paisajes y la estética visual de los entornos en los videojuegos, valorando tanto la calidad como la diversidad de los escenarios?',13);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Prefieres videojuegos que tengan un estilo artístico único, como gráficos cel-shaded, minimalistas o pixel art?',14);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gustan los videojuegos que optan por un enfoque artístico interesante y creativo, en lugar de centrarse en un realismo gráfico?',14);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te gusta perderte en mundos virtuales, explorando cada rincón y descubriendo su historia?',15);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te motiva la idea de descubrir nuevas áreas o lugares escondidos dentro del juego, sintiendo que cada relevación enriquece tu experiencia de juego?',15);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Te atraen los juegos que te sorprenden con secretos, misterios y giros inesperados en la trama?',16);
insert into preguntas_motivacion(pregunta, especialidad) VALUES ('¿Disfrutas resolver acertijos, encontrar detalles ocultos o descubrir mecánicas de juego ingeniosas en el entorno?',16);

ALTER TABLE preguntas_motivacion RENAME COLUMN especialidad TO especialidad_id;


/* 

	Creacion de tablas
	(con referencias de más de 1 tabla)

*/

--creación de tabla que conecta un videojuego con su o más de 1 plataforma--
create table videojuego_plataforma(
	id_videojuego_plataforma serial PRIMARY KEY,
	videojuego bigint not null,
	plataforma integer not null,
	CONSTRAINT FK_videoplat_videojuegos FOREIGN KEY (videojuego) REFERENCES videojuego(id_videojuego),
	CONSTRAINT FK_videoplat_plataforma FOREIGN KEY (plataforma) REFERENCES plataforma(id_plataforma)
);

ALTER TABLE videojuego_plataforma RENAME COLUMN videojuego TO videojuego_id;
ALTER TABLE videojuego_plataforma RENAME COLUMN plataforma TO plataforma_id;

--creacion de tabla la decision de videojuegos por parte de los usuarios--
create table recomendacion_usuario(
	id_recomend_usuario serial PRIMARY KEY,
	opcion int not null,
	usuario bigint not null,
	videojuego bigint not null,
	CONSTRAINT FK_recomendus_opcion FOREIGN KEY (opcion) REFERENCES decision_recomendacion(id_opcion),
	CONSTRAINT FK_recomendus_usuario FOREIGN KEY (usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT FK_recomendus_videojuego FOREIGN KEY (videojuego) REFERENCES videojuego(id_videojuego)
);

ALTER TABLE recomendacion_usuario RENAME COLUMN usuario TO usuario_id;
ALTER TABLE recomendacion_usuario RENAME COLUMN opcion TO opcion_id;
ALTER TABLE recomendacion_usuario RENAME COLUMN videojuego TO videojuego_id;

alter table recomendacion_usuario add constraint recomendacion_usuario_norepetido UNIQUE (usuario_id,videojuego_id);


/*creacion de tabla temporal (CSV a PostgreSQL)
 donde se importaran los datos de videojuegos 
 a las entidades que utilizara la página
*/

create table temporal(
	portada varchar(250),
	nombre_videojuego varchar(500),
	consola varchar(50),
	genero char(250),
	distribuidor varchar(500),
	empresa_desarrollo varchar(500),
	fecha_lanzamiento date
);
	
copy temporal(portada,nombre_videojuego,consola,genero,distribuidor,empresa_desarrollo,fecha_lanzamiento)
from 'C:\Users\dany3\OneDrive\Escritorio\GameMatch\videojuegos-2024 - vgchartz-2024.csv'
delimiter ','
csv header;

--Insertar los diferentes plataformas existentes de videojuegos--
insert into plataforma(consola)
select distinct consola
from temporal;

--Insertar fecha de lanzamiento mas antigua (original) en que se estreno el videojuego--
WITH fecha_lanzamiento_original AS (
    SELECT 
        nombre_videojuego, portada, genero, empresa_desarrollo, distribuidor, fecha_lanzamiento,
        ROW_NUMBER() OVER (PARTITION BY nombre_videojuego order by fecha_lanzamiento ASC) AS videojuego_original
    FROM temporal
    WHERE empresa_desarrollo is not null AND fecha_lanzamiento is not null
)


insert into videojuego(nombre,portada,genero,fecha_lanzamiento,empresa_desarrollo,distribuidor)
SELECT nombre_videojuego, portada, genero, fecha_lanzamiento, empresa_desarrollo, distribuidor
FROM fecha_lanzamiento_original
WHERE videojuego_original = 1;

insert into videojuego_plataforma(videojuego_id,plataforma_id)
select v.id_videojuego, plat.id_plataforma
from videojuego as v, plataforma as plat, temporal as tempo
where v.nombre = tempo.nombre_videojuego and plat.consola = tempo.consola;

--creación de tabla argumento/sinopsis de cada videojuego
create table argumento_videojuego(
	id_argumento SERIAL PRIMARY KEY,
	argumento varchar(700) not null,
	videojuego bigint not null,
	CONSTRAINT FK_argumento_videojuego FOREIGN KEY (videojuego) REFERENCES videojuego(id_videojuego)
);

--1 Videojuego pertenece a un argumento, 1 Argumento pertenece a un Videojuego--
ALTER TABLE argumento_videojuego
ADD CONSTRAINT unique_argumento_videojuego
UNIQUE (argumento);

ALTER TABLE argumento_videojuego
ADD CONSTRAINT unique_videojuego_argumento
UNIQUE (videojuego);

ALTER TABLE argumento_videojuego RENAME COLUMN videojuego TO videojuego_id;

insert into argumento_videojuego(argumento,videojuego_id) VALUES ('Tras escapar por los pelos de un destino condenado en un manicomio, un guerrero no muerto se abre camino a través de los desolados restos de Lordran, antaño una extensa utopía liderada por los dioses, para buscar su propósito y cumplir una profecía de siglos de antigüedad.',6949);

--creacion de tabla que guarda las respuestas del usuario en la creación de perfil--
create table motivacion_jugador(
	id_motiv_jugador SERIAL PRIMARY KEY,
	usuario bigint not null,
	pregunta int not null, 
	escala int not null,
	CONSTRAINT motvjug_usuario FOREIGN KEY (usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT motvjug_pregunta FOREIGN KEY (pregunta) REFERENCES preguntas_motivacion(id_pregunta),
	CONSTRAINT motvjug_escala FOREIGN KEY (escala) REFERENCES escala_pregunta(id_escala)
);

ALTER TABLE motivacion_jugador RENAME COLUMN usuario TO usuario_id;
ALTER TABLE motivacion_jugador RENAME COLUMN pregunta TO pregunta_id;
ALTER TABLE motivacion_jugador RENAME COLUMN escala TO escala_id;

alter table motivacion_jugador
add constraint motivacion_jugador_norepetido UNIQUE (usuario_id,pregunta_id,escala_id);


--creación de tabla que conecta el videojuego con las especialidades que representa--
create table videojuego_especialidad(
	id_videojuego_especialidad SERIAL PRIMARY KEY,
	videojuego bigint not null,
	especialidad int not null,
	CONSTRAINT FK_videospeci_videojuego FOREIGN KEY (videojuego) REFERENCES videojuego(id_videojuego),
	CONSTRAINT FK_videoespeci_especialidad FOREIGN KEY (especialidad) REFERENCES especialidad(id_especialidad)
);

ALTER TABLE videojuego_especialidad RENAME COLUMN videojuego TO videojuego_id;
ALTER TABLE videojuego_especialidad RENAME COLUMN especialidad TO especialidad_id;

alter table videojuego_especialidad
add constraint videojuego_especialidad_norepetido UNIQUE (videojuego_id, especialidad_id);


--Rellenar tabla que conecta videojuego que cumpla con especialidad o más de una--

/* Categoría: Acción 
	(1) 
*/

--Insert de videojuegos que cumplan con la especialidad Destrucción--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12390,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24565,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24566,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3100,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3101,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3102,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19556,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1538,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35071,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10201,1);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3077,1);



/*select id_videojuego, nombre from videojuego 
	where nombre
	LIKE '%Far Cry 5%' or nombre
	LIKE '%Wreckfest%' or nombre
	LIKE '%Battlefield 1' or nombre
	LIKE '%Angry Birds%' or nombre
	LIKE '%Mordhau%'*/

--Insert de videojuegos que cumplan con la especialidad Intensidad--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4708,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4709,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4710,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4711,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4712,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4713,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4714,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4715,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6536,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8189,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29487,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29488,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32140,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29486,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4716,2);



insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7087,2);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21963,2);





/* Categoría: Socialización 
	(2) 
*/

--Insert de videojuegos que cumplan con la especialidad Competencia--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1719,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16711,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25128,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (33672,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4721,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8286,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10985,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19572,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19573,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19574,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19575,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19576,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19588,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29647,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32371,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10394,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10395,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10396,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10398,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10399,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10400,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10401,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10402,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10407,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4710,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4709,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4714,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12945,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12355,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13322,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20452,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20451,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20444,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20445,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20446,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20447,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20448,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20449,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32718,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34935,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17512,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17513,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17514,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17515,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17516,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17517,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17518,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17519,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17526,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17527,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27468,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22921,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22923,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30363,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30364,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30365,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30366,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28780,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28783,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28784,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28785,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32726,3);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35034,3);




/*select id_videojuego, nombre from videojuego
where nombre like '%Forest%' or
	  nombre like '%Cuphead%' or
	  nombre like '%Borderlands%' or
	  nombre like '%Starve%' or
	  nombre like '%Tarkov%' or
	  nombre like '%Spelunky%' or
	  nombre like '%Ascension%' or
	  nombre like '%ARK%'
order by nombre asc*/
	  


--Insert de videojuegos que cumplan con la especialidad Colaboración--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21943,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21944,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21945,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16734,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16735,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26036,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4095,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7267,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7498,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (14038,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (18993,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28788,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22307,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34166,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4979,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4980,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7596,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11664,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11752,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11749,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17298,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21223,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32388,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32387,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1910,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4092,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4093,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4096,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6536,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8129,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8130,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28301,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28302,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30956,4);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32672,4);











/* Categoría: Maestría
	(3) 
*/

--Insert de videojuegos que cumplan con la especialidad Dificultad--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6536,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6943,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6944,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6945,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6946,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6947,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6949,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13818,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13819,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29486,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29487,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29488,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3828,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7087,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9469,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25181,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30700,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30701,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30702,5);

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19436,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19437,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21185,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21186,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11274,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25683,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28301,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28302,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35237,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35238,5);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21184,5);

--Insert de videojuegos que cumplan con la especialidad Estrategia--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (747,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (748,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (749,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (750,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (751,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (897,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (898,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (899,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (900,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (901,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (902,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (903,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (904,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (905,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (906,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (910,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10660,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26966,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26967,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28780,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28782,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28783,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28784,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28785,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28908,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30669,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30670,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30671,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30672,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32582,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34174,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35237,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35238,6);


insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1628,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5962,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5963,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5964,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5965,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5966,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6425,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6426,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6427,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6428,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6964,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6965,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8286,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9980,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27054,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32584,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32957,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32956,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32954,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32953,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32951,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32950,6);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32949,6);



/* Categoría: Logro 
	(4) 
*/

--Insert de videojuegos que cumplan con la especialidad Avance--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2162,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7498,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7499,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7596,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7597,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11851,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12833,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19432,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28788,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31292,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34935,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1910,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4093,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10045,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10201,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22427,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25338,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25339,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25340,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27513,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30511,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12659,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12660,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12661,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12662,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12663,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12664,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16095,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22855,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25128,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26442,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27058,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27059,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27534,7);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32388,7);


--Insert de videojuegos que cumplan con la especialidad Fortaleza--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4095,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6943,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6944,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6945,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6946,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6947,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6949,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9287,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10551,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10555,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11931,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19437,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21184,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21185,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22431,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26239,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31869,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31870,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2156,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2157,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3156,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5033,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7362,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7993,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7994,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8449,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13818,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21018,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21019,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24353,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30879,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30880,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3154,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3157,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6964,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6965,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7995,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7992,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10592,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19428,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19434,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19433,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22424,8);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31299,8);


/* Categoría: Inmersión 
	(5) 
*/

--Insert de videojuegos que cumplan con la especialidad Fantasía--


insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6943,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6944,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6945,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6946,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6947,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6949,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7993,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8449,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10588,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13818,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19437,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30879,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30880,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31292,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34935,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20976,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1910,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5331,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8426,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9287,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9958,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10592,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11851,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12516,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30081,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35543,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2162,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5334,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8450,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8451,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9612,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9613,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9614,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9615,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9616,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9618,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10645,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12311,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12312,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19433,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19434,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20978,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20979,9);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28287,9);


--Insert de videojuegos que cumplan con la especialidad Narrativa--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7792,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10696,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11931,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16948,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16950,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24551,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24552,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24553,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24557,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30669,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30670,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30671,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30672,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31232,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31233,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31234,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31235,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31236,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31237,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31867,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31868,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31869,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31870,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34400,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2156,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2157,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12269,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13362,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13363,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15840,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15841,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21968,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31041,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31473,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31834,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31835,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31837,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31838,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32177,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (461,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4350,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7538,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12518,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12519,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24789,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30078,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31132,10);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31881,10);


/* Categoría: Creatividad 
	(6) 
*/

--Insert de videojuegos que cumplan con la especialidad Individualización--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1569,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1571,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1572,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1570,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1566,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1567,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1568,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6611,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10045,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10053,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10058,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11001,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12385,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12386,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12387,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12388,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12390,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12392,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12393,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12394,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12398,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12399,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12400,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12401,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (18153,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29024,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29025,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31674,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34935,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1910,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7498,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7499,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10985,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16095,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21963,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21964,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25338,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (23094,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25339,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25340,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26036,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28031,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34286,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34287,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34288,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8286,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10047,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12355,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22431,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22432,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24213,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27894,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29023,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30873,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30879,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30880,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35097,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6943,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6944,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6945,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6946,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6947,11);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6949,11);



--Insert de videojuegos que cumplan con la especialidad Creación--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5548,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5549,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5550,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8738,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9980,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17075,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17076,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17077,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17078,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17082,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (18993,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22855,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22856,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28082,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (1910,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2780,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11079,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21223,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21969,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (22874,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31636,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31637,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31658,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31674,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31677,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5541,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5542,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5543,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (23685,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28426,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4998,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16831,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16825,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16799,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16845,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16852,12);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20015,12);



/* Categoría: Estética 
	(7) 
*/

--Insert de videojuegos que cumplan con la especialidad Apreciación Visual--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2156,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2157,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2158,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6037,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6611,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10555,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11931,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13892,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21768,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24551,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24552,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24553,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24557,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31232,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31233,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31234,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31235,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31236,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31237,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (33412,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2162,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3096,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6946,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7374,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3502,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (18758,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24723,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28701,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34288,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2154,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9007,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9287,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10592,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11001,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11744,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21018,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21019,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26239,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31869,13);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31870,13);


--Insert de videojuegos que cumplan con la especialidad Estilo Artístico--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5090,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6536,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10696,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13818,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (14528,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15312,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21968,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31874,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (443,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10381,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15728,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (27534,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28364,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28788,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (33441,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35452,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (815,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5531,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17061,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17062,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21966,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24789,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30669,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30670,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30671,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30672,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (14100,14);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (14101,14);


/* Categoría: Descubrimiento 
	(8) 
*/

--Insert de videojuegos que cumplan con la especialidad Aventura--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2156,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10696,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13818,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15312,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21904,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (29154,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30880,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30881,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31869,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31870,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21223,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6943,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6944,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6945,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6946,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6947,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6949,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (8449,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9287,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11931,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16086,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16087,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16088,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16089,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16090,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16091,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16092,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16093,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16094,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16095,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16096,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16097,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16099,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16100,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16102,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16103,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16104,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16105,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16106,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16641,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24945,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (25528,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26444,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32394,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31776,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32393,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32397,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32398,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32399,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32400,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32401,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32402,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32404,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32406,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32407,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32405,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32408,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32409,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (32410,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2154,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (5090,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10644,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10645,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10966,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13892,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15421,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15422,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15423,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (15424,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26036,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28301,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28302,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31299,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31300,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31301,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31473,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (35452,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2162,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (2224,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9951,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9952,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9953,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9954,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9955,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9956,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9957,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9958,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9959,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9960,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9961,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9962,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (9963,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11961,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19436,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19437,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (28779,15);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (30511,15);


--Insert de videojuegos que cumplan con la especialidad Curiosidad--

insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (4179,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10381,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (11942,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (14528,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20047,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20048,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20049,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20050,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20052,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20053,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20054,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (20055,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21904,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (23243,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (23244,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (23245,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (24789,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31795,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (34400,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (461,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12518,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12519,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (12833,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16693,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (16694,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17061,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (17062,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21968,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31725,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31755,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31756,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3495,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3496,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3497,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3502,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (3503,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (6858,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (10696,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31295,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31296,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31558,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31559,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31812,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31933,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (19822,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7135,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7136,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7137,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7138,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7139,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7140,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (7141,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (13467,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21028,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (21029,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (26442,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31225,16);
insert into videojuego_especialidad (videojuego_id,especialidad_id) VALUES (31825,16);



	
--función para que las portadas de cada videojuego provengan de directorios que posee el administrador--

UPDATE videojuego SET portada = 'imagenes/GM.' || nombre;

UPDATE videojuego
SET portada = 	
(SELECT 
    CASE 
        WHEN POSITION('GM.' IN portada) > 0 
		THEN 
            SUBSTRING(portada FROM 1 FOR POSITION('GM' IN portada) + 1) || 
            REGEXP_REPLACE(SUBSTRING(portada FROM POSITION('GM' IN portada) + 2), '[\/:*?"<>|]', '', 'g')
        ELSE 
            portada
		END);


CREATE OR REPLACE FUNCTION directorio_caracteres_permitidos()
RETURNS TRIGGER AS $$
BEGIN
	if (
		NEW.nombre LIKE '%\%' or 
		NEW.nombre LIKE '%/%' or 
		NEW.nombre LIKE '%:%' or
		NEW.nombre LIKE '%*%' or
		NEW.nombre LIKE '%?%' or 
		NEW.nombre LIKE '%"%' or
		NEW.nombre LIKE '%<%' or
		NEW.nombre LIKE '%>%' or
		NEW.nombre LIKE '%|%'
		)
	THEN
		
    NEW.nombre_videojuego := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NEW.nombre,'%\%',''),'%/%',''),'%:%',''),'%*%',''),'%?%',''),'"',''),'<',''),'>',''),'','');

	ELSE 

	NEW.nombre_videojuego := NEW.nombre;

	END IF;

	NEW.portada := 'imagenes/GM.' || NEW.nombre_videojuego;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
	

CREATE TRIGGER trigger_portadas
BEFORE INSERT OR UPDATE ON videojuego
FOR EACH ROW
EXECUTE FUNCTION directorio_caracteres_permitidos();

/*caracteres que no se pueden permitir en nombres de las imagenes (portadas)
	\ / : * ? " < > |                
*/

