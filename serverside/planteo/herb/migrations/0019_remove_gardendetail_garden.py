# Generated by Django 5.0.4 on 2024-07-03 17:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('herb', '0018_gardendetail_user'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='gardendetail',
            name='garden',
        ),
    ]
