# Generated by Django 5.1.3 on 2024-11-09 14:05

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Sentence',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('chinese_sentence', models.TextField()),
                ('hakka_words', models.JSONField()),
            ],
        ),
    ]
