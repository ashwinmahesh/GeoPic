# -*- coding: utf-8 -*-
# Generated by Django 1.10 on 2018-07-20 23:24
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('login_registration', '0008_remove_post_poster'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='upload_count',
            field=models.IntegerField(default=0),
        ),
    ]
