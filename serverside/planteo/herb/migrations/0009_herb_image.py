# Generated by Django 5.0.4 on 2024-06-28 18:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('herb', '0008_remove_herb_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='herb',
            name='image',
            field=models.TextField(blank=True, null=True),
        ),
    ]