from django.db import models
from django.contrib.auth.models import AbstractUser
import os
from django.db import models


def user_image_path(instance, filename):
    user_id = instance.id
    _, file_extension = os.path.splitext(filename)
    new_filename = f"{user_id}pfp{file_extension}"
    return os.path.join('store/images', new_filename)

def plant_image_path(instance, filename):
    user_id = instance.id
    _, file_extension = os.path.splitext(filename)
    new_filename = f"{user_id}plant{file_extension}"
    return os.path.join('store/plants/images', new_filename)

class User(AbstractUser):
    email=models.EmailField(unique=True)
    phone=models.CharField(max_length=11, default="")
    image = models.ImageField(upload_to=user_image_path, blank=True, null=True)
    is_social_login = models.BooleanField(default=False)
    is_online = models.BooleanField(default=False)
    bio = models.TextField(blank=True,default='Hey there! i am Good')
    fcm_token=models.TextField(blank=True, null=True)
    def __str__(self):
        return self.username

class EmailOtp(models.Model):
    email = models.ForeignKey(User, on_delete=models.CASCADE)
    otp = models.CharField(max_length=6)
    expiration_time = models.TimeField()

class UserSubmittedImage(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    image = models.ImageField(upload_to=plant_image_path,blank=True, null=True,)
    upload_date = models.DateTimeField(auto_now_add=True)
    subject=models.CharField(max_length=50)
    description=models.TextField(blank=True, null=True)

class Feedback(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    info = models.ForeignKey(UserSubmittedImage, on_delete=models.CASCADE)
    feedback_text = models.TextField(blank=True, null=True)
    total_votes = models.PositiveIntegerField(default=0)


class Votes(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    feedback_info = models.ForeignKey(Feedback, on_delete=models.CASCADE)
    likes = models.BooleanField(default=False, blank=True, null=True)