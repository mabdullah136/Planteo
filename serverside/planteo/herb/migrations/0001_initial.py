# Generated by Django 5.0.4 on 2024-05-25 09:27

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Herb',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('common_name', models.CharField(max_length=255)),
                ('scientific_name', models.CharField(max_length=255)),
                ('optimal_soil_ph_range', models.CharField(max_length=20)),
                ('soil_type_preferences', models.CharField(max_length=255)),
                ('light_requirements', models.CharField(max_length=255)),
                ('water_requirements', models.CharField(max_length=50)),
                ('nutrient_requirements', models.CharField(max_length=50)),
                ('temperature_range', models.CharField(max_length=50)),
                ('humidity_tolerance', models.CharField(max_length=50)),
                ('planting_depth_and_spacing', models.CharField(max_length=50)),
                ('season_in_pakistan', models.JSONField()),
            ],
        ),
    ]
