# Generated by Django 5.0.4 on 2024-06-28 16:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('herb', '0005_remove_location_name_remove_location_nutrient_level_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='herb',
            name='image',
            field=models.ImageField(blank=True, null=True, upload_to=''),
        ),
    ]