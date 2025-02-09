# Generated by Django 5.1.2 on 2024-11-04 15:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('proyecto_gm', '0005_argumento_videojuego_preguntas_motivacion_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='Usuario',
            fields=[
                ('id_usuario', models.AutoField(primary_key=True, serialize=False)),
                ('nombre_usuario', models.CharField(max_length=20, unique=True)),
                ('correo_electronico', models.EmailField(max_length=250)),
                ('password', models.CharField(max_length=250)),
                ('fecha_nacimiento', models.DateField()),
                ('is_active', models.BooleanField(default=True)),
                ('is_staff', models.BooleanField(default=False)),
                ('is_superuser', models.BooleanField(default=False)),
                ('last_login', models.DateTimeField(blank=True, null=True)),
            ],
            options={
                'db_table': 'usuario',
                'managed': False,
            },
        ),
    ]
