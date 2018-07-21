from django.db import models

class User(models.Model):
    first_name=models.CharField(max_length=255)
    last_name=models.CharField(max_length=255)
    username=models.CharField(max_length=255)
    password=models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    upload_count = models.IntegerField(default = 0)

class Post(models.Model):
    # image = models.TextField()
    imagePath = models.CharField(max_length=255, default = "")
    first_name=models.CharField(max_length=255)
    last_name=models.CharField(max_length=255)
    username=models.CharField(max_length=255)
    # poster = models.ForeignKey(User, related_name='posts')
    latitude = models.CharField(max_length=60)
    longitude = models.CharField(max_length=60)
    location = models.CharField(max_length=255)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)


# Create your models here.
