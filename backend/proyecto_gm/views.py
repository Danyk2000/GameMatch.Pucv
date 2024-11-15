from rest_framework import viewsets
from django.http import JsonResponse    
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.authtoken.models import Token
from rest_framework import status
from django.contrib.auth import get_user_model
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.utils import timezone
from django.db import models
from django.db.models.functions import ExtractYear
from django.db.models import Sum
from rest_framework.decorators import api_view, permission_classes
from .models import Usuario, Genero, Nacionalidad, DecisionRecomendacion, EscalaPregunta, Plataforma, Especialidad, Videojuego, Categoria, Argumento_Videojuego, Preguntas_Motivacion, Videojuego_Plataforma, Recomendacion_Usuario, Videojuego_Especialidad, Motivacion_Jugador
from .serializers import UsuarioSerializer, GeneroSerializer, NacionalidadSerializer, Decision_RecomendacionSerializer, Escala_PreguntaSerializer, PlataformaSerializer, EspecialidadSerializer, VideojuegoSerializer, Videojuego_PlataformaSerializer, Argumento_VideojuegoSerializer, PreguntasMotivacionSerializer, CategoriaSerializer, Motivacion_JugadorSerializer, Recomendacion_UsuarioSerializer, Videojuego_EspecialidadSerializer
import json


class GeneroViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Genero.objects.all()
    serializer_class = GeneroSerializer

class NacionalidadViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Nacionalidad.objects.all()
    serializer_class = NacionalidadSerializer

class CategoriaViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

class PlataformaViewSet(viewsets.ModelViewSet):

    queryset = Plataforma.objects.all()
    serializer_class = PlataformaSerializer

class Escala_PreguntaViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = EscalaPregunta.objects.all()
    serializer_class = Escala_PreguntaSerializer

class Decision_RecomendacionViewSet(viewsets.ModelViewSet):
    queryset = DecisionRecomendacion.objects.all()
    serializer_class = Decision_RecomendacionSerializer


class EspecialidadViewSet(viewsets.ModelViewSet):
    queryset = Especialidad.objects.all()
    serializer_class = EspecialidadSerializer

class VideojuegoViewSet(viewsets.ModelViewSet):
    queryset = Videojuego.objects.all()
    serializer_class = VideojuegoSerializer

class Argumento_VideojuegoViewSet(viewsets.ModelViewSet):
    queryset = Argumento_Videojuego.objects.all()
    serializer_class = Argumento_VideojuegoSerializer

class Videojuego_PlataformaViewSet(viewsets.ModelViewSet):
    queryset = Videojuego_Plataforma.objects.all()
    serializer_class = Videojuego_PlataformaSerializer

class PreguntasMotivacionViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Preguntas_Motivacion.objects.all()
    serializer_class = PreguntasMotivacionSerializer

@permission_classes([IsAuthenticated])
class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer

class Videojuego_EspecialidadViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Videojuego_Especialidad.objects.all()
    serializer_class = Videojuego_EspecialidadSerializer

class Recomendacion_UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Recomendacion_Usuario.objects.all()
    serializer_class = Recomendacion_UsuarioSerializer

class Motivacion_JugadorViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Motivacion_Jugador.objects.all()
    serializer_class = Motivacion_JugadorSerializer

    def create(self, request, *args, **kwargs):
        usuario_id = request.data.get('usuario')
        pregunta_id = request.data.get('pregunta')
        escala_id = request.data.get('escala')

        #Comprobar que el usuario ya haya contestado el cuestionario de Creación de Perfil
        # Evitar que el formulario haga un reenvío de los datos (para no infringir la unicidad del usuario con las preguntas del cuestionario)
        if Motivacion_Jugador.objects.filter(usuario_id=usuario_id, pregunta_id=pregunta_id, escala_id=escala_id).exists():
            return Response({"detail": "Ya existe registros de este usuario respondiendo a esta pregunta."}, status=status.HTTP_400_BAD_REQUEST)

        #
        return super().create(request, *args, **kwargs)

#Vista para registrar al usuario, completando sus datos personales como requisito
@csrf_exempt
def registro_usuario(request):
    print("Vista de registro de usuarios convocada")
    if request.method == 'GET':
        return JsonResponse({'message': 'Vista activada, debes completar tus datos'}, status=200)
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            genero, _ = Genero.objects.get_or_create(id_genero=data['genero'])
            nacionalidad, _ = Nacionalidad.objects.get_or_create(id_nacionalidad=data['nacionalidad'])

            nuevo_usuario = Usuario.objects.create_user(
                nombre_usuario=data['nombre_usuario'],
                correo_electronico=data['correo_electronico'],
                password=(data['password']),
                genero=genero,
                fecha_nacimiento=data['fecha_nacimiento'],
                nacionalidad=nacionalidad,
            )

            nuevo_usuario.save()
            print(f"Usuario guardado: {nuevo_usuario.id_usuario}")

            try:
                token = Token.objects.create(user=nuevo_usuario)
            except Exception as e:
                print(f"Error! No se ha podido crear el token para el usuario {nuevo_usuario.id_usuario}: {e}")
                return JsonResponse({'success': False, 'message': 'Error al crear el token'}, status=500)

            return JsonResponse({
                'success': True,
                'id_usuario': nuevo_usuario.id_usuario,
                'token': token.key,
                'message': 'Cuenta de Usuario creada, proceso completado'
            }, status=201)    
        
        except ValueError as ve:
            print(f"Error: {ve}")
            return JsonResponse({'success': False, 'message': str(ve)}, status=400)
        except Exception as e:
            print(f"Error: {e}")  
            return JsonResponse({'success': False, 'message': str(e)}, status=500)

    return JsonResponse({'success': False, 'message': 'Método no permitido'}, status=405)


