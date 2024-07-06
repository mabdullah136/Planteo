from django.db import models
import os
from user.models import User

class Month(models.Model):
    name = models.CharField(max_length=20)

    def __str__(self):
        return self.name
    

def plant_image_path(instance, filename):
    user_id = instance.id
    _, file_extension = os.path.splitext(filename)
    new_filename = f"{user_id}plant{file_extension}"
    return os.path.join('store/plants/images', new_filename)

def plant_icons_path(instance, filename):
    user_id = instance.id
    _, file_extension = os.path.splitext(filename)
    new_filename = f"{user_id}plant{file_extension}"
    return os.path.join('store/plants/icons', new_filename)

class Herb(models.Model):
    common_name = models.CharField(max_length=255)
    scientific_name = models.CharField(max_length=255)
    optimal_soil_ph_range = models.CharField(max_length=20)
    soil_type_preferences = models.CharField(max_length=255)
    light_requirements = models.CharField(max_length=255)
    water_requirements = models.CharField(max_length=50)
    nutrient_requirements = models.CharField(max_length=50)
    temperature_range = models.CharField(max_length=50)
    humidity_tolerance = models.CharField(max_length=50)
    planting_depth_and_spacing = models.CharField(max_length=50)
    season_in_pakistan = models.ManyToManyField(Month)
    description=models.TextField(blank=True, null=True)
    image=models.ImageField(upload_to=plant_image_path,blank=True, null=True)
    icons=models.ImageField(upload_to=plant_icons_path,blank=True, null=True)

    def __str__(self):
        return f"{self.common_name} ({self.scientific_name})"
    
class Location(models.Model):
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    soil_ph = models.FloatField(blank=True, null=True)
    nitrogen = models.FloatField(blank=True, null=True)
    phosphorus = models.FloatField(blank=True, null=True)
    potassium = models.FloatField(blank=True, null=True)

class Garden(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE,blank=True, null=True)
    name = models.CharField(max_length=255)
    length = models.CharField(max_length=255)
    width = models.CharField(max_length=255)
    
    def __str__(self):
        return self.name

class GardenDetail(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE,blank=True, null=True)
    garden = models.ForeignKey(Garden, on_delete=models.CASCADE, related_name='details',blank=True, null=True)
    herb = models.ForeignKey(Herb, on_delete=models.CASCADE,blank=True, null=True)
    row_no = models.IntegerField()
    column_no = models.IntegerField()
    plant_name = models.CharField(max_length=255)
    icons=models.ImageField(upload_to=plant_icons_path,blank=True, null=True)


    
class Notification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateField(blank=True, null=True)
    time = models.TimeField(blank=True, null=True)
    garden_name=models.CharField(max_length=255,blank=True,null=True)

