# Generated by Django 5.0.4 on 2024-07-04 18:28

import herb.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('herb', '0025_remove_notification_is_active_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='gardendetail',
            name='icons',
            field=models.ImageField(blank=True, null=True, upload_to=herb.models.plant_icons_path),
        ),
    ]
