from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.core.exceptions import ObjectDoesNotExist
from django.utils.translation import gettext_lazy as _

class Genero(models.Model):
    id_genero = models.AutoField(primary_key=True)
    nombre_genero = models.CharField(max_length=10)

    class Meta:
        db_table = 'genero'
        managed = False

    def __str__(self):
        return f'ID: {self.id_genero} pertenece al género {self.nombre_genero}'
    
class Nacionalidad(models.Model):
    id_nacionalidad = models.AutoField(primary_key=True)
    nacionalidad = models.CharField(max_length=50)
    bandera = models.CharField(max_length=250)

    class Meta:
        db_table = 'nacionalidad'
        managed = False

    def __str__(self):
        return f'ID: {self.id_nacionalidad} pertenece al país {self.nacionalidad}'


class EscalaPregunta(models.Model):
    id_escala = models.AutoField(primary_key=True)
    escala = models.CharField(max_length=50)

    class Meta:
        db_table = 'escala_pregunta'
        managed = False

    def __str__(self):
        return f'La puntuación de la opción "{self.escala}" es: {self.id_escala}'


class Categoria(models.Model):
    id_categoria = models.AutoField(primary_key=True)
    categoria = models.CharField(max_length=20)

    class Meta:
        db_table = 'categoria'
        managed = False

    def __str__(self):
        return f'Categoría número {self.id_categoria}: {self.categoria}'


class Plataforma(models.Model):
    id_plataforma = models.AutoField(primary_key=True)
    consola = models.CharField(max_length=250)

    class Meta:
        db_table = 'plataforma'
        managed = False

    def __str__(self):
        return f'El ID: {self.id_plataforma} pertenece a la consola "{self.consola}"'


class DecisionRecomendacion(models.Model):
    id_opcion = models.AutoField(primary_key=True)
    recomendacion_aceptada = models.BooleanField(default=False)

    class Meta:
        db_table = 'decision_recomendacion'
        managed = False

    def __str__(self):
        if (self.id_opcion==True):
            return f'Opción {self.id_opcion}: Carta de Recomendación Aceptada'
        else:
            return f'Opción {self.id_opcion}: Carta de Recomendación Rechazada'
    
class Especialidad(models.Model):
    id_especialidad= models.AutoField(primary_key=True)
    especialidad= models.CharField(max_length=25)
    categoria= models.ForeignKey('Categoria', on_delete=models.CASCADE)

    class Meta:
        db_table = 'especialidad'
        managed = False

    def __str__(self):
        return f'La especialidad {self.especialidad} pertenece a la Categoría: {self.categoria.categoria}'
    
class Argumento_Videojuego(models.Model):
    id_argumento= models.AutoField(primary_key=True)
    argumento= models.CharField(max_length=700)
    videojuego= models.ForeignKey('Videojuego', on_delete=models.CASCADE, related_name='argumentovideojuego')

    class Meta:
        db_table = 'argumento_videojuego'
        managed = False

    def __str__(self):
        return f'{self.videojuego.nombre}-{self.argumento}'
    
class Videojuego(models.Model):
    id_videojuego= models.AutoField(primary_key=True) 
    nombre= models.CharField(max_length=500, unique=True)
    portada= models.CharField(max_length=250)
    genero= models.CharField(max_length=100)
    fecha_lanzamiento= models.DateField()
    empresa_desarrollo= models.CharField(max_length=500)
    distribuidor= models.CharField(max_length=500)
    plataformas = models.ManyToManyField(Plataforma, through='videojuego_plataforma')

    class Meta:
        db_table = 'videojuego'
        managed = False

    def __str__(self):
        return self.nombre
    
    
class Videojuego_Plataforma(models.Model):
    id_videojuego_plataforma= models.AutoField(primary_key=True)
    videojuego= models.ForeignKey('Videojuego', on_delete=models.CASCADE)
    plataforma= models.ForeignKey('Plataforma', on_delete=models.CASCADE)

    class Meta:
        db_table = 'videojuego_plataforma'
        managed = False

    def __str__(self):
        return f'{self.videojuego.nombre} esta disponible en las plataforma: {self.plataforma}'
    
class Preguntas_Motivacion(models.Model):
    id_pregunta= models.AutoField(primary_key= True)
    pregunta= models.CharField(max_length=250)
    especialidad= models.ForeignKey('Especialidad', on_delete=models.CASCADE)

    class Meta:
        db_table = 'preguntas_motivacion'
        managed = False

    def __str__(self):
        return f'La pregunta {self.id_pregunta} pertenece a la especialidad {self.especialidad.especialidad}'
    
