from rest_framework import serializers
from .models import Usuario, Genero, Nacionalidad, DecisionRecomendacion, Plataforma, EscalaPregunta, Especialidad, Videojuego, Argumento_Videojuego, Preguntas_Motivacion, Videojuego_Plataforma, Categoria, Videojuego_Especialidad, Recomendacion_Usuario, Motivacion_Jugador

class GeneroSerializer(serializers.ModelSerializer):
    class Meta:
        model = Genero
        fields = '__all__'

class NacionalidadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Nacionalidad
        fields = '__all__'

class PlataformaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Plataforma
        fields = '__all__'

class Decision_RecomendacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = DecisionRecomendacion
        fields = '__all__'

class Escala_PreguntaSerializer(serializers.ModelSerializer):
    class Meta:
        model = EscalaPregunta
        fields = '__all__'

class EspecialidadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Especialidad
        fields = '__all__'

class Argumento_VideojuegoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Argumento_Videojuego
        fields = '__all__'   

class VideojuegoSerializer(serializers.ModelSerializer):
    argumento_videojuego=serializers.SerializerMethodField()
    class Meta:
        model = Videojuego
        fields = '__all__'

    def get_argumento_videojuego(self, obj):
        
        return obj.argumento_videojuego
     

class Videojuego_PlataformaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Videojuego_Plataforma
        fields = '__all__'

class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = '__all__'

class PreguntasMotivacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Preguntas_Motivacion
        fields = '__all__'

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = '__all__'

class Videojuego_EspecialidadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Videojuego_Especialidad
        fields = '__all__'

class Recomendacion_UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recomendacion_Usuario
        fields = '__all__'

class Motivacion_JugadorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Motivacion_Jugador
        fields = '__all__'
