from django.contrib import admin
from .models import Usuario, Videojuego, Plataforma, Videojuego_Plataforma, Preguntas_Motivacion, Motivacion_Jugador, DecisionRecomendacion, Recomendacion_Usuario, Videojuego_Especialidad, Genero, Nacionalidad, EscalaPregunta, Categoria, Especialidad, Argumento_Videojuego


# Register your models here.
admin.site.register(Usuario)
admin.site.register(Motivacion_Jugador)
admin.site.register(Recomendacion_Usuario)
admin.site.register(Videojuego)
admin.site.register(Plataforma)
admin.site.register(Videojuego_Especialidad)
admin.site.register(DecisionRecomendacion)
admin.site.register(Genero)
admin.site.register(Nacionalidad)
admin.site.register(Preguntas_Motivacion)
admin.site.register(Videojuego_Plataforma)
admin.site.register(Argumento_Videojuego)
admin.site.register(Categoria)
admin.site.register(Especialidad)
admin.site.register(EscalaPregunta)