class UsuarioManager(BaseUserManager):
    #Gestión de creación de usuario estándar
    def create_user(self, nombre_usuario, correo_electronico, password=None, genero=None, fecha_nacimiento=None, nacionalidad=None):
        if not nombre_usuario:
            raise ValueError('El nombre de usuario es un campo obligatorio')
        if not correo_electronico:
            raise ValueError('El correo electrónico es un campo obligatorio')
        if genero is None:
            raise ValueError('El género es un campo obligatorio')
        if fecha_nacimiento is None:
            raise ValueError('La fecha de nacimiento es un campo obligatorio')
        if nacionalidad is None:
            raise ValueError('La nacionalidad es un campo obligatorio')
        
        if isinstance(genero, int): 
            try:
                genero = Genero.objects.get(id_genero=genero)
            except Genero.DoesNotExist:
                raise ValueError(f'Género perteneciente a ID:{genero} no está registrado en la base de datos')

        if isinstance(nacionalidad, int): 
            try:
                nacionalidad = Nacionalidad.objects.get(id_nacionalidad=nacionalidad)
            except Nacionalidad.DoesNotExist:
                raise ValueError(f'Nacionalidad perteneciente a ID:{nacionalidad} no está registrado en la base de datos')

        usuario = self.model(
            nombre_usuario=nombre_usuario,  
            correo_electronico=self.normalize_email(correo_electronico),
            genero=genero,
            fecha_nacimiento=fecha_nacimiento,
            nacionalidad=nacionalidad,
            is_active=True,
            is_staff=False,
            is_superuser=False,
        )
        #Método para encriptar contraseñas de la librería Django para usuarios estándares
        usuario.set_password(password) 
        usuario.save(using=self._db)
        return usuario

    def create_superuser(self, nombre_usuario, correo_electronico, password, genero, fecha_nacimiento, nacionalidad):
        usuario = self.create_user(
            nombre_usuario,
            correo_electronico,
            password,
            genero=genero,
            fecha_nacimiento=fecha_nacimiento,
            nacionalidad=nacionalidad,
        )
        usuario.is_staff = True
        usuario.is_active = True
        usuario.is_superuser = True
        usuario.save(using=self._db)
        return usuario
    
class Usuario(AbstractBaseUser):    
    id_usuario = models.AutoField(primary_key=True)
    nombre_usuario = models.CharField(max_length=20, unique=True)
    genero = models.ForeignKey(Genero, on_delete=models.CASCADE)
    correo_electronico = models.EmailField(max_length=250)
    fecha_nacimiento = models.DateField()
    nacionalidad = models.ForeignKey(Nacionalidad, on_delete=models.CASCADE)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    last_login = models.DateTimeField(null=True, blank=True)
    password = models.CharField(max_length=250)

    objects = UsuarioManager()

    USERNAME_FIELD = 'nombre_usuario'
    REQUIRED_FIELDS = ['genero','correo_electronico','fecha_nacimiento','nacionalidad']

    class Meta:
        db_table = 'usuario'
        managed = False

    def __str__(self):
        if (self.is_superuser==True):
            return f'Usuario Administrador: {self.nombre_usuario}'
        else:
            return f'Usuario Estándar: {self.nombre_usuario}' 
    
    def has_perm(self, perm, obj=None):
        return self.is_superuser
    
    def has_module_perms(self, app_label):
        return self.is_superuser
    
class Motivacion_Jugador(models.Model): 
    id_motiv_jugador= models.AutoField(primary_key=True)
    usuario= models.ForeignKey('Usuario', on_delete=models.CASCADE)
    pregunta= models.ForeignKey('Preguntas_Motivacion', on_delete=models.CASCADE)
    escala= models.ForeignKey('EscalaPregunta', on_delete=models.CASCADE)

    class Meta:
        db_table = 'motivacion_jugador'
        managed = False

    def __str__(self):
        return f'{self.usuario.nombre_usuario} ha escogido la opción {self.escala.id_escala} en la pregunta {self.pregunta.id_pregunta}'
    
class Videojuego_Especialidad(models.Model):
    id_videojuego_especialidad= models.AutoField(primary_key=True)
    videojuego= models.ForeignKey('Videojuego', on_delete=models.CASCADE)
    especialidad= models.ForeignKey('Especialidad', on_delete=models.CASCADE)

    class Meta:
        db_table = 'videojuego_especialidad'
        managed = False

    def __str__(self):
        return f'El videojuego {self.videojuego.nombre} cumple con la especialidad: {self.especialidad.especialidad}'
    
class Recomendacion_Usuario(models.Model):
    id_recomend_usuario= models.AutoField(primary_key=True)
    opcion= models.ForeignKey('DecisionRecomendacion', on_delete=models.CASCADE)
    usuario= models.ForeignKey('Usuario', on_delete=models.CASCADE)
    videojuego= models.ForeignKey('Videojuego', on_delete=models.CASCADE)

    class Meta:
        db_table = 'recomendacion_usuario'
        managed = False

    def __str__(self):
        if self.opcion.id_opcion==1:
            return f'{self.usuario.nombre_usuario} ha aceptado la carta de recomendación de: {self.videojuego.nombre}'
        elif self.opcion.id_opcion==2:
            return f'({self.usuario.nombre_usuario} ha rechazado la carta de recomendación de: {self.videojuego.nombre}'