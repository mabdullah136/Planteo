# Generated by Django 5.0.4 on 2024-06-22 17:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('herb', '0004_location'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='location',
            name='name',
        ),
        migrations.RemoveField(
            model_name='location',
            name='nutrient_level',
        ),
        migrations.RemoveField(
            model_name='location',
            name='organic_matter_content',
        ),
        migrations.RemoveField(
            model_name='location',
            name='texture',
        ),
        migrations.AddField(
            model_name='location',
            name='nitrogen',
            field=models.FloatField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='location',
            name='phosphorus',
            field=models.FloatField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='location',
            name='potassium',
            field=models.FloatField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='location',
            name='latitude',
            field=models.FloatField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='location',
            name='longitude',
            field=models.FloatField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='location',
            name='soil_ph',
            field=models.FloatField(blank=True, null=True),
        ),
    ]
