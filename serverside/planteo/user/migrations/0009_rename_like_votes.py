# Generated by Django 5.0.4 on 2024-05-25 07:11

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0008_remove_feedback_likes_like'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Like',
            new_name='Votes',
        ),
    ]
