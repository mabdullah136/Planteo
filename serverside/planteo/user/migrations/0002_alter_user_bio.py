# Generated by Django 5.0.4 on 2024-04-20 09:53

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='bio',
            field=models.TextField(blank=True, default='Hey there! i am Good'),
        ),
    ]
