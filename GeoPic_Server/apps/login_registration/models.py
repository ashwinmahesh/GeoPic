from django.db import models

class User(models.Model):
    first_name=models.CharField(max_length=255)
    last_name=models.CharField(max_length=255)
    username=models.CharField(max_length=255)
    password=models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Post(models.Model):
    image_path = models.CharField(max_length=255)
    poster = models.ForeignKey(User, related_name='posts')
    latitude = models.DoubleField()
    longtitude = models.DoubleField()
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

# Create your models here.
