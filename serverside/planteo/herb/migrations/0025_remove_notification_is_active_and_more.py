# Generated by Django 5.0.4 on 2024-07-04 18:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('herb', '0024_alter_herb_icons'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='notification',
            name='is_active',
        ),
        migrations.AlterField(
            model_name='gardendetail',
            name='icons',
            field=models.TextField(blank=True, null=True),
        ),
    ]