#Vista para comrpobar login al sistema, a tráves de ingresando el nombre de usuario y contraseña
#Si los datos están registrados se permitirá al acceso a la sesión, si no es así se informará que los datos no son válidos 
class LoginView(APIView):

    def post(self, request):
        
    
        nombre_usuario = request.data.get('nombre_usuario')
        password = request.data.get('password')

        print(f"Intento de inicio de sesión - Usuario: {nombre_usuario}, Contraseña: {password}")
         
        user = get_user_model()  
        user = user.objects.filter(nombre_usuario=nombre_usuario).first()

        if user and user.check_password(password):
            user.last_login = timezone.now()
            user.save()

            token, created = Token.objects.get_or_create(user=user)
            return Response({'token': token.key, 'id_usuario': user.id_usuario, 'message': 'Inicio de sesión logrado'}, status=status.HTTP_200_OK)
        else:
            print(f"Datos incorrectos, Usuario: {nombre_usuario}")
            return Response({'message': 'Datos inválidos'}, status=status.HTTP_401_UNAUTHORIZED)
        
#Vista que permite obtener el nombre de usuario comprobando si es que esta autenticado   
class UserNameView(APIView):   
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user  
        if user.is_authenticated:
            return Response({
                'nombre_usuario': user.nombre_usuario,
            })
        else:
            return Response({'error': 'Usuario no identificado'}, status=401)
        

#Vista que permite obtener los distintos generos existentes de videojuegos        
class GenerosVListView(APIView):
    def get(self, request):
        generos_videojuegos = Videojuego.objects.values_list('genero', flat=True).distinct()
        return Response(generos_videojuegos)
    
#Vista que permite obtener los diferentes años (years) de las fechas en que se estrenaron los videojuegod
def years_videojuego(request):
    if request.method == 'GET':
        try:
            videojuegos = Videojuego.objects.annotate(anyo=ExtractYear('fecha_lanzamiento')).order_by('anyo')
            anyos_lanzamiento = set([videojuego.anyo for videojuego in videojuegos])
            anyos_lanzamiento = sorted(list(anyos_lanzamiento))

            return JsonResponse({"Años en que se lanzaron los videojuegos registrados": anyos_lanzamiento})
        except Exception as e: 
            return JsonResponse({"Error": str(e), "No se han encontrado años de videojuegos...": []})
        
         
        
#Vista que permite obtener y seleccionar las diferentes plataformas que están disponibles para videojuegos
def plataforma_sel(request):
    plataformas_seleccionables= Plataforma.objects.filter(consola__in=['PC','PS4','PS5','PS3','PS2','X360','XS','NS','PS'])
    if plataformas_seleccionables:
        print(plataformas_seleccionables)
    else:
        print("No se han encontrado plataformas de videojuegos")

    plataformas_data= [{'id_plataforma': plataforma.id_plataforma, 'nombre_plataforma': plataforma.consola} for plataforma in plataformas_seleccionables]
    print(plataformas_data)

    return JsonResponse({'Las plataformas seleccionables son': plataformas_data})



