from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework.authtoken.views import obtain_auth_token
from .views import UsuarioViewSet, VideojuegoViewSet, GeneroViewSet, Decision_RecomendacionViewSet, PlataformaViewSet, Escala_PreguntaViewSet, NacionalidadViewSet, EspecialidadViewSet, PreguntasMotivacionViewSet, Videojuego_PlataformaViewSet, CategoriaViewSet, Argumento_VideojuegoViewSet, Motivacion_JugadorViewSet, Videojuego_EspecialidadViewSet, Recomendacion_UsuarioViewSet, registro_usuario, LoginView, UserNameView, GenerosVListView, years_videojuego, plataforma_sel, recomendar_videojuego_filtracion
from . import views

router = DefaultRouter()

router.register(r'videojuego', VideojuegoViewSet)
router.register(r'genero', GeneroViewSet)
router.register(r'decision_recomendacion', Decision_RecomendacionViewSet)
router.register(r'plataforma', PlataformaViewSet)
router.register(r'videojuego_plataforma', Videojuego_PlataformaViewSet)
router.register(r'argumento_videojuego', Argumento_VideojuegoViewSet)
router.register(r'nacionalidad', NacionalidadViewSet)
router.register(r'escala_pregunta', Escala_PreguntaViewSet)
router.register(r'categoria', CategoriaViewSet)
router.register(r'especialidad', EspecialidadViewSet)
router.register(r'preguntas_motivacion', PreguntasMotivacionViewSet)
router.register(r'videojuego_especialidad', Videojuego_EspecialidadViewSet)
router.register(r'usuario', UsuarioViewSet)
router.register(r'recomendacion_usuario', Recomendacion_UsuarioViewSet)
router.register(r'motivacion_jugador', Motivacion_JugadorViewSet)




urlpatterns = [
    path('', include(router.urls)),
    path('Login/', LoginView.as_view(), name="Login"),
    path('Registrarse/', registro_usuario, name="Registrarse"),
    path('NombreUsuario/', UserNameView.as_view(), name='NombreUsuario'),
    path('token-auth/', obtain_auth_token, name='api_token_auth'),
    path('GenerosVideojuegos/', GenerosVListView.as_view(), name='GenerosVideojuegos'),
    path('YearsVideojuegos/', years_videojuego, name='YearsVideojuegos'),
    path('PlataformasSel/', views.plataforma_sel, name='PlataformasSel'),
    path('RecomendacionVideojuegos/', recomendar_videojuego_filtracion, name='Combinacion'),

];