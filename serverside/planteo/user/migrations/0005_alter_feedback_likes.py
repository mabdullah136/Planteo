# Generated by Django 5.0.4 on 2024-04-20 13:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0004_remove_feedback_user'),
    ]

    operations = [
        migrations.AlterField(
            model_name='feedback',
            name='likes',
            field=models.IntegerField(blank=True, default=0, null=True),
        ),
    ]