#Algoritmo de recomendación, usando técnica hibrida de filtración y basado en contenido
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def recomendar_videojuego_filtracion( request):
    usuario_id = request.user.id_usuario
    genero = request.GET.get('genero', '').strip()
    fecha_lanzamiento = request.GET.get('anyo')
    get_plataformas = request.GET.get('plataforma','')
    especialidades_recomendacion = []
    especialidades_norecomendacion = []
    get_especialidades_preguntas = {}
    ponderaciones_cuestionario = {}

    #Uso de lista de objetos/querysets 
    # Videojuegos (Retornar los recomendaciones para el usuario) y Especialidades (Contenido del Perfil del Usuario)
    videojuegos = Videojuego.objects.all()
    especialidades = Especialidad.objects.all()

    #Si se elige 1 o más de plataforma, se agrega una coma entre los valores elegidos
    #Si no se elige ningún valor para plataformas, se asignará como lista vacía 
    if get_plataformas:
        plataformas = get_plataformas.split(',') 
    else:
        plataformas = []

    #Si no se completa por lo menos uno de los tres formularios, no se calculará las recomendaciones
    #Advertir el uso obligatorio de filtros seleccionables para la generación de recomendaciones
    if not genero and not fecha_lanzamiento and not plataformas:
        return JsonResponse({
            "message": "No se han utilizado los formularios obligatorios para generar recomendaciones",
            "requisito_minimo": "Rellenar por lo menos 1 de las características: Genero, Año y/o Plataforma",
        })


    #Recorrer la lista de especialidades y identificar cuales preguntas les pertenece a cada una 
    #Al identificar las preguntas, se almacenan sus id's en un diccionario asociandolas a la especialidad que les corresponda
    for especialidad in especialidades:
        preguntas = Preguntas_Motivacion.objects.filter(especialidad=especialidad)
        ids_preguntas = preguntas.values_list('id_pregunta', flat=True)
        get_especialidades_preguntas[especialidad.especialidad] = set(ids_preguntas)


    #Recorrido del diccionario para identificar las respuestas registradas del cuestionario por parte del usuario
    #Se suman los id's de cada pregunta, asociandola a la especialidad que las agrupa respectivamente
    for especialidad, ids_preguntas in get_especialidades_preguntas.items():
        suma_escala = Motivacion_Jugador.objects.filter(usuario=usuario_id,pregunta__in=ids_preguntas
    ).aggregate(Sum('escala'))

        ponderaciones_cuestionario[especialidad] = suma_escala['escala__sum'] or 'Sin resultados existentes....'

    #Recorrer las especialidades junto a su nota
    #Si la suma de las preguntas de una especialidad es mayor o igual a 6, se considerará para recomendar un videojuego que pertenezca a aquella
    #Si la suma de las preguntas de las especialidades es menor a 6, no se considerará para las recomendaciones
    for especialidad, i in ponderaciones_cuestionario.items():
        if i >= 6:  
            print("Especialidad considerada para las recomendaciones :", especialidad, i)
            especialidades_recomendacion.append(especialidad)
        else:
            print("Especialidad descartada para recomendaciones :", especialidad, i)
            especialidades_norecomendacion.append(especialidad)


    #Filtración de la queryset de videojuegos, incluyendo a aquellos que cumplan con las especialidades aprobadas del usuario
    if especialidades_recomendacion:
        especialidades_ids = Especialidad.objects.filter(especialidad__in=especialidades_recomendacion).values_list('id_especialidad', flat=True)

        videojuegos = videojuegos.filter(
            id_videojuego__in=Videojuego_Especialidad.objects.filter(
                especialidad__in=especialidades_ids
            ).values('videojuego_id')
        )

    #Filtracion de la queryset, para descartar aquellos videojuegos que cumplan con las especialidad que no ha aprobado el usuario
    if especialidades_norecomendacion:
        especialidades_norecomendacion_ids = Especialidad.objects.filter(especialidad__in=especialidades_norecomendacion).values_list('id_especialidad', flat=True)

        videojuegos = videojuegos.exclude(
            id_videojuego__in=Videojuego_Especialidad.objects.filter(
                especialidad__in=especialidades_norecomendacion_ids
            ).values('videojuego_id')
        )

    #Descartar videojuegos los cuales ya haya aceptado/rechazado la recomendación por parte del usuario
    if usuario_id:
        print(f"Usuario ID: {usuario_id}")
        videojuegos_recomendados = Recomendacion_Usuario.objects.filter(usuario=usuario_id).values_list('videojuego_id', flat=True)
        print(videojuegos_recomendados)
        videojuegos = videojuegos.exclude(id_videojuego__in=videojuegos_recomendados)

    #Verificar y filtrar los datos seleccionados de los formularios
    #Si hay dato introducido, se filtrará para encontrar videojuegos que cumplan con esa característica.
    if genero:
        videojuegos = videojuegos.filter(genero=genero)
    if fecha_lanzamiento:
        videojuegos = videojuegos.annotate(anyo=ExtractYear('fecha_lanzamiento')).filter(anyo=fecha_lanzamiento)
    if plataformas:
        plataformas_ids = Plataforma.objects.filter(consola__in=plataformas).values_list('id_plataforma', flat=True)
        videojuegos = videojuegos.filter(
            id_videojuego__in=Videojuego_Plataforma.objects.filter(
                plataforma__in=plataformas_ids
            ).values('videojuego_id')
        ).distinct()


    #Si la queryset contiene registros, se presentará la lista junto a las especialidades aprobadas del cuestionario.
    #Si la queryset no contiene registros, se informará que no se encontraron recomendaciones con los
    if videojuegos.exists():
        return JsonResponse({
            "Recomendación de videojuegos para el usuario": list(videojuegos.values()),
            "Especialidades Aprobadas del Perfil": especialidades_recomendacion
        })
    else:
        return JsonResponse({
            "message": "No se han encontrado videojuegos recomendados con los filtros seleccionados.",
            "Especialidades Aprobadas del Perfil": especialidades_recomendacion
        })
    
